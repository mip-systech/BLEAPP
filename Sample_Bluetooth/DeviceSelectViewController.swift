//
//  DeviceSelectViewController.swift
//  Sample_Bluetooth
//
//  Created by ミップ on 2018/08/27.
//  Copyright © 2018年 mips.systech. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import RealmSwift

class DeviceSelectViewController: UIViewController {
    
    var tableView: UITableView!
    var serviceUuids = [String]()
    var services = [CBService]()
    var targetPeripheral: CBPeripheral!
    var centralManager: CBCentralManager!
    var targetService: CBService!
    var readValues = [Data]()
    
    // サービスが見つかった時、仮の目的serviceUUID
    let targetServiceUUID : String = "0x180D"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barH:CGFloat = UIApplication.shared.statusBarFrame.size.height
        let dispW:CGFloat = self.view.frame.width
        let dispH:CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barH, width: dispW, height: dispH - barH))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension DeviceSelectViewController: CBPeripheralDelegate {
    func setPeripheral(target: CBPeripheral) {
        self.targetPeripheral = target
    }
    func setCentralManager(manager: CBCentralManager) {
        self.centralManager = manager
    }
    func searchService() {
        print("searchService")
        self.targetPeripheral.delegate = self
        // service の探索条件(serviceUUID)をどう設定するか？複数 or 一つ(let targetServiceUUID)？
        self.targetPeripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("discoverServicesError: \(error.debugDescription)")
            return
        }

        // 発見した service 全てを格納(暗に探索条件を複数serviceで想定)
        for service in peripheral.services! {
            serviceUuids.append(service.uuid.uuidString)
            services.append(service)
            if service.uuid.uuidString == targetServiceUUID {
                targetService = service
            }
        }
        // 目的service が見つからなかった場合
        if targetService == nil {
            
        }
        self.targetPeripheral.discoverCharacteristics(nil, for: self.targetService)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("discoverCharacteristicError: \(error.debugDescription)")
            return
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("updateValue characteristic: \(error.debugDescription)")
            return
        }
    }
}
extension DeviceSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("ServiceUuid: \(serviceUuids[indexPath.row])")
    }
}
extension DeviceSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceUuids.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "SVcell")
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.red
        cell.textLabel!.text = "\(serviceUuids[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel!.text = "Service"
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
        return cell
    }
}
