//
//  DeviceQuery.swift
//  BatiDaemon
//
//  Created by Jari on 04/11/2017.
//

import Foundation
import IOBluetooth

class DeviceQuery {
    var device: IOBluetoothDevice
    var packetlogger: Process?
    
    init(_ device: IOBluetoothDevice) {
        self.device = device
        
        var id = BluetoothRFCOMMChannelID();
        device.handsFreeDeviceServiceRecord().getRFCOMMChannelID(&id);
        
        print("Registering channel for dev \(device.addressString!) on chan \(id)")
        
        // todo: should we care about the direction? seems like it's always outgoing.
        IOBluetoothRFCOMMChannel.register(forChannelOpenNotifications: self, selector: #selector(channelOpened(notification:channel:)), withChannelID: id, direction: kIOBluetoothUserNotificationChannelDirectionAny)
    }
    
    @objc func channelOpened(notification: IOBluetoothUserNotification, channel: IOBluetoothRFCOMMChannel) {
        guard channel.getDevice().addressString == device.addressString else {
            return
        }
        
        print("Channel opened")
        do {
            let packetLogger = PacketLogger(deviceAddress: channel.getDevice().addressString)
            try hailMary(channel: channel)
            packetLogger.waitForRFCOMM()
        } catch {
            print("Failed to process channel: \(error)")
        }
    }
    
    func hailMary(channel: IOBluetoothRFCOMMChannel) throws {
        // basically dumps a whole lot of AT battery status commands to the device,
        // in the hope that it responds to us with something we can use
        print("Sending hail mary...")
        try writeStringToChannel(channel, string: "\r\n+XAPL=?\r\n")
        try writeStringToChannel(channel, string: "\r\n+CSRBATT?\r\n")
    }
    
    func writeStringToChannel(_ channel: IOBluetoothRFCOMMChannel, string: String) throws {
        let nss = (string as NSString)
        let cs = nss.utf8String
        var buffer = UnsafeMutablePointer<Int8>(mutating: cs)
        
        defer {
            buffer?.deinitialize()
        }
        
        let ret = channel.writeAsync(buffer, length: UInt16(nss.length), refcon: nil)
        guard ret == 0 else {
            throw NSError(domain: "IOReturn", code: Int(ret), userInfo: ["errorString": IOReturnToString(ret)])
        }
    }
}
