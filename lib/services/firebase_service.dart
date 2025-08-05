import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/drawing_model.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<DrawingModel> _drawings = [];
  List<String> _purchasedDrawings = [];
  List<String> _userArtworks = [];
  bool _isLoading = false;

  List<DrawingModel> get drawings => _drawings;
  List<String> get purchasedDrawings => _purchasedDrawings;
  List<String> get userArtworks => _userArtworks;
  bool get isLoading => _isLoading;

  // جلب جميع الرسومات المتاحة
  Future<void> loadDrawings() async {
    try {
      _setLoading(true);
      
      final QuerySnapshot snapshot = await _firestore
          .collection('drawings')
          .orderBy('name')
          .get();
      
      _drawings = snapshot.docs
          .map((doc) => DrawingModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
      
      notifyListeners();
    } catch (e) {
      print('خطأ في جلب الرسومات: $e');
    } finally {
      _setLoading(false);
    }
  }

  // جلب الرسومات المشتراة للمستخدم
  Future<void> loadPurchasedDrawings() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('user_purchases')
          .doc(user.uid)
          .collection('purchased_drawings')
          .get();
      
      _purchasedDrawings = snapshot.docs.map((doc) => doc.id).toList();
      notifyListeners();
    } catch (e) {
      print('خطأ في جلب المشتريات: $e');
    }
  }

  // جلب أعمال المستخدم الفنية
  Future<void> loadUserArtworks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('user_artworks')
          .doc(user.uid)
          .collection('artworks')
          .orderBy('createdAt', descending: true)
          .get();
      
      _userArtworks = snapshot.docs.map((doc) => doc.id).toList();
      notifyListeners();
    } catch (e) {
      print('خطأ في جلب الأعمال الفنية: $e');
    }
  }

  // حفظ عمل فني للمستخدم
  Future<bool> saveUserArtwork(String drawingId, String artworkData) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final docRef = _firestore
          .collection('user_artworks')
          .doc(user.uid)
          .collection('artworks')
          .doc();

      await docRef.set({
        'drawingId': drawingId,
        'artworkData': artworkData,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      _userArtworks.insert(0, docRef.id);
      notifyListeners();
      return true;
    } catch (e) {
      print('خطأ في حفظ العمل الفني: $e');
      return false;
    }
  }

  // تسجيل مشترية جديدة
  Future<bool> recordPurchase(String drawingId, String productId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      await _firestore
          .collection('user_purchases')
          .doc(user.uid)
          .collection('purchased_drawings')
          .doc(drawingId)
          .set({
            'productId': productId,
            'purchaseDate': FieldValue.serverTimestamp(),
            'userId': user.uid,
          });

      if (!_purchasedDrawings.contains(drawingId)) {
        _purchasedDrawings.add(drawingId);
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('خطأ في تسجيل المشترية: $e');
      return false;
    }
  }

  // فحص ما إذا كان المستخدم قد اشترى رسمة معينة
  bool hasUserPurchased(String drawingId) {
    return _purchasedDrawings.contains(drawingId);
  }

  // فحص ما إذا كان المستخدم يمكنه الوصول لرسمة معينة
  bool canUserAccessDrawing(DrawingModel drawing) {
    return drawing.isFree || hasUserPurchased(drawing.id);
  }

  // جلب الرسومات المجانية فقط
  List<DrawingModel> get freeDrawings {
    return _drawings.where((drawing) => drawing.isFree).toList();
  }

  // جلب الرسومات المدفوعة فقط
  List<DrawingModel> get premiumDrawings {
    return _drawings.where((drawing) => !drawing.isFree).toList();
  }

  // جلب الرسومات المتاحة للمستخدم (مجانية + مشتراة)
  List<DrawingModel> get availableDrawings {
    return _drawings.where((drawing) => canUserAccessDrawing(drawing)).toList();
  }

  // إضافة رسمة جديدة (للإدارة)
  Future<bool> addDrawing(DrawingModel drawing) async {
    try {
      await _firestore.collection('drawings').doc(drawing.id).set(drawing.toJson());
      _drawings.add(drawing);
      notifyListeners();
      return true;
    } catch (e) {
      print('خطأ في إضافة الرسمة: $e');
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // تنظيف البيانات عند تسجيل الخروج
  void clearUserData() {
    _purchasedDrawings.clear();
    _userArtworks.clear();
    notifyListeners();
  }

  // تحديث بيانات المستخدم
  Future<void> refreshUserData() async {
    await Future.wait([
      loadPurchasedDrawings(),
      loadUserArtworks(),
    ]);
  }

  // دعم البيانات التجريبية للاختبار
  void setOfflineDrawings(List<DrawingModel> offlineDrawings) {
    _drawings = offlineDrawings;
    notifyListeners();
  }

  // تحميل البيانات التجريبية
  Future<void> loadSampleDrawings() async {
    try {
      _setLoading(true);
      
      // استيراد البيانات التجريبية
      // يمكن استخدام هذا في حالة عدم وجود اتصال بالإنترنت
      final sampleDrawings = [
        DrawingModel(
          id: 'sample_1',
          name: 'لابوبو السعيد',
          lineArtPath: 'assets/images/placeholder.png',
          coloredSamplePath: 'assets/images/placeholder.png',
          isFree: true,
        ),
        DrawingModel(
          id: 'sample_2',
          name: 'لابوبو مع القلب',
          lineArtPath: 'assets/images/placeholder.png',
          coloredSamplePath: 'assets/images/placeholder.png',
          isFree: true,
        ),
        DrawingModel(
          id: 'sample_3',
          name: 'لابوبو الملكي (مدفوع)',
          lineArtPath: 'assets/images/placeholder.png',
          coloredSamplePath: 'assets/images/placeholder.png',
          isFree: false,
          price: 4.99,
          productId: 'sample_premium_1',
        ),
      ];
      
      _drawings = sampleDrawings;
      notifyListeners();
    } catch (e) {
      print('خطأ في تحميل البيانات التجريبية: $e');
    } finally {
      _setLoading(false);
    }
  }

  // التحقق من وجود اتصال واستخدام البيانات المناسبة
  Future<void> loadDrawingsWithFallback() async {
    try {
      // محاولة تحميل البيانات من Firebase
      await loadDrawings();
      
      // إذا لم تتوفر رسومات، استخدم البيانات التجريبية
      if (_drawings.isEmpty) {
        await loadSampleDrawings();
      }
    } catch (e) {
      print('فشل في تحميل البيانات من Firebase، استخدام البيانات التجريبية: $e');
      await loadSampleDrawings();
    }
  }
}