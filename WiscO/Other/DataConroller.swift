//
//  DataConroller.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import CoreData
import Foundation


class DataConroller: ObservableObject{
    var container: NSPersistentContainer
    init(name:String) {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores{
            _, error in
            if let error = error{
                print("CoreData Error: \(error.localizedDescription)")
            }
        }
    }
}
