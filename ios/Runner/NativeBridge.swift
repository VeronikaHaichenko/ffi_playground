import Foundation
import UIKit
import AudioToolbox

@_cdecl("getBatteryLevel")
public func getBatteryLevel() -> Float {
    UIDevice.current.isBatteryMonitoringEnabled = true
    return UIDevice.current.batteryLevel
}

@_cdecl("getPlatformName")
public func getPlatformName() -> UnsafePointer<CChar>? {
    return ("iOS" as NSString).utf8String
}

@_cdecl("getDeviceName")
public func getDeviceName() -> UnsafePointer<CChar>? {
    let name = UIDevice.current.name
    return (name as NSString).utf8String
}

@_cdecl("getLocale")
public func getLocale() -> UnsafePointer<CChar>? {
    let locale = Locale.current.identifier // например "uk_UA"
    return (locale as NSString).utf8String
}

@_cdecl("getCurrentTime")
public func getCurrentTime() -> UnsafePointer<CChar>? {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.dateStyle = .medium
    formatter.locale = Locale.current
    let now = formatter.string(from: Date())
    return (now as NSString).utf8String
}

@_cdecl("playSystemSound")
public func playSystemSound() {
    AudioServicesPlaySystemSound(1007) // “Tweet” звук
}

@_cdecl("setBrightness")
public func setBrightness(_ value: Float) {
    DispatchQueue.main.async {
        UIScreen.main.brightness = CGFloat(value)
    }
}

@_cdecl("getBrightness")
public func getBrightness() -> Float {
    return Float(UIScreen.main.brightness)
}
