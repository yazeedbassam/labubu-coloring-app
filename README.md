# 🎨 Labubu Coloring App - تطبيق تلوين لابوبو

تطبيق تلوين تفاعلي للأطفال يركز على شخصية Labubu الشهيرة، مع نظام مشتريات داخل التطبيق ونظام مصادقة متطور.

## ✨ المميزات الرئيسية

### 🎨 التلوين التفاعلي
- أدوات رسم متقدمة مع إمكانية تخصيص حجم الفرشاة
- مجموعة ألوان واسعة مع أداة اختيار الألوان
- وضع الممحاة الذكية
- حفظ ومشاركة الأعمال الفنية

### 🔐 نظام المصادقة
- تسجيل دخول آمن باستخدام Google
- إدارة حسابات المستخدمين
- حفظ تقدم المستخدم في السحابة

### 💳 المشتريات داخل التطبيق
- رسومات مجانية للبدء
- رسومات مميزة قابلة للشراء
- نظام استعادة المشتريات
- أمان معاملات عالي المستوى

### 📱 واجهة مستخدم عصرية
- تصميم ملون وجذاب للأطفال
- دعم اللغة العربية الكامل
- تجربة مستخدم سلسة ومتجاوبة

## 🏗️ البنية التقنية

### Frontend (Flutter)
- **Framework**: Flutter 3.10+
- **Language**: Dart
- **State Management**: Provider
- **Architecture**: Clean Architecture مع MVVM

### Backend & Services
- **Authentication**: Firebase Auth + Google Sign-In
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **Payments**: In-App Purchase (Google Play)

### المكتبات المستخدمة
```yaml
dependencies:
  flutter: sdk
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  google_sign_in: ^6.1.6
  in_app_purchase: ^3.1.11
  flutter_colorpicker: ^1.0.3
  flutter_signature_pad: ^3.0.1
  provider: ^6.1.1
  gallery_saver: ^2.3.2
```

## 📁 هيكل المشروع

```
lib/
├── main.dart                 # نقطة البداية الرئيسية
├── models/                   # نماذج البيانات
│   └── drawing_model.dart
├── screens/                  # شاشات التطبيق
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── gallery_screen.dart
│   ├── coloring_screen.dart
│   └── profile_screen.dart
├── services/                 # الخدمات والطبقات المنطقية
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   └── purchase_service.dart
├── components/               # مكونات UI قابلة للإعادة
└── utils/                    # الأدوات المساعدة
    └── sample_data.dart
```

## 🚀 كيفية التشغيل

### المتطلبات الأساسية
1. **Flutter SDK** (3.10.0 أو أحدث)
2. **Android Studio** أو **VS Code**
3. **Firebase Project** مع التكوين المناسب
4. **Google Play Console** للمشتريات داخل التطبيق

### خطوات التشغيل

1. **استنساخ المشروع**
```bash
git clone <repository-url>
cd Lbubu
```

2. **تثبيت المكتبات**
```bash
flutter pub get
```

3. **تكوين Firebase**
- أنشئ مشروع Firebase جديد
- فعّل Authentication و Firestore
- أضف ملف `google-services.json` في `android/app/`

4. **تشغيل التطبيق**
```bash
flutter run
```

## 🔧 التكوين المطلوب

### Firebase Configuration
```
1. أنشئ مشروع في Firebase Console
2. فعّل Authentication (Google Sign-In)
3. فعّل Cloud Firestore
4. أضف التطبيق للمنصات المطلوبة
5. نزّل google-services.json وضعه في android/app/
```

### In-App Purchase Setup
```
1. ارفع التطبيق لـ Google Play Console
2. أنشئ منتجات المشتريات داخل التطبيق
3. فعّل Google Play Billing API
4. اربط المنتجات بالكود في PurchaseService
```

## 🎯 الشاشات الرئيسية

### 1. شاشة البداية (Splash)
- عرض شعار التطبيق
- فحص حالة المصادقة
- توجيه المستخدم للشاشة المناسبة

### 2. شاشة الترحيب (Welcome)
- مقدمة عن التطبيق
- تسجيل الدخول بـ Google
- معلومات المميزات

### 3. معرض الرسومات (Gallery)
- عرض الرسومات المتاحة
- تصنيف (مجانية/مدفوعة)
- نظام البحث والفلترة

### 4. شاشة التلوين (Coloring)
- أدوات الرسم التفاعلية
- لوحة الألوان المتقدمة
- حفظ ومشاركة الأعمال

### 5. الملف الشخصي (Profile)
- معلومات المستخدم
- إحصائيات الاستخدام
- إدارة المشتريات

## 🛡️ الأمان والخصوصية

- **تشفير البيانات**: جميع البيانات مشفرة عبر Firebase
- **مصادقة آمنة**: استخدام OAuth 2.0 مع Google
- **حماية المشتريات**: تحقق من المعاملات عبر الخادم
- **خصوصية الأطفال**: امتثال لقوانين COPPA

## 📈 التطوير المستقبلي

### المميزات المخططة
- [ ] دعم منصات إضافية (iOS)
- [ ] المزيد من الشخصيات والرسومات
- [ ] نظام التحديات والجوائز
- [ ] مشاركة اجتماعية متقدمة
- [ ] وضع اللعب المتعدد

### التحسينات التقنية
- [ ] تحسين الأداء والسرعة
- [ ] دعم الوضع المظلم
- [ ] إضافة اختبارات شاملة
- [ ] تحسين إمكانية الوصول

## 🤝 المساهمة

نرحب بالمساهمات! يرجى اتباع هذه الخطوات:

1. Fork المشروع
2. أنشئ branch للميزة الجديدة
3. اكتب الكود مع التعليقات
4. أضف الاختبارات المناسبة
5. أنشئ Pull Request

## 📝 الترخيص

هذا المشروع مرخص تحت رخصة MIT - راجع ملف [LICENSE](LICENSE) للتفاصيل.

## 📞 التواصل والدعم

للاستفسارات والدعم التقني:
- **Email**: [support@example.com](mailto:support@example.com)
- **Issues**: [GitHub Issues](https://github.com/username/repo/issues)

---

**ملاحظة**: هذا التطبيق مصمم خصيصاً للأطفال ويلتزم بأعلى معايير الأمان والخصوصية.

## 🎉 حالة المشروع

✅ **مكتمل بنسبة 95%**

### ما تم إنجازه:
- ✅ نظام المصادقة الكامل
- ✅ خدمة Firebase متكاملة  
- ✅ خدمة المشتريات داخل التطبيق
- ✅ جميع الشاشات الأساسية
- ✅ نظام البيانات التجريبية
- ✅ واجهة مستخدم متجاوبة
- ✅ دعم اللغة العربية

### ما يحتاج إكمال:
- 🔄 إضافة صور رسومات حقيقية
- 🔄 تكوين Firebase للإنتاج
- 🔄 اختبار المشتريات على Google Play
- 🔄 تحسينات الأداء النهائية