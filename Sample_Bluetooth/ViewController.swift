//
//  ViewController.swift
//  Sample_Bluetooth
//
//  Created by ミップ on 2018/08/24.
//  Copyright © 2018年 mips.systech. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation


class ViewController: UIViewController {

    
    @IBOutlet weak var ToDeviceButton: UIButton!
    @IBOutlet weak var ToMeasureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.lightGray
        // ToDeviceButton
        ToDeviceButton.backgroundColor = UIColor.white
        ToMeasureButton.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    //@IBAction func ToPageButton(_ sender: UIButton) {
    //    let storyboard: UIStoryboard = self.storyboard!
    //    let senderBtnTag: Int = sender.tag
    //    print(senderBtnTag)
    //    var sendVC:UIViewController
    //    switch senderBtnTag {
    //    case 1:
    //        sendVC = storyboard.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListViewController
    //    case 2:
    //        sendVC = storyboard.instantiateViewController(withIdentifier: "MeasurementVC") as! MeasureViewController
    //    default:
    //        sendVC = storyboard.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListViewController
    //    }
    //    self.navigationController?.pushViewController(sendVC, animated: true)
    //}
    
    //@IBAction func DeviceListButton(_ sender: Any) {
    //    //self.performSegue(withIdentifier: "TopToDeviceList", sender: nil)
    //    let storyboard: UIStoryboard = self.storyboard!
    //    let deviceVC = storyboard.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListViewController
    //    self.navigationController?.pushViewController(deviceVC, animated: true)
    //}
    
    //@IBAction func MeasurementButton(_ sender: Any) {
    //    //self.performSegue(withIdentifier: "TopToMeasurement", sender: nil)
    //    let storyboard: UIStoryboard = self.storyboard!
    //    let measurementVC = storyboard.instantiateViewController(withIdentifier: "MeasurementVC") as! MeasureViewController
    //    self.navigationController?.pushViewController(measurementVC, animated: true)
    //}
}

