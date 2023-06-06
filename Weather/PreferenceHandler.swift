//
//  UserPreferences.swift
//  Weather
//
//  Created by Sai Pavan Neerukonda on 6/5/23.
//  Copyright © 2023 Sai Pavan Neerukonda. All rights reserved.
//

import Foundation

open class PreferenceHandler {
    /**
     Always use the class name as the file name and start the name with a capital letter.
     Changes Done : Changed the class name from userDefault to file name PreferenceHandler
     */
    class func saveValue(_ value: Any, forKey key: String){
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    class func getValuesForKey(_ key : String?) -> AnyObject? {
        let userDefault = UserDefaults.standard
        if key != nil  {
            if let value = userDefault.object(forKey: key!) {
                return value as AnyObject?
            }
            return nil
        }
        return nil
    }
}
