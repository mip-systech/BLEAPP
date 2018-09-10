//
//  RealmFunction.swift
//  Sample_Bluetooth
//
//  Created by ミップ on 2018/08/31.
//  Copyright © 2018年 mips.systech. All rights reserved.
//

import Foundation
import RealmSwift

class Repository {
    
    private var debug: String?
    //
    private var deviceRealm: Realm!
    private var deviceRealmData: Results<DeviceRealm>!
    
    
    func addDeviceRealm(data: [Data]) {
        try! deviceRealm.write {
            deviceRealm.add(DeviceRealm(value: data), update:true)
        }
    }
    func deleteDeviceRealm(at Index:Int) {
        try! deviceRealm.write {
            deviceRealm.delete(deviceRealmData[Index])
        }
    }
    func getConstructDeviceRealm() {
        
    }
}
