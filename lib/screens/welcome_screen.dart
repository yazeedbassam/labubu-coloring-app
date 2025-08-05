import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE4E6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // صورة ترحيبية
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.brush,
                  size: 100,
                  color: Color(0xFFFF6B9D),
                ),
              ),
              SizedBox(height: 40),
              
              // عنوان الترحيب
              Text(
                'أهلاً بك في عالم Labubu!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              
              // وصف التطبيق
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      '🎨 استمتع بتلوين رسومات Labubu الجميلة',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '🖌️ أدوات تلوين متقدمة وسهلة الاستخدام',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '💾 احفظ إبداعاتك ومشاركها مع الأصدقاء',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '🔓 رسومات مجانية ومدفوعة حصرية',
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              
              // زر تسجيل الدخول
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  return Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: authService.isLoading 
                            ? null 
                            : () => _signInWithGoogle(context, authService),
                        icon: authService.isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Icon(Icons.login, size: 24),
                        label: Text(
                          authService.isLoading 
                              ? 'جاري تسجيل الدخول...' 
                              : 'تسجيل الدخول مع Google',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // ملاحظة مطلوبة
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber[700]),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'تسجيل الدخول مطلوب لحفظ أعمالك الفنية ومشترياتك',
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle(BuildContext context, AuthService authService) async {
    try {
      bool success = await authService.signInWithGoogle();
      if (success) {
        Navigator.pushReplacementNamed(context, '/gallery');
      } else {
        _showErrorSnackBar(context, 'فشل في تسجيل الدخول. يرجى المحاولة مرة أخرى.');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'حدث خطأ: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}