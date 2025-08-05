import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:provider/provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../services/firebase_service.dart';
import '../models/drawing_model.dart';

class ColoringScreen extends StatefulWidget {
  @override
  _ColoringScreenState createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  DrawingModel? drawing;
  Color selectedColor = Colors.red;
  double brushSize = 5.0;
  final GlobalKey<SignatureState> _signatureKey = GlobalKey<SignatureState>();
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool isEraserMode = false;
  List<Color> colorPalette = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.grey,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.teal,
    Colors.amber,
    Colors.deepOrange,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DrawingModel) {
      drawing = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (drawing == null) {
      return Scaffold(
        appBar: AppBar(title: Text('خطأ')),
        body: Center(
          child: Text('لم يتم العثور على الرسمة'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(drawing!.name),
        backgroundColor: Color(0xFFFF6B9D),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // زر الحفظ
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveArtwork,
          ),
          // زر مشاركة
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareArtwork,
          ),
          // زر إعادة تعيين
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetCanvas,
          ),
        ],
      ),
      body: Column(
        children: [
          // منطقة الرسم
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: Stack(
                    children: [
                      // صورة الخط الأساسية
                      Positioned.fill(
                        child: Image.asset(
                          drawing!.lineArtPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // طبقة الرسم
                      Positioned.fill(
                        child: Signature(
                          key: _signatureKey,
                          color: isEraserMode ? Colors.transparent : selectedColor,
                          strokeWidth: brushSize,
                          backgroundPainter: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // أدوات التلوين
          Container(
            height: 150,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFE4E6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // أزرار الأدوات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // زر الفرشاة
                    _buildToolButton(
                      icon: Icons.brush,
                      isSelected: !isEraserMode,
                      onPressed: () {
                        setState(() {
                          isEraserMode = false;
                        });
                      },
                    ),
                    // زر الممحاة
                    _buildToolButton(
                      icon: Icons.auto_fix_high,
                      isSelected: isEraserMode,
                      onPressed: () {
                        setState(() {
                          isEraserMode = true;
                        });
                      },
                    ),
                    // زر اختيار لون
                    _buildToolButton(
                      icon: Icons.palette,
                      isSelected: false,
                      onPressed: _showColorPicker,
                    ),
                    // زر تغيير حجم الفرشاة
                    _buildToolButton(
                      icon: Icons.line_weight,
                      isSelected: false,
                      onPressed: _showBrushSizePicker,
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // لوحة الألوان السريعة
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: colorPalette.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                            isEraserMode = false;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color && !isEraserMode
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFFF6B9D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : Color(0xFFFF6B9D),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختر لوناً'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
                isEraserMode = false;
              });
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('تم'),
          ),
        ],
      ),
    );
  }

  void _showBrushSizePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حجم الفرشاة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الحجم: ${brushSize.toInt()}'),
            Slider(
              value: brushSize,
              min: 1.0,
              max: 20.0,
              divisions: 19,
              onChanged: (value) {
                setState(() {
                  brushSize = value;
                });
              },
            ),
            // عرض مثال على حجم الفرشاة
            Container(
              width: brushSize * 2,
              height: brushSize * 2,
              decoration: BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('تم'),
          ),
        ],
      ),
    );
  }

  void _resetCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إعادة تعيين'),
        content: Text('هل تريد مسح جميع الألوان والبدء من جديد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              _signatureKey.currentState?.clear();
              Navigator.of(context).pop();
            },
            child: Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveArtwork() async {
    try {
      // التقاط صورة للعمل الفني
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // حفظ الصورة في معرض الهاتف
      bool? result = await GallerySaver.saveImage(
        String.fromCharCodes(pngBytes),
        albumName: 'Labubu Coloring',
      );

      if (result == true) {
        // حفظ في Firebase
        final firebaseService = Provider.of<FirebaseService>(context, listen: false);
        String artworkData = String.fromCharCodes(pngBytes);
        await firebaseService.saveUserArtwork(drawing!.id, artworkData);

        _showSuccessSnackBar('تم حفظ العمل الفني بنجاح!');
      } else {
        _showErrorSnackBar('فشل في حفظ العمل الفني');
      }
    } catch (e) {
      print('خطأ في حفظ العمل الفني: $e');
      _showErrorSnackBar('حدث خطأ أثناء الحفظ');
    }
  }

  Future<void> _shareArtwork() async {
    try {
      // التقاط صورة للعمل الفني
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // مشاركة الصورة
      await GallerySaver.saveImage(
        String.fromCharCodes(pngBytes),
        albumName: 'Labubu Coloring',
      );

      _showSuccessSnackBar('تم حفظ العمل الفني للمشاركة!');
      
      // يمكن إضافة مشاركة مباشرة هنا باستخدام share_plus package
    } catch (e) {
      print('خطأ في مشاركة العمل الفني: $e');
      _showErrorSnackBar('حدث خطأ أثناء المشاركة');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}