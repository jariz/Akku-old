//
//  parseCommand.swift
//  BatiDaemon
//
//  Created by Jari on 05/11/2017.
//

import Foundation

extension String: Error {}

func parseATCommand(_ command: String, address: String) throws {
    if command.count < 4 {
        return
    }
    let endOfAT = command.index(command.startIndex, offsetBy: 3)
    let start = command[..<endOfAT]
    if start != "AT+" {
        return
    }
    
    // https://en.wikipedia.org/wiki/Hayes_command_set#Description
    
    if let registerIndex = command[endOfAT...].index(of: "=") {
        let register = command[endOfAT..<registerIndex]
        let valueStart = command.index(registerIndex, offsetBy: 1)
        let value = command[valueStart...]
        
        switch register {
        case "IPHONEACCEV": // Apple format: https://developer.apple.com/hardwaredrivers/BluetoothDesignGuidelines.pdf
            // we skip the keyvalue count because packetlogger truncates everything over a single pair out of the packet eitherway 👿
            let keyStart = value.index(value.startIndex, offsetBy: 2)
            guard let keyEnd = value[keyStart...].index(of: ",") else {
                throw "Invalid keyvalue format"
            }
            let key = value[keyStart..<keyEnd]
            
            let valStart = value.index(keyEnd, offsetBy: 1)
            let valEnd = value.index(valStart, offsetBy: 1)
            let val = value[valStart..<valEnd]
            
            switch key {
            case "1": // battery
                try daemon.batteryChange(percentage: (1 + Int(val)!) * 10, address: address)
            default:
                throw "Unsupported key type \(key) with value \(val)"
            }
            
        case "CSRBATT": // this yields 0 results on google but i've seen a headset send it so...
            try daemon.batteryChange(percentage: 1 + Int(value)! * 10, address: address)
        default:
            print("Unknown register command", register)
        }
    }
    
}
