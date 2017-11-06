//
//  PacketLogger.swift
//  BatiDaemon
//
//  Created by Jari on 05/11/2017.
//

import Foundation

class PacketLogger {
    var process: Process;
    var fileHandle: FileHandle;
    var deviceAddress: String;
    
    init (deviceAddress: String) {
        process = Process()
        process.launchPath = "/Users/Jari/Documents/packetlogger" // todo run packetlogger from cwd
        process.arguments = []
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        fileHandle = pipe.fileHandleForReading
        self.deviceAddress = deviceAddress
    }
    
    func waitForRFCOMM () {
        var buffer: String = ""
        while true {
            let data = fileHandle.readData(ofLength: 1)
            let decoded = String(data: data, encoding: String.Encoding.utf8)
            if decoded == "\n" {
                processLine(buffer)
                buffer = ""
            } else if decoded != nil {
                buffer.append(decoded!)
            }
        }
    }
    
    fileprivate func processLine (_ line: String) {
        let parts = line.split(separator: "\t")
        let addressNormalized = deviceAddress.replacingOccurrences(of: "-", with: ":").uppercased()
        if parts[1] == "RFCOMM RECEIVE" && parts[4] == addressNormalized {
            let parts = parts[5].split(separator: " ")
            let packet = parts[parts.count - 1]
            
            if packet.count > 2 {
                let startIndex = packet.index(packet.startIndex, offsetBy: 1)
                let endIndex = packet.index(packet.endIndex, offsetBy: -2)
                let command = String(packet[startIndex...endIndex])
                print(command)
            }
        }
    }
}
