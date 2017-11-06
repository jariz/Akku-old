//
//  IOReturnToString.swift
//  Bati
//
//  Created by Jari on 31/10/2017.
//  Copyright © 2017 Bati. All rights reserved.
//

import Foundation

func IOReturnToString(_ out:IOReturn) -> String {
    // todo convert to switch statement
    
    if out == kIOReturnSuccess { return "OK" }
    else if out == kIOReturnAborted { return "Operation aborted" }
    else if out == kIOReturnBadArgument { return "Invalid argument" }
    else if out == kIOReturnBadMedia { return "Media error" }
    else if out == kIOReturnBadMessageID { return "Sent/received messages had different msg_id" }
    else if out == kIOReturnBusy { return "Device busy" }
    else if out == kIOReturnCannotLock { return "Can't acquire lock" }
    else if out == kIOReturnCannotWire { return "Can't wire down physical memory" }
    else if out == kIOReturnDMAError { return "DMA failure" }
    else if out == kIOReturnDeviceError { return "The device is not working properly" }
    else if out == kIOReturnError { return "General error" }
    else if out == kIOReturnExclusiveAccess { return "Exclusive access and device already open" }
    else if out == kIOReturnIOError { return "General I/O error" }
    else if out == kIOReturnIPCError { return "Error during IPC" }
    else if out == kIOReturnInternalError { return "Internal error" }
    else if out == kIOReturnInvalid { return "Should never be seen" }
    else if out == kIOReturnIsoTooNew { return "Isochronous I/O request for distant future" }
    else if out == kIOReturnIsoTooOld { return "Isochronous I/O request for distant past" }
    else if out == kIOReturnLockedRead { return "Device read locked" }
    else if out == kIOReturnLockedWrite { return "Device write locked" }
    else if out == kIOReturnMessageTooLarge { return "Oversized msg received on interrupt port" }
    else if out == kIOReturnNoBandwidth { return "Bus bandwidth would be exceeded" }
    else if out == kIOReturnNoChannels { return "No DMA channels left" }
    else if out == kIOReturnNoCompletion { return "A completion routine is required" }
    else if out == kIOReturnNoDevice { return "No such device" }
    else if out == kIOReturnNoFrames { return "No DMA frames enqueued" }
    else if out == kIOReturnNoInterrupt { return "No interrupt attached" }
    else if out == kIOReturnNoMedia { return "Media not present" }
    else if out == kIOReturnNoMemory { return "Can't allocate memory" }
    else if out == kIOReturnNoPower { return "No power to device" }
    else if out == kIOReturnNoResources { return "Resource shortage" }
    else if out == kIOReturnNoSpace { return "No space for data" }
    else if out == kIOReturnNotAligned { return "Alignment error" }
    else if out == kIOReturnNotAttached { return "Device not attached" }
    else if out == kIOReturnNotFound { return "Data was not found" }
    else if out == kIOReturnNotOpen { return "Device not open" }
    else if out == kIOReturnNotPermitted { return "Not permitted" }
    else if out == kIOReturnNotPrivileged { return "Privilege violation" }
    else if out == kIOReturnNotReadable { return "Read not supported" }
    else if out == kIOReturnNotReady { return "Not ready" }
    else if out == kIOReturnNotResponding { return "Device not responding" }
    else if out == kIOReturnNotWritable { return "Write not supported" }
    else if out == kIOReturnOffline { return "Device offline" }
    else if out == kIOReturnOverrun { return "Data overrun" }
    else if out == kIOReturnPortExists { return "Port already exists" }
    else if out == kIOReturnRLDError { return "RLD failure" }
    else if out == kIOReturnStillOpen { return "Device(s) still open" }
    else if out == kIOReturnTimeout { return "I/O timeout" }
    else if out == kIOReturnUnderrun { return "Data underrun" }
    else if out == kIOReturnUnformattedMedia { return "media not formatted" }
    else if out == kIOReturnUnsupported { return "Unsupported function" }
    else if out == kIOReturnUnsupportedMode { return "No such mode" }
    else if out == kIOReturnVMError { return "Misc. VM failure" }
    else { return "Unknown error \(out)" }
}
