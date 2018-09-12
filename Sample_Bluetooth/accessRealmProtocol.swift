//
//  accessRealmProtocol.swift
//  Sample_Bluetooth
//
//  Created by ミップ on 2018/09/11.
//  Copyright © 2018年 mips.systech. All rights reserved.
//

import Foundation
import RealmSwift

protocol accessRealm {
    //typealias ResultType = Object
    associatedtype ResultType: Object
    func getRealm() -> Realm
    //func getAll() -> Results<ResultType>?
    func add(object: ResultType)
    func getByKey(key: String) -> ResultType?
    func getByStatus(status: Int) -> ResultType?
    func set(data: Object) -> Bool
    func delete(data: Object) -> Bool
    
}
