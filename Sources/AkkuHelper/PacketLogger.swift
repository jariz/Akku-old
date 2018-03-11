import Foundation

class PacketLogger {
    var process: Process
    var fileHandle: FileHandle
    let chunkSize = 4096
    var buffer: Data
    var delimiter: Data = "\n".data(using: String.Encoding.utf8)!
    
    init () {
        process = Process()
        process.launchPath = "/bin/bash" // todo package packetlogger along with app
        process.arguments = ["-c", "/Applications/PacketLogger.app/Contents/Resources/packetlogger convert -f tmpar -s > grep \"RFCOMM Receive\""]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        fileHandle = pipe.fileHandleForReading
        buffer = Data(capacity: chunkSize)
    }
    
    func startReading () {
        while process.isRunning {
            if let line = readLine() {
                processLine(line)
            }
        }
    }
    
    func readLine () -> String? {
        while process.isRunning {
            if let range = buffer.range(of: delimiter) {
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: String.Encoding.utf8)
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    if let line = String(data: buffer as Data, encoding: String.Encoding.utf8) {
                        return line
                    }
                    buffer.count = 0
                }
                break
            }
        }
        return nil
    }
    
    fileprivate func processLine (_ line: String) {
        let parts = line.split(separator: "\t")
        
        if parts.count > 1 && parts[1] == "RFCOMM RECEIVE" {
            let address = parts[4]
            let parts = parts[5].split(separator: " ")
            let packet = parts[parts.count - 1]
            
            if packet.count > 2 {
                let startIndex = packet.index(packet.startIndex, offsetBy: 1)
                let endIndex = packet.index(packet.endIndex, offsetBy: -2)
                let command = String(packet[startIndex...endIndex])
                do {
                    try parseATCommand(command, address: String(address))
                }
                catch {
                    print(error)
                }
            }
        }
        
    }
}
