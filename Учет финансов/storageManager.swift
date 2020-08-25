//
//  storageManager.swift
//  Учет финансов
//
//  Created by mac on 18.08.2020.
//  Copyright © 2020 Sofya Zakharova. All rights reserved.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ object: Speng) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    
    static func deliteObject(_ object: Speng) {
        try! realm.write {
            realm.delete(object)
        }
    }
    static func saveLimit(_ object: Limit) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    
    static func deliteLimit(_ object: Limit) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
}
