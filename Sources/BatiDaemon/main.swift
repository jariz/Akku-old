import Nanomsg
import IOBluetooth

func start () throws {
//    guard getuid() == 0 else {
//        print("Error, should be ran as root")
//        return
//    }
    
    RunLoop.main.perform {
        do {
            print("Starting socket...")
            let sock = try Socket(.PULL)
            try sock.bind("ipc:///tmp/bati-devices.ipc")
            while(true) {
                let address: String = try sock.recv()
                if let device = IOBluetoothDevice.init(addressString: address) {
                    guard device.isConnected() && device.isHandsFreeDevice else {
                        print("Sanity check failed: attempted to connect to a device that was either not connected or not a handsfree device")
                        continue
                    }
                    var query = DeviceQuery(device)
                }
            }
        }
        catch {
            print("Fatal error: \(error)")
            exit(1)
        }
    }

    DispatchQueue.global(qos: .background).async {
        do {
            print("Push socket opening...")
            let sock = try Socket(.PUSH)
            try sock.connect("ipc:///tmp/bati-devices.ipc")
            while true {
                for device: IOBluetoothDevice in IOBluetoothDevice.pairedDevices() as! [IOBluetoothDevice] {
                    guard device.isConnected() && device.isHandsFreeDevice else {
                        continue
                    }
                    try sock.send(device.addressString)
                }
                sleep(9999)
            }
        } catch {
            print("Fatal error (in push loop): \(error)")
            exit(1)
        }
    }
    
    RunLoop.main.run()
}

try start()
