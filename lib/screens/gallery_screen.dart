import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/purchase_service.dart';
import '../models/drawing_model.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل الرسومات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      // استخدام البيانات التجريبية مع Fallback
      firebaseService.loadDrawingsWithFallback();
      firebaseService.refreshUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE4E6),
      appBar: AppBar(
        title: Text('معرض رسومات Labubu'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFFF6B9D),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Consumer2<FirebaseService, PurchaseService>(
        builder: (context, firebaseService, purchaseService, child) {
          if (firebaseService.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B9D)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'جاري تحميل الرسومات...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          }

          final drawings = firebaseService.drawings;
          
          if (drawings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'لا توجد رسومات متاحة حالياً',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => firebaseService.loadDrawingsWithFallback(),
                    child: Text('إعادة التحميل'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await firebaseService.loadDrawingsWithFallback();
              await firebaseService.refreshUserData();
            },
            child: CustomScrollView(
              slivers: [
                // قسم الرسومات المجانية
                if (firebaseService.freeDrawings.isNotEmpty) ...[
                  SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Icon(Icons.free_breakfast, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'رسومات مجانية',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final drawing = firebaseService.freeDrawings[index];
                          return _buildDrawingCard(drawing, firebaseService, purchaseService);
                        },
                        childCount: firebaseService.freeDrawings.length,
                      ),
                    ),
                  ),
                ],
                
                // قسم الرسومات المدفوعة
                if (firebaseService.premiumDrawings.isNotEmpty) ...[
                  SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Icon(Icons.diamond, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            'رسومات مميزة',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final drawing = firebaseService.premiumDrawings[index];
                          return _buildDrawingCard(drawing, firebaseService, purchaseService);
                        },
                        childCount: firebaseService.premiumDrawings.length,
                      ),
                    ),
                  ),
                ],
                
                // مساحة إضافية في الأسفل
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 100),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawingCard(
    DrawingModel drawing, 
    FirebaseService firebaseService, 
    PurchaseService purchaseService
  ) {
    final canAccess = firebaseService.canUserAccessDrawing(drawing);
    final isPurchased = firebaseService.hasUserPurchased(drawing.id);
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _onDrawingTap(drawing, canAccess, firebaseService, purchaseService),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة الرسمة
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage(drawing.coloredSamplePath),
                    fit: BoxFit.cover,
                    colorFilter: canAccess ? null : ColorFilter.mode(
                      Colors.grey.withOpacity(0.7),
                      BlendMode.saturation,
                    ),
                  ),
                ),
                child: !canAccess ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ) : null,
              ),
            ),
            
            // معلومات الرسمة
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drawing.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B9D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    
                    if (drawing.isFree) ...[
                      Row(
                        children: [
                          Icon(Icons.free_breakfast, size: 16, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            'مجاني',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      if (isPurchased) ...[
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'مُشترى',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Icon(Icons.diamond, size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              '${drawing.price} ر.س',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDrawingTap(
    DrawingModel drawing,
    bool canAccess,
    FirebaseService firebaseService,
    PurchaseService purchaseService,
  ) {
    if (canAccess) {
      // انتقال لشاشة التلوين
      Navigator.pushNamed(
        context,
        '/coloring',
        arguments: drawing,
      );
    } else {
      // عرض نافذة الشراء
      _showPurchaseDialog(drawing, purchaseService, firebaseService);
    }
  }

  void _showPurchaseDialog(
    DrawingModel drawing,
    PurchaseService purchaseService,
    FirebaseService firebaseService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'شراء رسمة',
          style: TextStyle(color: Color(0xFFFF6B9D)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              drawing.coloredSamplePath,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              drawing.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'السعر: ${drawing.price} ر.س',
              style: TextStyle(
                fontSize: 16,
                color: Colors.amber[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // تنفيذ عملية الشراء
              if (drawing.productId != null) {
                bool success = await purchaseService.purchaseProduct(drawing.productId!);
                if (success) {
                  await firebaseService.recordPurchase(drawing.id, drawing.productId!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم الشراء بنجاح!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: Text('شراء'),
          ),
        ],
      ),
    );
  }
}