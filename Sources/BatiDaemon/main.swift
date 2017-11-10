import Nanomsg
import Foundation

if getuid() != 0 {
    print("Error, should be ran as root")
    exit(1)
}

class BattiDaemon {
    var packetLogger: PacketLogger
    var sock: Socket
    
    func batteryChange (percentage: Int, address: String) throws {
        print("battery change! \(percentage)% (\(address))")
        try sock.send(address + "\t" + String(percentage))
    }
    
    init () {
        do {
            print("Starting PL...")
            packetLogger = PacketLogger()
            
            print("Starting socket...")
            sock = try Socket(.PUSH)
            try sock.bind("ipc:///tmp/battid.ipc")
        }
        catch {
            print("Fatal error: \(error)")
            exit(1)
        }
    }
}


var daemon = BattiDaemon()
if #available(OSX 10.12, *) {
    RunLoop.main.perform {
        daemon.packetLogger.startReading()
    }
} else {
    print("todo: support < 10.12")
}

RunLoop.main.run()
