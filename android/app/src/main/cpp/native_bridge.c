#include <jni.h>
#include <android/log.h>

#define LOGI(...) __android_log_print(ANDROID_LOG_INFO,  "FFI", __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "FFI", __VA_ARGS__)

static JavaVM* java_vm = NULL;
static jobject globalActivity = NULL;

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
    java_vm = vm;
    LOGI("JNI_OnLoad initialized");
    return JNI_VERSION_1_6;
}

JNIEXPORT void JNICALL
Java_com_example_ffi_1playground_NativeBridge_registerActivityInNative(JNIEnv* env, jclass clazz, jobject activity) {
    if (globalActivity) {
        (*env)->DeleteGlobalRef(env, globalActivity);
    }
    globalActivity = (*env)->NewGlobalRef(env, activity);
    LOGI("✅ Activity registered via NativeBridge.registerActivityInNative()");
}

// ----------------------------------------------------------------------
// 🧩 ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

JNIEnv* ensureEnv() {
    if (!java_vm) return NULL;
    JNIEnv* env = NULL;
    if ((*java_vm)->AttachCurrentThread(java_vm, &env, NULL) != 0) {
        LOGE("❌ AttachCurrentThread failed");
        return NULL;
    }
    return env;
}

jclass loadBridgeClass(JNIEnv* env) {
    if (!globalActivity) return NULL;

    jclass activityClass = (*env)->GetObjectClass(env, globalActivity);
    jmethodID getClassLoader = (*env)->GetMethodID(env, activityClass, "getClassLoader", "()Ljava/lang/ClassLoader;");
    jobject classLoader = (*env)->CallObjectMethod(env, globalActivity, getClassLoader);

    jclass loaderClass = (*env)->FindClass(env, "java/lang/ClassLoader");
    jmethodID loadClass = (*env)->GetMethodID(env, loaderClass, "loadClass", "(Ljava/lang/String;)Ljava/lang/Class;");
    jstring name = (*env)->NewStringUTF(env, "com.example.ffi_playground.NativeBridge");

    return (jclass)(*env)->CallObjectMethod(env, classLoader, loadClass, name);
}

jstring callStringMethod(const char* name, const char* sig) {
    JNIEnv* env = ensureEnv();
    if (!env) return NULL;

    jclass bridge = loadBridgeClass(env);
    if (!bridge) return NULL;

    jmethodID mid = (*env)->GetStaticMethodID(env, bridge, name, sig);
    if (!mid) return NULL;

    return (jstring)(*env)->CallStaticObjectMethod(env, bridge, mid);
}

void callVoidMethod(const char* name, const char* sig, jobject arg) {
    JNIEnv* env = ensureEnv();
    if (!env) return;

    jclass bridge = loadBridgeClass(env);
    if (!bridge) return;

    jmethodID mid = (*env)->GetStaticMethodID(env, bridge, name, sig);
    if (!mid) return;

    (*env)->CallStaticVoidMethod(env, bridge, mid, arg);
}

float callFloatMethod(const char* name, const char* sig, jobject arg) {
    JNIEnv* env = ensureEnv();
    if (!env) return 0.0f;

    jclass bridge = loadBridgeClass(env);
    if (!bridge) return 0.0f;

    jmethodID mid = (*env)->GetStaticMethodID(env, bridge, name, sig);
    if (!mid) return 0.0f;

    return (*env)->CallStaticFloatMethod(env, bridge, mid, arg);
}

// ----------------------------------------------------------------------
// 🔋 Публичные функции, вызываемые из Dart через FFI

float getBatteryLevel() {
    float result = callFloatMethod("getBatteryLevel", "(Landroid/app/Activity;)F", globalActivity);
    LOGI("🔋 getBatteryLevel(): %.2f", result);
    return result;
}

const char* getPlatformName() {
    return "Android";
}

const char* getDeviceName() {
    JNIEnv* env = ensureEnv();
    jstring jres = callStringMethod("getDeviceName", "()Ljava/lang/String;");
    if (!jres) return "Unknown";
    const char* utf = (*env)->GetStringUTFChars(env, jres, 0);
    LOGI("📱 getDeviceName(): %s", utf);
    return utf;
}

const char* getLocale() {
    JNIEnv* env = ensureEnv();
    jstring jres = callStringMethod("getLocale", "()Ljava/lang/String;");
    if (!jres) return "en_US";
    const char* utf = (*env)->GetStringUTFChars(env, jres, 0);
    LOGI("🌍 getLocale(): %s", utf);
    return utf;
}

const char* getCurrentTime() {
    JNIEnv* env = ensureEnv();
    jstring jres = callStringMethod("getCurrentTime", "()Ljava/lang/String;");
    if (!jres) return "unknown";
    const char* utf = (*env)->GetStringUTFChars(env, jres, 0);
    LOGI("⏰ getCurrentTime(): %s", utf);
    return utf;
}

void playSystemSound() {
    callVoidMethod("playSystemSound", "(Landroid/app/Activity;)V", globalActivity);
    LOGI("🔊 playSystemSound()");
}

void setBrightness(float value) {
    JNIEnv* env = ensureEnv();
    if (!env) return;

    jclass bridge = loadBridgeClass(env);
    jmethodID mid = (*env)->GetStaticMethodID(env, bridge, "setBrightness", "(F)V");
    if (mid) (*env)->CallStaticVoidMethod(env, bridge, mid, value);
    LOGI("💡 setBrightness(%.2f)", value);
}

float getBrightness() {
    float result = callFloatMethod("getBrightness", "()F", NULL);
    LOGI("💡 getBrightness(): %.2f", result);
    return result;
}
