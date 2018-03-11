import Foundation
import Nanomsg

class DaemonReceiver: NSObject {
    override func awakeFromNib() {
        print("DaemonReceiver alive")
        DispatchQueue.global(qos: .background).async {
            do {
                let socket = try Socket(.PULL)
                try socket.connect("ipc:///tmp/battid.ipc")
                while true {
                    let line: String = try socket.recv()
                    let parts = line.split(separator: "\t")
                    if parts.count != 2 {
                        print("Received invalid data from daemon")
                        continue
                    }
                    let body = [
                        "address": parts[0],
                        "charge": parts[1]
                    ]
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("BatteryStateChange"), object: body)
                    }
                }
            } catch {
                // todo better error handling
                print(error)
            }

        }
    }
}
