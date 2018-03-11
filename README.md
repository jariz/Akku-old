#  Akku
Akku is a tiny monitoring app for headset bluetooth devices.
It will work with any application that conforms to the [Apple bluetooth spec](https://developer.apple.com/hardwaredrivers/BluetoothDesignGuidelines.pdf)\* (translation: if it works on your iPhone, it will work with Batti)

## Why does it require root?! / why is it utilizing CPU?
Batti runs the apple `packetlogger` tool to intercept RFCOMM communication, this is because it is not possible to read from RFCOMM connections opened by `bluetoothaudiod` (and other system services).
Devices will send their battery state by default, the system just does nothing with it for some reason\*.
Sadly, `packetlogger` requires root to do this.
Packetlogger will also intercept any type of bluetooth data, including audio data. This unfortunately results in a slight CPU utilization whilst playing back audio through connected devices. (we are however, talking about 3-5% spread over multiple cores here)
For more information on the exact choices that were made and why, you can read Jari's entire ~rant~ blogpost here.

## Why is < 10.12.6 not supported?
From my own personal research, macOS before 10.12.6 appears to reject the XAPL handshake (basically a signal from the device saying 'hey, are you an apple device?'), causing the battery state to not be send to the device.
Batti is compiled to work with lower versions of MacOS, it will however display a warning upon first launch.
If it does work for you, however, please [let me know](https://twitter.com/JariZwarts).

----
\* = You read that correctly, Apple did not bother to implement their own specifications on the Mac.
