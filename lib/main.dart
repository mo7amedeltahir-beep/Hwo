import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HWOApp());
}

class HWOApp extends StatelessWidget {
  const HWOApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HWO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
      ),
      home: const HWOScreen(),
    );
  }
}

class HWOScreen extends StatefulWidget {
  const HWOScreen({Key? key}) : super(key: key);

  @override
  State<HWOScreen> createState() => _HWOScreenState();
}

class _HWOScreenState extends State<HWOScreen> {
  final TextEditingController _phoneController = TextEditingController();
  
  // قائمة الدول ورمز الاتصال
  String selectedCountryCode = '+249';
  final List<Map<String, String>> countries = [
    {'name': 'السودان', 'code': '+249'},
    {'name': 'السعودية', 'code': '+966'},
    {'name': 'مصر', 'code': '+20'},
    {'name': 'الإمارات', 'code': '+971'},
    {'name': 'الأردن', 'code': '+962'},
    {'name': 'الكويت', 'code': '+965'},
  ];

  // قائمة المنصات المطلوبة
  String selectedPlatform = 'WhatsApp';
  final List<Map<String, String>> platforms = [
    {'key': 'WhatsApp', 'name': 'فتح في واتساب'},
    {'key': 'Telegram', 'name': 'فتح في تلجرام'},
    {'key': 'Facebook', 'name': 'البحث في فيسبوك'},
    {'key': 'Instagram', 'name': 'بحث في انستجرام'},
    {'key': 'TikTok', 'name': 'بحث في التيك توك'},
  ];

  // دالة البحث وفتح الروابط
  Future<void> _performSearch() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم الهاتف أولاً')),
      );
      return;
    }

    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    String fullNumber = selectedCountryCode + phone;
    String urlString = '';

    if (selectedPlatform == 'WhatsApp') {
      urlString = 'https://wa.me/$fullNumber';
    } else if (selectedPlatform == 'Telegram') {
      urlString = 'https://t.me/$fullNumber';
    } else if (selectedPlatform == 'Facebook') {
      urlString = 'https://www.facebook.com/search/top/?q=$fullNumber';
    } else if (selectedPlatform == 'Instagram') {
      urlString = 'https://www.instagram.com/explore/search/keyword/?q=$fullNumber';
    } else if (selectedPlatform == 'TikTok') {
      urlString = 'https://www.tiktok.com/search?q=$fullNumber';
    }

    final Uri uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('عذراً، تعذر فتح الرابط: $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. مكان شريط الإعلانات في أعلى الشاشة (Banner Ad Placeholder)
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'شريط إعلانات (Ad Banner)',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),

              // 2. كلمة HWO الكبيرة في الأعلى
              const Text(
                'HWO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 35),

              // 3. خانة إدخال رقم الهاتف وقائمة الدول
              const Text(
                'رقم الهاتف',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCountryCode,
                        dropdownColor: Colors.grey[900],
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        items: countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country['code'],
                            child: Text('${country['name']} (${country['code']})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountryCode = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'أدخل الرقم...',
                        hintStyle: constTextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[900],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: Border.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 4. القائمة المنسدلة لاختيار المنصة
              const Text(
                'اختر التطبيق أو الموقع',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPlatform,
                    dropdownColor: Colors.grey[900],
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    items: platforms.map((platform) {
                      return DropdownMenuItem<String>(
                        value: platform['key'],
                        child: Text(platform['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPlatform = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 5. زر البحث في الأسفل
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'بحث / فتح',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
