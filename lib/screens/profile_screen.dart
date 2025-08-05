import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/purchase_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      firebaseService.refreshUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE4E6),
      appBar: AppBar(
        title: Text('الملف الشخصي'),
        backgroundColor: Color(0xFFFF6B9D),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer3<AuthService, FirebaseService, PurchaseService>(
        builder: (context, authService, firebaseService, purchaseService, child) {
          final user = authService.user;
          
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'يجب تسجيل الدخول أولاً',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                    child: Text('تسجيل الدخول'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // معلومات المستخدم
                _buildUserInfoCard(user, authService),
                
                SizedBox(height: 20),
                
                // إحصائيات المستخدم
                _buildStatsCard(firebaseService),
                
                SizedBox(height: 20),
                
                // المشتريات
                _buildPurchasesCard(firebaseService, purchaseService),
                
                SizedBox(height: 20),
                
                // الأعمال الفنية
                _buildArtworksCard(firebaseService),
                
                SizedBox(height: 20),
                
                // الإعدادات
                _buildSettingsCard(authService, firebaseService, purchaseService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(user, AuthService authService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // صورة المستخدم
            CircleAvatar(
              radius: 50,
              backgroundImage: user.photoURL != null 
                  ? NetworkImage(user.photoURL!)
                  : null,
              backgroundColor: Color(0xFFFF6B9D),
              child: user.photoURL == null 
                  ? Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            SizedBox(height: 15),
            
            // اسم المستخدم
            Text(
              user.displayName ?? 'مستخدم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B9D),
              ),
            ),
            SizedBox(height: 8),
            
            // بريد المستخدم
            Text(
              user.email ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            
            // تاريخ الانضمام
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFF6B9D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'عضو منذ ${_formatDate(user.metadata.creationTime)}',
                style: TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(FirebaseService firebaseService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإحصائيات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B9D),
              ),
            ),
            SizedBox(height: 15),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.palette,
                    label: 'الأعمال الفنية',
                    value: '${firebaseService.userArtworks.length}',
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.shopping_bag,
                    label: 'المشتريات',
                    value: '${firebaseService.purchasedDrawings.length}',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesCard(FirebaseService firebaseService, PurchaseService purchaseService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المشتريات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B9D),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await purchaseService.restorePurchases();
                    await firebaseService.refreshUserData();
                  },
                  child: Text('استعادة المشتريات'),
                ),
              ],
            ),
            SizedBox(height: 15),
            
            if (firebaseService.purchasedDrawings.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'لا توجد مشتريات بعد',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ...firebaseService.purchasedDrawings.take(3).map((drawingId) {
                return ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('رسمة $drawingId'),
                  subtitle: Text('مُشتراة'),
                );
              }).toList(),
              
              if (firebaseService.purchasedDrawings.length > 3) ...[
                TextButton(
                  onPressed: () {
                    // عرض جميع المشتريات
                  },
                  child: Text('عرض الكل (${firebaseService.purchasedDrawings.length})'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildArtworksCard(FirebaseService firebaseService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أعمالي الفنية',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B9D),
              ),
            ),
            SizedBox(height: 15),
            
            if (firebaseService.userArtworks.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.brush_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'لم تقم بإنشاء أي عمل فني بعد',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/gallery'),
                      child: Text('ابدأ التلوين'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                'آخر الأعمال الفنية:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              
              ...firebaseService.userArtworks.take(3).map((artworkId) {
                return ListTile(
                  leading: Icon(Icons.palette, color: Color(0xFFFF6B9D)),
                  title: Text('عمل فني #${artworkId.substring(0, 8)}'),
                  subtitle: Text('تم الحفظ'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // عرض العمل الفني
                  },
                );
              }).toList(),
              
              if (firebaseService.userArtworks.length > 3) ...[
                TextButton(
                  onPressed: () {
                    // عرض جميع الأعمال الفنية
                  },
                  child: Text('عرض الكل (${firebaseService.userArtworks.length})'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(AuthService authService, FirebaseService firebaseService, PurchaseService purchaseService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإعدادات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B9D),
              ),
            ),
            SizedBox(height: 15),
            
            ListTile(
              leading: Icon(Icons.refresh, color: Color(0xFFFF6B9D)),
              title: Text('تحديث البيانات'),
              onTap: () async {
                await firebaseService.refreshUserData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تحديث البيانات')),
                );
              },
            ),
            
            ListTile(
              leading: Icon(Icons.restore, color: Colors.blue),
              title: Text('استعادة المشتريات'),
              onTap: () async {
                await purchaseService.restorePurchases();
                await firebaseService.refreshUserData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم استعادة المشتريات')),
                );
              },
            ),
            
            Divider(),
            
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _showLogoutDialog(authService, firebaseService),
            ),
            
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red[700]),
              title: Text(
                'حذف الحساب',
                style: TextStyle(color: Colors.red[700]),
              ),
              onTap: () => _showDeleteAccountDialog(authService, firebaseService),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthService authService, FirebaseService firebaseService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الخروج'),
        content: Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.signOut();
              firebaseService.clearUserData();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcome',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(AuthService authService, FirebaseService firebaseService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف الحساب',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          'تحذير: سيتم حذف حسابك وجميع بياناتك نهائياً. هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              bool success = await authService.deleteAccount();
              if (success) {
                firebaseService.clearUserData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/welcome',
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل في حذف الحساب'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: Text('حذف نهائياً'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    return '${date.day}/${date.month}/${date.year}';
  }
}