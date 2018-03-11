import Foundation
import Cocoa
import IOBluetooth

class StatusMenuController: NSObject {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var progressbar: NSProgressIndicator!
    var storyboard: NSStoryboard?;
    
    var batteryStates: [String: String] = [:]
    
    override func awakeFromNib() {
        buildMenu()
        
        storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        statusItem.menu = menu;
        
        IOBluetoothDevice.register(forConnectNotifications: self, selector: #selector(buildMenu))
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateChange(notification:)), name: Notification.Name("BatteryStateChange"), object: nil)
    }
    
    @objc func batteryStateChange (notification: NSNotification) {
        if let body = notification.object as? [String: String], let address = body["address"] {
            batteryStates[address] = body["charge"]
            buildMenu()
        }
    }
    
    @objc func buildMenu () {
        menu.removeAllItems()
        
        let devices = (IOBluetoothDevice.pairedDevices() as! [IOBluetoothDevice])
            .filter { $0.isConnected() && $0.isHandsFreeDevice }
        
        guard devices.count != 0 else {
            menu.addItem(withTitle: "No connected handsfree devices.", action: nil, keyEquivalent: "")
            statusItem.button!.image = NSImage(named: NSImage.Name("akku_noconnect"))
            return
        }
        
        for device in devices {
            menu.addItem(withTitle: device.name, action: nil, keyEquivalent: "")
            let batteryMenuItem = NSMenuItem()
            if let rawState = batteryStates[device.addressString], let state = Double(rawState) {
                let batteryViewController = storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ViewController")) as! ViewController
                batteryViewController.setProgress(value: state)
                batteryMenuItem.view = batteryViewController.view
                statusItem.button!.image = NSImage(named: NSImage.Name("akku_" + rawState))
            } else {
                batteryMenuItem.title = "No reported battery state yet, try reconnecting."
                statusItem.button!.image = NSImage(named: NSImage.Name("akku_noconnect"))
            }
            menu.addItem(batteryMenuItem)
            
            device.register(forDisconnectNotification: self, selector: #selector(buildMenu))
        }
    }
}
