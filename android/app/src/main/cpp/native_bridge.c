#include <time.h>
#include <string.h>

float getBatteryLevel() {
    return 0.75f;
}

const char* getPlatformName() {
    return "Android";
}

const char* getDeviceName() {
    return "Android Device";
}

const char* getLocale() {
    return "en_US";
}

const char* getCurrentTime() {
    return "Android Stub Time";
}

void playSystemSound() { }

void setBrightness(float value) { }

float getBrightness() {
    return 0.8f; // просто фиктивное значение
}
