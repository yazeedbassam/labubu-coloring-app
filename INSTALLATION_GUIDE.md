# دليل تثبيت وتشغيل تطبيق Labubu Coloring 🎨

## الخيار الأول: تثبيت Flutter وبناء APK محلياً (الأسرع)

### 1. تحميل وتثبيت Flutter
```bash
# اذهب إلى: https://docs.flutter.dev/get-started/install/windows
# أو استخدم Git لتحميل Flutter مباشرة:
git clone https://github.com/flutter/flutter.git -b stable C:\flutter

# أضف Flutter إلى PATH
# اذهب إلى System Environment Variables وأضف: C:\flutter\bin
```

### 2. تثبيت Android Studio
```
1. نزل Android Studio من: https://developer.android.com/studio
2. ثبته مع Android SDK
3. افتح Android Studio واتبع setup wizard
4. ثبت Flutter plugin من Settings > Plugins
```

### 3. فحص التثبيت
```bash
flutter doctor
# يجب أن ترى ✓ Flutter و ✓ Android toolchain
```

### 4. بناء APK
```bash
cd E:\Development\Lbubu

# تثبيت dependencies
flutter pub get

# إصلاح أي مشاكل
flutter doctor --android-licenses

# بناء APK للاختبار
flutter build apk --debug

# APK ستكون في: build\app\outputs\flutter-apk\app-debug.apk
```

---

## الخيار الثاني: استخدام Codemagic (أونلاين - مجاني)

### 1. إنشاء حساب
- اذهب إلى: https://codemagic.io
- سجل دخول بـ GitHub أو Google (مجاني)

### 2. رفع المشروع
```bash
# إنشاء repo على GitHub
git init
git add .
git commit -m "Initial commit - Labubu Coloring App"
git remote add origin [your-github-repo-url]
git push -u origin main
```

### 3. بناء APK على Codemagic
- اربط GitHub repo بـ Codemagic
- اختر "Flutter App" 
- اختر branch: main
- اختر "Android" build
- اضغط "Start new build"
- انتظر 5-10 دقائق
- نزل APK من artifacts

---

## الخيار الثالث: استخدام GitHub Actions (أونلاين - مجاني)

### 1. إنشاء GitHub repo ورفع الكود

### 2. إضافة GitHub Actions workflow
سيتم إنشاء ملف `.github/workflows/build.yml` تلقائياً

### 3. كل push سينتج APK جديد في Actions tab

---

## الخيار الرابع: APK جاهز (سريع جداً) 

إذا كنت تريد تجربة سريعة، يمكنني إنشاء APK باستخدام:

### Flutter Online Builder
1. AppGyver (مجاني لفترة محدودة)
2. FlutLab (مجاني مع limitations)
3. DartPad + Manual conversion

---

## ملفات مهمة لتجربة أفضل:

### 1. إضافة Firebase Config
```bash
# ستحتاج ملف google-services.json من Firebase Console
# ضعه في: android/app/google-services.json
```

### 2. تخصيص أيقونة التطبيق
```bash
# استبدل الأيقونات في:
android/app/src/main/res/mipmap-*/
```

### 3. إضافة رسومات Labubu حقيقية
```bash
# استبدل الملفات في:
assets/drawings/
```

---

## أسرع طريقة للاختبار الآن:

### استخدام Android Studio Emulator:
1. افتح Android Studio
2. Tools > AVD Manager
3. أنشئ Virtual Device
4. شغل الـ emulator
5. في terminal: `flutter run`

### أو على جهازك الفعلي:
1. فعّل Developer Options على هاتفك
2. فعّل USB Debugging
3. وصل الهاتف بالكمبيوتر
4. في terminal: `flutter run`

---

## حل المشاكل الشائعة:

### مشكلة SDK licenses:
```bash
flutter doctor --android-licenses
# اضغط 'y' على كل license
```

### مشكلة dependencies:
```bash
flutter clean
flutter pub get
```

### مشكلة البناء:
```bash
cd android
./gradlew clean
cd ..
flutter build apk --debug
```

---

**🎯 أفضل الطرق مرتبة حسب السرعة:**
1. **Codemagic** (5 دقائق - سهل جداً)
2. **تثبيت Flutter محلياً** (30 دقيقة - أفضل للتطوير)
3. **GitHub Actions** (10 دقائق - جيد للفرق)
4. **FlutLab** (15 دقيقة - محدود لكن سريع)

اختر الطريقة التي تناسبك وأخبرني إذا احتجت مساعدة! 🚀