//
//  Enviroment.swift
//  NetworkCore
//
//  Created by Jade Silveira on 03/12/21.
//

import Foundation

public enum Enviroment {
    public enum Host {
        public static var api: String? {
            return get("API_HOST")
        }
    }
    
    private static func get<T>(_ name: String, bundle: Bundle = Bundle.main) -> T? {
        guard let enviromentSetting = bundle.infoDictionary?["EnviromentSettings"] as? [String: AnyObject],
            let key = enviromentSetting[name]
        else { return nil }
        
        return key as? T
    }
}
