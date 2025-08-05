import '../models/drawing_model.dart';

class SampleData {
  static List<DrawingModel> getSampleDrawings() {
    return [
      // رسومات مجانية
      DrawingModel(
        id: 'labubu_1',
        name: 'لابوبو السعيد',
        lineArtPath: 'assets/drawings/labubu_happy_line.png',
        coloredSamplePath: 'assets/drawings/labubu_happy_colored.png',
        isFree: true,
      ),
      
      DrawingModel(
        id: 'labubu_2',
        name: 'لابوبو مع القلب',
        lineArtPath: 'assets/drawings/labubu_heart_line.png',
        coloredSamplePath: 'assets/drawings/labubu_heart_colored.png',
        isFree: true,
      ),
      
      DrawingModel(
        id: 'labubu_3',
        name: 'لابوبو النائم',
        lineArtPath: 'assets/drawings/labubu_sleeping_line.png',
        coloredSamplePath: 'assets/drawings/labubu_sleeping_colored.png',
        isFree: true,
      ),
      
      // رسومات مدفوعة
      DrawingModel(
        id: 'labubu_premium_1',
        name: 'لابوبو الملكي',
        lineArtPath: 'assets/drawings/labubu_royal_line.png',
        coloredSamplePath: 'assets/drawings/labubu_royal_colored.png',
        isFree: false,
        price: 4.99,
        productId: 'labubu_single_drawing_1',
      ),
      
      DrawingModel(
        id: 'labubu_premium_2',
        name: 'لابوبو الساحر',
        lineArtPath: 'assets/drawings/labubu_magic_line.png',
        coloredSamplePath: 'assets/drawings/labubu_magic_colored.png',
        isFree: false,
        price: 4.99,
        productId: 'labubu_single_drawing_2',
      ),
      
      DrawingModel(
        id: 'labubu_premium_3',
        name: 'لابوبو الأنيق',
        lineArtPath: 'assets/drawings/labubu_elegant_line.png',
        coloredSamplePath: 'assets/drawings/labubu_elegant_colored.png',
        isFree: false,
        price: 6.99,
        productId: 'labubu_drawing_pack_1',
      ),
      
      DrawingModel(
        id: 'labubu_premium_4',
        name: 'لابوبو المرح',
        lineArtPath: 'assets/drawings/labubu_fun_line.png',
        coloredSamplePath: 'assets/drawings/labubu_fun_colored.png',
        isFree: false,
        price: 6.99,
        productId: 'labubu_drawing_pack_2',
      ),
      
      DrawingModel(
        id: 'labubu_premium_5',
        name: 'لابوبو المميز',
        lineArtPath: 'assets/drawings/labubu_special_line.png',
        coloredSamplePath: 'assets/drawings/labubu_special_colored.png',
        isFree: false,
        price: 9.99,
        productId: 'labubu_premium_collection',
      ),
    ];
  }

  // إضافة الرسومات التجريبية إلى Firebase Service
  static Future<void> loadSampleDataToFirebase(firebaseService) async {
    final drawings = getSampleDrawings();
    
    for (final drawing in drawings) {
      await firebaseService.addDrawing(drawing);
    }
  }

  // إنشاء ملفات صور وهمية لمجلد الأصول
  static List<String> getRequiredAssets() {
    return [
      // رسومات مجانية - خطوط
      'assets/drawings/labubu_happy_line.png',
      'assets/drawings/labubu_heart_line.png',
      'assets/drawings/labubu_sleeping_line.png',
      
      // رسومات مجانية - ملونة
      'assets/drawings/labubu_happy_colored.png',
      'assets/drawings/labubu_heart_colored.png',
      'assets/drawings/labubu_sleeping_colored.png',
      
      // رسومات مدفوعة - خطوط
      'assets/drawings/labubu_royal_line.png',
      'assets/drawings/labubu_magic_line.png',
      'assets/drawings/labubu_elegant_line.png',
      'assets/drawings/labubu_fun_line.png',
      'assets/drawings/labubu_special_line.png',
      
      // رسومات مدفوعة - ملونة
      'assets/drawings/labubu_royal_colored.png',
      'assets/drawings/labubu_magic_colored.png',
      'assets/drawings/labubu_elegant_colored.png',
      'assets/drawings/labubu_fun_colored.png',
      'assets/drawings/labubu_special_colored.png',
    ];
  }

  // وظيفة لإنشاء ملفات تجريبية للاختبار
  static Map<String, String> getSampleImagePaths() {
    // في بيئة الإنتاج، يجب استبدال هذه بصور حقيقية
    // هذا مجرد مثال للتطوير
    return {
      'labubu_happy_line.png': 'صورة خط لابوبو السعيد',
      'labubu_happy_colored.png': 'صورة ملونة لابوبو السعيد',
      'labubu_heart_line.png': 'صورة خط لابوبو مع القلب',
      'labubu_heart_colored.png': 'صورة ملونة لابوبو مع القلب',
      'labubu_sleeping_line.png': 'صورة خط لابوبو النائم',
      'labubu_sleeping_colored.png': 'صورة ملونة لابوبو النائم',
      'labubu_royal_line.png': 'صورة خط لابوبو الملكي',
      'labubu_royal_colored.png': 'صورة ملونة لابوبو الملكي',
      'labubu_magic_line.png': 'صورة خط لابوبو الساحر',
      'labubu_magic_colored.png': 'صورة ملونة لابوبو الساحر',
      'labubu_elegant_line.png': 'صورة خط لابوبو الأنيق',
      'labubu_elegant_colored.png': 'صورة ملونة لابوبو الأنيق',
      'labubu_fun_line.png': 'صورة خط لابوبو المرح',
      'labubu_fun_colored.png': 'صورة ملونة لابوبو المرح',
      'labubu_special_line.png': 'صورة خط لابوبو المميز',
      'labubu_special_colored.png': 'صورة ملونة لابوبو المميز',
    };
  }

  // تحديث Firebase Service لاستخدام البيانات التجريبية
  static void setupOfflineMode(firebaseService) {
    // في حالة عدم وجود اتصال بالإنترنت أو Firebase
    final drawings = getSampleDrawings();
    firebaseService.setOfflineDrawings(drawings);
  }
}