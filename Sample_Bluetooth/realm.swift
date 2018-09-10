//
//  realm.swift
//  Sample_Bluetooth
//
//  Created by ミップ on 2018/08/28.
//  Copyright © 2018年 mips.systech. All rights reserved.
//

import Foundation
import RealmSwift

class DeviceRealm: Object {
    @objc dynamic var key = ""
    @objc dynamic var name = ""
    @objc dynamic var pereipheralIdentify = ""
    @objc dynamic var connectState = 0
    
    override static func primaryKey() -> String? {
        return "key"
    }
}


