import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var label: NSTextField!
    
    var value: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.autoresizingMask = .width
        
        setValue()
    }
    
    func setProgress (value: Double) {
        if progress != nil {
            setValue()
        }
        self.value = value
    }
    
    func setValue() {
        if let value = self.value {
            progress.doubleValue = value
            label.stringValue = String(Int(value)) + "%"
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
