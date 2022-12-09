//
//  Dictionary+Extension.swift
//  Pods-ZegoPlugin
//
//  Created by Kael Ding on 2022/12/7.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    var jsonString:String {
        do {
            let stringData = try JSONSerialization.data(withJSONObject: self as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let string = String(data: stringData, encoding: String.Encoding.utf8){
                return string
            }
        } catch _ {
            
        }
        return ""
    }
}
