// بيانات تجريبية للاختبار
class SampleData {
  static List<Map<String, dynamic>> getLabubuDrawings() {
    return [
      {
        'id': 'labubu_1',
        'name': 'Labubu السعيد',
        'description': 'رسمة Labubu بوجه مبتسم وسعيد',
        'isFree': true,
        'svgPath': 'assets/drawings/labubu_1_line.svg',
        'previewImage': 'assets/drawings/labubu_1_preview.png',
        'difficulty': 'سهل',
        'estimatedTime': '15 دقيقة',
        'colors': ['#FF6B9D', '#FFE4E6', '#FFF0F5', '#87CEEB', '#98FB98'],
      },
      {
        'id': 'labubu_2', 
        'name': 'Labubu يلعب',
        'description': 'رسمة Labubu يلعب بالكرة',
        'isFree': true,
        'svgPath': 'assets/drawings/labubu_2_line.svg',
        'previewImage': 'assets/drawings/labubu_2_preview.png',
        'difficulty': 'متوسط',
        'estimatedTime': '20 دقيقة',
        'colors': ['#FF6B9D', '#FFB6C1', '#87CEEB', '#FFD700', '#98FB98'],
      },
      {
        'id': 'labubu_3',
        'name': 'Labubu الراقص', 
        'description': 'رسمة Labubu يرقص بفرح',
        'isFree': true,
        'svgPath': 'assets/drawings/labubu_3_line.svg',
        'previewImage': 'assets/drawings/labubu_3_preview.png',
        'difficulty': 'متوسط',
        'estimatedTime': '25 دقيقة',
        'colors': ['#FF6B9D', '#FFB6C1', '#DDA0DD', '#87CEEB', '#F0E68C'],
      },
      {
        'id': 'labubu_4',
        'name': 'Labubu مع الأصدقاء',
        'description': 'رسمة Labubu مع مجموعة من الأصدقاء',
        'isFree': true,
        'svgPath': 'assets/drawings/labubu_4_line.svg',
        'previewImage': 'assets/drawings/labubu_4_preview.png',
        'difficulty': 'متقدم',
        'estimatedTime': '35 دقيقة',
        'colors': ['#FF6B9D', '#FFB6C1', '#87CEEB', '#98FB98', '#FFD700', '#DDA0DD'],
      },
      {
        'id': 'labubu_5',
        'name': 'Labubu النائم',
        'description': 'رسمة Labubu نائم بهدوء',
        'isFree': true,
        'svgPath': 'assets/drawings/labubu_5_line.svg',
        'previewImage': 'assets/drawings/labubu_5_preview.png',
        'difficulty': 'سهل',
        'estimatedTime': '18 دقيقة',
        'colors': ['#FF6B9D', '#E6E6FA', '#B0C4DE', '#F5F5DC'],
      },

      // الرسومات المدفوعة
      {
        'id': 'labubu_premium_1',
        'name': 'Labubu الملكي',
        'description': 'رسمة Labubu كملك بتاج وعباءة ملكية',
        'isFree': false,
        'price': 0.99,
        'productId': 'labubu_drawing_pack_1',
        'svgPath': 'assets/drawings/labubu_premium_1_line.svg',
        'previewImage': 'assets/drawings/labubu_premium_1_preview.png',
        'difficulty': 'متقدم',
        'estimatedTime': '45 دقيقة',
        'colors': ['#FF6B9D', '#FFD700', '#9932CC', '#DC143C', '#4169E1', '#228B22'],
        'tags': ['ملكي', 'فاخر', 'تفاصيل كثيرة'],
      },
      {
        'id': 'labubu_premium_2',
        'name': 'Labubu المحارب',
        'description': 'رسمة Labubu كمحارب شجاع',
        'isFree': false,
        'price': 0.99,
        'productId': 'labubu_drawing_pack_2',
        'svgPath': 'assets/drawings/labubu_premium_2_line.svg',
        'previewImage': 'assets/drawings/labubu_premium_2_preview.png',
        'difficulty': 'متقدم',
        'estimatedTime': '40 دقيقة',
        'colors': ['#FF6B9D', '#A52A2A', '#2F4F4F', '#FFD700', '#696969'],
        'tags': ['محارب', 'مغامرة', 'أكشن'],
      },
      {
        'id': 'labubu_premium_3',
        'name': 'Labubu السحري',
        'description': 'رسمة Labubu ساحر مع عصا سحرية',
        'isFree': false,
        'price': 1.49,
        'productId': 'labubu_premium_collection',
        'svgPath': 'assets/drawings/labubu_premium_3_line.svg',
        'previewImage': 'assets/drawings/labubu_premium_3_preview.png',
        'difficulty': 'خبير',
        'estimatedTime': '50 دقيقة',
        'colors': ['#FF6B9D', '#9400D3', '#00CED1', '#FFD700', '#FF69B4', '#32CD32'],
        'tags': ['سحر', 'فانتازيا', 'تفاصيل معقدة'],
      },
      {
        'id': 'labubu_premium_4',
        'name': 'Labubu الفضائي',
        'description': 'رسمة Labubu رائد فضاء في المجرة',
        'isFree': false,
        'price': 1.49,
        'productId': 'labubu_single_drawing_1',
        'svgPath': 'assets/drawings/labubu_premium_4_line.svg',
        'previewImage': 'assets/drawings/labubu_premium_4_preview.png',
        'difficulty': 'خبير',
        'estimatedTime': '55 دقيقة',
        'colors': ['#FF6B9D', '#191970', '#4169E1', '#C0C0C0', '#FFD700', '#00FA9A'],
        'tags': ['فضاء', 'مستقبلي', 'علمي'],
      },
      {
        'id': 'labubu_premium_5',
        'name': 'Labubu الأسطوري',
        'description': 'رسمة Labubu الأسطورية مع أجنحة وقوى خاصة',
        'isFree': false,
        'price': 1.99,
        'productId': 'labubu_single_drawing_2',
        'svgPath': 'assets/drawings/labubu_premium_5_line.svg',
        'previewImage': 'assets/drawings/labubu_premium_5_preview.png',
        'difficulty': 'خبير',
        'estimatedTime': '60 دقيقة',
        'colors': ['#FF6B9D', '#FFD700', '#9932CC', '#DC143C', '#4169E1', '#FF4500', '#32CD32'],
        'tags': ['أسطوري', 'مميز', 'تحدي'],
      },
    ];
  }

  static List<String> getColorPalettes() {
    return [
      '#FF6B9D', // Labubu Pink
      '#FFB6C1', // Light Pink
      '#FFE4E6', // Very Light Pink
      '#87CEEB', // Sky Blue
      '#98FB98', // Pale Green
      '#FFD700', // Gold
      '#DDA0DD', // Plum
      '#F0E68C', // Khaki
      '#FFA07A', // Light Salmon
      '#20B2AA', // Light Sea Green
      '#9370DB', // Medium Purple
      '#FF69B4', // Hot Pink
      '#00CED1', // Dark Turquoise
      '#FFE4B5', // Moccasin
      '#B0C4DE', // Light Steel Blue
    ];
  }

  static Map<String, String> getAppTexts() {
    return {
      'app_name': 'تلوين Labubu',
      'welcome_title': 'أهلاً بك في عالم Labubu السحري!',
      'welcome_subtitle': 'استمتع بتلوين أجمل الرسومات',
      'login_with_google': 'تسجيل الدخول مع Google',
      'gallery_title': 'معرض الرسومات',
      'free_drawings': 'رسومات مجانية',
      'premium_drawings': 'رسومات حصرية',
      'start_coloring': 'ابدأ التلوين',
      'purchase_drawing': 'شراء الرسمة',
      'save_artwork': 'حفظ العمل الفني',
      'share_artwork': 'مشاركة العمل الفني',
      'my_artworks': 'أعمالي الفنية',
      'settings': 'الإعدادات',
      'help': 'المساعدة',
      'about': 'حول التطبيق',
      'logout': 'تسجيل الخروج',
    };
  }
}