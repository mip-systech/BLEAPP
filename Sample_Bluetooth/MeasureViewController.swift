//
//  MeasureViewController.swift
//  Sample_Bluetooth
//
//  Created by ミップ on 2018/08/24.
//  Copyright © 2018年 mips.systech. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import RealmSwift


class MeasureViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!//
    let serviceUUID:CBUUID = CBUUID(string: "135E7F5F-D98B-413C-A0BE-CAC8E3F53280")
    let charactaristicUUID_value:CBUUID = CBUUID(string: "9E21E0B1-6EAA-47B0-916A-23FAF3984207")
    let charactaristicUUID_name:CBUUID = CBUUID(string: "810E2E4E-2E03-46F5-91FB-A238A8E127B5")
    let characteristicUUID_id    = CBUUID(string: "362114A3-CDD5-4A68-812B-C2C63A1E0FA5")
    var devicename:String?
    var deviceid:String?
    var devicevalue:String?
    
    
    
    @IBOutlet var deviceID: UILabel!
    @IBOutlet var deviceNAME: UILabel!
    
    @IBOutlet var value01: UITextField!
    @IBOutlet var value02: UITextField!
    @IBOutlet var value03: UITextField!
    @IBOutlet var value04: UITextField!
    @IBOutlet var value05: UITextField!
    @IBOutlet var value06: UITextField!
    
    var focus_textfield: UITextField!
    
    // Realm
    var allDevice: Results<DeviceInfoModel>!
    let deviceInfo = DeviceInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        
        self.value01.delegate = self
        self.value02.delegate = self
        self.value03.delegate = self
        self.value04.delegate = self
        self.value05.delegate = self
        self.value06.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画面遷移時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.peripheral != nil{
            //切断
            self.centralManager.cancelPeripheralConnection(self.peripheral)
            print("切断")
            //デバイス情報を初期化
            resetUI()
        }
    }
    
    
    @IBAction func DeviceListButton(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let deviceVC = storyboard.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListViewController
        //self.navigationController?.pushViewController(deviceVC, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textfield touch")
        self.focus_textfield = textField
        return true
    }
    
    //centralManagerが更新した時に呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        insertlog(log: "state:\(central.state)")
        switch central.state{
        case CBManagerState.poweredOn:
               //self.centralManager.scanForPeripherals(withServices: [self.serviceUUID], options: nil)
            //接続したことがあるペリフェラルから接続
            let realm = getRealm()
            let datas = realm.objects(DeviceInfoModel.self).filter("connectState = 1")
            let peluuid_str: NSString = datas.first?.pereipheralIdentify as! NSString
            let peluuid:NSUUID = NSUUID(uuidString: peluuid_str as String)!
            let pel = self.centralManager.retrievePeripherals(withIdentifiers: [peluuid as UUID])
            
            self.peripheral = pel.first
            self.centralManager.connect(self.peripheral, options: nil)
            
               insertlog(log: "ペリフェラルをスキャン開始")
            break
        default:
            break
        }
    }
   
    
    /*
    @IBAction func scan(_ sender: Any) {
        print("scanstart")
        self.centralManager.scanForPeripherals(withServices: [self.serviceUUID], options: nil)
    }
    
    //ペリフェラルを検出した時に呼び出される
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("ペリフェラル検出:\(peripheral.identifier)")
        insertlog(log: "ペリフェラル検出:\(peripheral.identifier)")
        let uuid = peripheral.identifier.uuidString
        //if uuid == "090C2471-2BF2-6448-5C28-BA3C2C01645B"{//ミップスタッフのiphone(2) DBに登録されている装置のUUIDに変更
        
        let realm = getRealm()
        let datas = realm.objects(DeviceInfoModel.self).filter("connectState = 1")
        //print(datas.first)
        //if uuid == "91B7541E-A6DC-2484-2DB4-57CF8F0A114E"{//テスト用iPad
        if uuid == datas.first?.pereipheralIdentify{
            self.peripheral = peripheral
            self.centralManager.connect(self.peripheral, options: nil)
            insertlog(log: "ペリフェラルに接続開始:\(self.peripheral.identifier)")
        }
    }
    */
    //ペリフェラとのコネクトに成功した時に呼び出される
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        insertlog(log: "ペリフェラルとの接続成功:\(peripheral.identifier)")
        peripheral.delegate = self
        //let UUID = CBUUID(string: "135E7F5F-D98B-413C-A0BE-CAC8E3F53280")
        peripheral.discoverServices([self.serviceUUID])
        insertlog(log: "ペリフェラルのサービスを検索")
        //peripheral.discoverServices(nil)
    }
    //ペリフェラルのコネクトに失敗した時に呼び出される
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        insertlog(log: "ペリフェラルとの接続失敗")
    }
    //ペリフェラルのサービスを検出した時に呼び出される
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        insertlog(log: "サービス検出")
        if error != nil{
            insertlog(log: "\(error.debugDescription)")
            return
        }
        
        //キャラクタリスティック 検索
        peripheral.discoverCharacteristics(nil, for: (peripheral.services?.first)!)
        insertlog(log: "ペリフェラルのキャラクタリスティック を検索")
    }
    
    //キャラクタリスティック 検出じに呼び出される
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let characteristics = service.characteristics
        if error != nil{
            insertlog(log:"\(error.debugDescription)")
            return
        }
        insertlog(log: "\(String(describing: service.characteristics?.count))個のキャラクタリスティック を検出")
        
        for obj in characteristics!{
            if let characteristic = obj as? CBCharacteristic{
                
                print(characteristic.uuid)
                switch characteristic.uuid{
                case self.charactaristicUUID_name:
                    insertlog(log: "namenのキャラクタリスティック を検出")
                    peripheral.readValue(for: characteristic)
                case self.charactaristicUUID_value:
                     insertlog(log: "valueのキャラクタリスティック を検出")
                    peripheral.setNotifyValue(true, for: characteristic)
                case self.characteristicUUID_id:
                    insertlog(log: "idのキャラクタリスティック を検出")
                    peripheral.readValue(for: characteristic)
                default:
                    insertlog(log: "指定外のキャラクタリスティック を検出")
                }
            }
        }
        
    }
    
    //readリクエストにレスポンスが返ってきたら呼び出される
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        insertlog(log: "readリクエストに対するレスポンスを検出")
        switch characteristic.uuid{
        case self.charactaristicUUID_name:
            self.devicename = String(data: characteristic.value!, encoding: .utf8)
            insertlog(log: "\(self.devicename!)")
            self.deviceNAME.text = "装置名：\(self.devicename!)"
        case self.characteristicUUID_id:
            self.deviceid = String(data: characteristic.value!, encoding: .utf8)
            insertlog(log: "\(self.deviceid!)")
            self.deviceID.text = "装置ID：\(self.deviceid!)"
        case self.charactaristicUUID_value:
            self.devicevalue = String(data: characteristic.value!, encoding: .utf8)
            insertlog(log: "\(self.devicevalue!)")
            self.focus_textfield.text = self.devicevalue!
            //self.value.text = ("\(self.value.text!)\n\(self.devicevalue)")
            
            //入力欄移動
            self.focus_textfield.resignFirstResponder()
            let nextTag = self.focus_textfield.tag + 1
            if let nextTextField = self.view.viewWithTag(nextTag){
                nextTextField.becomeFirstResponder()
            }
            
        default:
            insertlog(log: "指定外のキャラクタリスティック のレスポンスを検出")
        }
    }
    
    func resetUI(){
        self.value01.text = ""
        self.value02.text = ""
        self.value03.text = ""
        self.value04.text = ""
        self.value05.text = ""
        self.value06.text = ""
        self.deviceID.text = "装置ID："
        self.deviceNAME.text = "装置名："
    }
    
    
    @IBOutlet var tableview: UITableView!
    var cellstr = [String]()
    //デバック表示
    func insertlog(log:String){
        cellstr.append("\(log)")
        print("\(log)")
        self.tableview.reloadData()
    }
    
    
    
    
    
    //セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellstr.count
    }
    
    //セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = cellstr[indexPath.row]
        return cell
    }
    //セルを選択した時に呼ばれるメソッド（必須）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select cell")
    }
}

extension MeasureViewController: accessRealm {
    
    typealias ResultType = Object
    
    func getRealm() -> Realm {
        let realm = try! Realm()
        return realm
    }
    //func getAll() -> Results<ResultType>? {
    //    let realm = getRealm()
    //    return realm.objects(DeviceInfoModel.self).sorted(byKeyPath: "name")
    //}
    func add(object: ResultType){
        let realm = getRealm()
        try! realm.write {
            realm.add(object)
        }
    }
    func getByKey(key: String) -> ResultType? {
        let realm = getRealm()
        let datas = realm.objects(DeviceInfoModel.self).filter("key = '\(key)'")
        if datas.count > 0 {
            return datas[0]
        } else {
            return nil
        }
    }
    func getByStatus(status: Int) -> ResultType? {
        let realm = getRealm()
        let datas = realm.objects(DeviceInfoModel.self).filter("connectState = '\(status)'")
        if datas.count > 0 {
            return datas[0]
        } else {
            return nil
        }
    }
    func set(data: Object) -> Bool {
        let realm = getRealm()
        do {
            try realm.write {
                realm.add(data,update:true)
            }
            return true
        } catch {
            print("\n Error")
        }
        return false
    }
    func delete(data: Object) -> Bool {
        let realm = getRealm()
        do {
            try realm.write {
                realm.delete(data)
            }
            return true
        } catch {
            print("\n Error:")
        }
        return false
    }
}

