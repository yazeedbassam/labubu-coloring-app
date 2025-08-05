import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

class PurchaseService extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // أسماء المنتجات في متجر التطبيقات
  static const List<String> _productIds = [
    'labubu_drawing_pack_1',
    'labubu_drawing_pack_2', 
    'labubu_premium_collection',
    'labubu_single_drawing_1',
    'labubu_single_drawing_2',
  ];

  PurchaseService() {
    _initialize();
  }

  // تهيئة خدمة المشتريات
  Future<void> _initialize() async {
    try {
      _setLoading(true);
      
      // فحص إتاحة المشتريات داخل التطبيق
      _isAvailable = await _inAppPurchase.isAvailable();
      
      if (!_isAvailable) {
        _setError('المشتريات داخل التطبيق غير متاحة على هذا الجهاز');
        return;
      }

      // الاستماع لتحديثات المشتريات
      _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onError: (error) {
          _setError('خطأ في عملية الشراء: $error');
        },
      );

      // تحميل المنتجات المتاحة
      await _loadProducts();
      
      // استعادة المشتريات السابقة
      await _restorePurchases();
      
    } catch (e) {
      _setError('خطأ في تهيئة خدمة المشتريات: $e');
    } finally {
      _setLoading(false);
    }
  }

  // تحميل المنتجات المتاحة
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(_productIds.toSet());

      if (response.error != null) {
        _setError('خطأ في تحميل المنتجات: ${response.error!.message}');
        return;
      }

      _products = response.productDetails;
      notifyListeners();
    } catch (e) {
      _setError('خطأ في تحميل المنتجات: $e');
    }
  }

  // شراء منتج
  Future<bool> purchaseProduct(String productId) async {
    final user = _auth.currentUser;
    if (user == null) {
      _setError('يجب تسجيل الدخول أولاً');
      return false;
    }

    try {
      _setLoading(true);
      _clearError();

      final ProductDetails? product = _products
          .where((p) => p.id == productId)
          .firstOrNull;

      if (product == null) {
        _setError('المنتج غير متوفر');
        return false;
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: user.uid,
      );

      bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      return success;
    } catch (e) {
      _setError('خطأ في عملية الشراء: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // استعادة المشتريات السابقة
  Future<void> _restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      print('خطأ في استعادة المشتريات: $e');
    }
  }

  // معالجة تحديثات المشتريات
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  // معالجة عملية شراء واحدة
  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      // تم الشراء بنجاح
      await _verifyAndFinalizePurchase(purchase);
    } else if (purchase.status == PurchaseStatus.error) {
      // حدث خطأ في الشراء
      _setError('فشل في الشراء: ${purchase.error?.message}');
    } else if (purchase.status == PurchaseStatus.canceled) {
      // تم إلغاء الشراء
      _setError('تم إلغاء عملية الشراء');
    }

    // إنهاء عملية الشراء
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  // التحقق من صحة الشراء وإنهاؤه
  Future<void> _verifyAndFinalizePurchase(PurchaseDetails purchase) async {
    try {
      // يمكن إضافة التحقق من الخادم هنا
      
      // تسجيل الشراء في Firebase
      // هذا يتطلب ربط منتجات المتجر برسومات محددة
      String drawingId = _mapProductToDrawing(purchase.productID);
      
      // حفظ الشراء في قاعدة البيانات
      // سيتم استدعاء FirebaseService هنا
      
      // إضافة الشراء للقائمة المحلية
      _purchases.add(purchase);
      notifyListeners();
      
      print('تم شراء المنتج بنجاح: ${purchase.productID}');
    } catch (e) {
      _setError('خطأ في التحقق من الشراء: $e');
    }
  }

  // ربط معرف المنتج برسمة محددة
  String _mapProductToDrawing(String productId) {
    // خريطة ربط معرفات المنتجات بالرسومات
    const Map<String, String> productToDrawingMap = {
      'labubu_drawing_pack_1': 'pack_1',
      'labubu_drawing_pack_2': 'pack_2',
      'labubu_premium_collection': 'premium_collection',
      'labubu_single_drawing_1': 'single_1',
      'labubu_single_drawing_2': 'single_2',
    };
    
    return productToDrawingMap[productId] ?? productId;
  }

  // فحص ما إذا كان المستخدم قد اشترى منتجاً معيناً
  bool hasUserPurchased(String productId) {
    return _purchases.any((purchase) => 
        purchase.productID == productId && 
        purchase.status == PurchaseStatus.purchased);
  }

  // الحصول على سعر منتج
  String? getProductPrice(String productId) {
    final product = _products.where((p) => p.id == productId).firstOrNull;
    return product?.price;
  }

  // الحصول على تفاصيل منتج
  ProductDetails? getProductDetails(String productId) {
    return _products.where((p) => p.id == productId).firstOrNull;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // إنهاء الاستماع للمشتريات
    super.dispose();
  }

  // إعادة تحميل المنتجات
  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  // استعادة المشتريات يدوياً
  Future<void> restorePurchases() async {
    _setLoading(true);
    await _restorePurchases();
    _setLoading(false);
  }
}