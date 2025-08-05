import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isUserSignedIn => _user != null;

  AuthService() {
    // الاستماع لتغييرات حالة المصادقة
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // تسجيل الدخول باستخدام Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      
      // بدء عملية تسجيل الدخول مع Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // ألغى المستخدم عملية تسجيل الدخول
        _setLoading(false);
        return false;
      }

      // الحصول على تفاصيل المصادقة
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // إنشاء بيانات اعتماد جديدة
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول إلى Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      _user = userCredential.user;
      _setLoading(false);
      
      return true;
    } catch (e) {
      print('خطأ في تسجيل الدخول: $e');
      _setLoading(false);
      return false;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    try {
      _setLoading(true);
      
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      
      _user = null;
      _setLoading(false);
    } catch (e) {
      print('خطأ في تسجيل الخروج: $e');
      _setLoading(false);
    }
  }

  // حذف الحساب
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      
      if (_user != null) {
        await _user!.delete();
        await _googleSignIn.signOut();
        _user = null;
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      print('خطأ في حذف الحساب: $e');
      _setLoading(false);
      return false;
    }
  }

  // تحديث حالة التحميل
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // الحصول على معرف المستخدم
  String? get userId => _user?.uid;
  
  // الحصول على اسم المستخدم
  String? get userName => _user?.displayName;
  
  // الحصول على بريد المستخدم الإلكتروني
  String? get userEmail => _user?.email;
  
  // الحصول على صورة المستخدم
  String? get userPhotoUrl => _user?.photoURL;
}