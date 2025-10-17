package com.example.ffi_playground

import android.app.Activity
import android.media.AudioManager
import android.os.BatteryManager
import java.text.SimpleDateFormat
import java.util.*

object NativeBridge {

    private var activity: Activity? = null

    init {
        System.loadLibrary("native_bridge")
    }

    @JvmStatic
    fun registerActivity(activity: Activity) {
        this.activity = activity
        registerActivityInNative(activity)
    }

    @JvmStatic
    private external fun registerActivityInNative(activity: Activity)

    // 🔋 Battery Level
    @JvmStatic
    fun getBatteryLevel(activity: Activity): Float {
        val bm = activity.getSystemService(BatteryManager::class.java)
        val level = bm?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)?.toFloat() ?: -1f
        return level / 100f
    }

    // 📱 Device name
    @JvmStatic fun getDeviceName(): String =
        android.os.Build.MODEL ?: "Unknown Device"

    // 🌍 Locale
    @JvmStatic fun getLocale(): String =
        Locale.getDefault().toString()

    // 🕒 Current Time
    @JvmStatic fun getCurrentTime(): String =
        SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(Date())

    // 🔊 Play sound
    @JvmStatic
    fun playSystemSound(activity: Activity) {
        val am = activity.getSystemService(AudioManager::class.java)
        am.playSoundEffect(AudioManager.FX_KEY_CLICK)
    }

    // 💡 Brightness control
    @JvmStatic
    fun setBrightness(value: Float) {
        activity?.runOnUiThread {
            val lp = activity?.window?.attributes
            lp?.screenBrightness = value
            activity?.window?.attributes = lp
            android.util.Log.i("FFI", "💡 Brightness set to $value")
        }
    }


    @JvmStatic
    fun getBrightness(): Float {
        val b = activity?.window?.attributes?.screenBrightness ?: 1.0f
        return if (b < 0f) 1.0f else b   // -1.0 → 1.0 (системное значение)
    }
}
