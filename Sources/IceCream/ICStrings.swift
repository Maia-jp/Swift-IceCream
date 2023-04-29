//
//  ICStrings.swift
//  IceCream
//
//  Created by Joao Pedro Monteiro Maia on 28/04/23.
//  URL: https://github.com/Maia-jp/Swift-IceCream

import Foundation


public extension IceCream{
    public enum ICPrivacyLevel{
        case Puplic     // Always print
        case Sensitive  // Only print if debbug
        case Private    // Never print
    }
}

public extension String.StringInterpolation {
    mutating func ICPrivacyMask(_ string:String, privacy:IceCream.ICPrivacyLevel){
        switch privacy {
        case .Puplic:
            appendInterpolation(string)
        case .Sensitive:
            if IceCream.logLevel.asInt <= ICLogLevelConfiguration.DEBUG.asInt{
                appendInterpolation(string)
            }else{
                let protectedString = String(repeating: "*", count: string.count)
                appendInterpolation(protectedString)
            }
            
        case .Private:
            let protectedString = String(repeating: "█", count: Int.random(in: 5...10))
            appendInterpolation(protectedString)
        }
    }
}
