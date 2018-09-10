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

class MeasureViewController: UIViewController {
    
    @IBOutlet weak var MeasureToDevice: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MeasureToDevice.backgroundColor = UIColor.lightGray
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var DeviceInfo: UILabel!
    
    @IBAction func DeviceListButton(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let deviceVC = storyboard.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListViewController
        self.navigationController?.pushViewController(deviceVC, animated: true)
        //self.performSegue(withIdentifier: "MeasurementToDeviceList", sender: nil)
    }
    
}
