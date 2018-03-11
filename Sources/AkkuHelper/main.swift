import Nanomsg
import Foundation

if getuid() != 0 {
    print("Error, should be ran as root")
    exit(1)
}

class BattiDaemon {
    var packetLogger: PacketLogger
    var sock: Socket
    
    static var PATH = "/tmp/battid.ipc"
    
    func batteryChange (percentage: Int, address: String) throws {
        // convert to IOBluetooth format
        let normalizedAddress = address.replacingOccurrences(of: ":", with: "-").lowercased()
        print("battery change! \(percentage)% (\(address))")
        try sock.send(normalizedAddress + "\t" + String(percentage))
    }
    
    init () {
        do {
            print("Starting PL...")
            packetLogger = PacketLogger()
            
            print("Starting socket...")
            sock = try Socket(.PUSH)
            try sock.bind("ipc://" + BattiDaemon.PATH)
            
            print("Changing socket permissions...")
            try changeFilePermissions()
        }
        catch {
            print("Fatal error: \(error)")
            exit(1)
        }
    }
    
    func changeFilePermissions () throws {
        try FileManager.default.setAttributes([FileAttributeKey.posixPermissions: 0o777], ofItemAtPath: BattiDaemon.PATH) // todo make readonly
    }
}


var daemon = BattiDaemon()
daemon.packetLogger.startReading()
RunLoop.current.run()

