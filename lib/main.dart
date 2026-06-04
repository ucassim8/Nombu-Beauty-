import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(NombuBeautyApp());
}

class NombuBeautyApp extends StatefulWidget {
  @override
  State<NombuBeautyApp> createState() => _NombuBeautyAppState();
}

class _NombuBeautyAppState extends State<NombuBeautyApp> {
  // Global Basket State shared across the app
  final List<Map<String, dynamic>> basketItems = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOMBU Beauty',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFDE6EB),
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: BookingPoliciesScreen(basketItems: basketItems),
    );
  }
}

// ------------------------- BOOKING POLICIES -------------------------
class BookingPoliciesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> basketItems;
  BookingPoliciesScreen({required this.basketItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Policies'),
        backgroundColor: Colors.pink.shade400,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''
All appointments must be booked in advance through website/call or in person.
* A non-refundable deposit of R100 is required to secure your appointment.
* No Walk-ins will be accepted.

Cancellation & Rescheduling
* We require 24 hours notice for cancellation or rescheduling.
* Cancellations made within 24 hours will result in a forfeited deposit.

Late Policy
* Clients arriving more than 15 minutes late may need to reschedule and the deposit will be forfeited.
* If we can still accommodate your appointment despite tardiness, a late fee of R50 will apply.
* After hours (before 8 AM or after 6 PM) incur a R100 fee.

Refund & Satisfaction Policy
* No refunds on services. 

By booking an appointment, you agree to abide by our salon policies. Thank you for trusting us with your wig care!💗
@NOMBU BEAUTY
                  ''',
                  style: TextStyle(fontSize: 14, color: Colors.pink.shade700, height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SplashScreen(basketItems: basketItems))),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Accept & Continue', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ------------------------- SPLASH SCREEN -------------------------
class SplashScreen extends StatefulWidget {
  final List<Map<String, dynamic>> basketItems;
  SplashScreen({required this.basketItems});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(basketItems: widget.basketItems)));
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pink.shade100, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.jpg', width: 130, height: 130),
                const SizedBox(height: 20),
                Text('NOMBU Beauty', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink.shade800)),
                const SizedBox(height: 8),
                Text('Your beauty, your way 🌸', style: TextStyle(fontSize: 15, color: Colors.pink.shade400, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------- HOME SCREEN -------------------------
class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> basketItems;
  HomeScreen({required this.basketItems});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Hair Services', 'icon': Icons.content_cut},
    {'name': 'Hair Laundry', 'icon': Icons.local_laundry_service},
    {'name': 'Makeup', 'icon': Icons.brush},
    {'name': 'Admin Dashboard', 'icon': Icons.admin_panel_settings},
  ];

  final String instagramUrl = "https://www.instagram.com/nombu.beauty?igsh=MzRlODBiNWFlZA==";
  final String tiktokUrl = "https://www.tiktok.com/@nombu.beauty?_r=1&_t=ZS-96uL017nPM7";

  void _launchSocial(String url) async {
    if (kIsWeb) {
      js.context.callMethod('open', [url, '_blank']);
    } else {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/Logonombu.jpg', width: 40, height: 40),
            const SizedBox(width: 12),
            const Text('NOMBU Beauty', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.pink.shade400,
        elevation: 5,
        actions: [
          // Shopping Basket icon button in AppBar
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_basket, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BasketScreen(basketItems: widget.basketItems)),
                  ).then((_) => setState(() {}));
                },
              ),
              if (widget.basketItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${widget.basketItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      if (category['name'] == 'Admin Dashboard') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ServiceScreen(category: category['name'], basketItems: widget.basketItems)),
                        ).then((_) => setState(() {}));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.pink.shade100, Colors.pink.shade50], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.pink.shade200.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category['icon'], size: 45, color: Colors.pink.shade800),
                          const SizedBox(height: 10),
                          Text(category['name'], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink.shade900)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // ----------------- SOCIAL MEDIA LINKS SECTIONS -----------------
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Follow Our Pages: ",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink.shade700, fontSize: 15),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, size: 32),
                  color: Colors.pink.shade800,
                  tooltip: 'Instagram',
                  onPressed: () => _launchSocial(instagramUrl),
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.music_note_outlined, size: 32),
                  color: Colors.pink.shade800,
                  tooltip: 'TikTok',
                  onPressed: () => _launchSocial(tiktokUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------- SERVICE SCREEN -------------------------
class ServiceScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> basketItems;
  ServiceScreen({required this.category, required this.basketItems});
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final Map<String, List<Map<String, dynamic>>> servicesList = {
    'Hair Services': [
      {'name': 'Basic instal', 'price': 200},
      {'name': 'Instal + styling', 'price': 280},
      {'name': 'Sew-in instal', 'price': 300},
      {'name': 'Instal + curling', 'price': 400},
      {'name': 'Frontal ponytail', 'price': 350},
    ],
    'Hair Laundry': [
      {'name': 'Wig wash', 'price': 150},
      {'name': 'Plugging', 'price': 80},
      {'name': 'Wig customisation (tint)', 'price': 180},
      {'name': 'Bleaching + plugging', 'price': 220},
    ],
    'Makeup': [
      {'name': 'Natural look', 'price': 300},
      {'name': 'Soft glam', 'price': 400},
      {'name': 'Soft glam (lashes)', 'price': 450},
      {'name': 'Full glam (lashes)', 'price': 550},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final services = servicesList[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category), 
        backgroundColor: Colors.pink.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BasketScreen(basketItems: widget.basketItems)),
              ).then((_) => setState(() {}));
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final isInBasket = widget.basketItems.any((item) => item['name'] == service['name']);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text(service['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('R${service['price']}', style: TextStyle(color: Colors.pink.shade700, fontWeight: FontWeight.bold)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInBasket ? Colors.grey : Colors.pink.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    if (isInBasket) {
                      widget.basketItems.removeWhere((item) => item['name'] == service['name']);
                    } else {
                      widget.basketItems.add(service);
                    }
                  });
                },
                child: Text(isInBasket ? 'Remove' : 'Add to Basket', style: const TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------------- BASKET / CHECKOUT SCREEN -------------------------
class BasketScreen extends StatefulWidget {
  final List<Map<String, dynamic>> basketItems;
  BasketScreen({required this.basketItems});

  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final Map<String, List<String>> provinceLocations = {
    'Pretoria': ['Montana', 'Hammanskraal'],
    'Limpopo': ['Polokwane'],
  };

  String? selectedProvince, selectedLocation, clientName, clientPhone;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isAfterHours = false;

  int get baseTotalPrice => widget.basketItems.fold(0, (sum, item) => sum + (item['price'] as int));
  int get finalPrice => baseTotalPrice + (isAfterHours ? 100 : 0);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2027),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        isAfterHours = (picked.hour < 8 || picked.hour >= 18);
      });
    }
  }

  void triggerWhatsApp() {
    if (widget.basketItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your basket is empty!')));
      return;
    }
    if (clientName == null || clientPhone == null || selectedProvince == null || 
        selectedLocation == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields!')));
      return;
    }

    String formattedDate = "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
    String formattedTime = selectedTime!.format(context);

    // Grouping selected items neatly for WhatsApp output layout
    String servicesText = widget.basketItems.map((item) => "- ${item['name']} (R${item['price']})").join("\n");
    String servicesSummary = widget.basketItems.map((item) => item['name']).join(", ");

    String message = 'Hello NOMBU Beauty 🌸\n\n'
        'I\'d like to request a booking for the following basket:\n\n'
        '$servicesText\n\n'
        'Name: $clientName\n'
        'Phone: $clientPhone\n'
        'Location: $selectedLocation\n'
        'Date: $formattedDate at $formattedTime\n'
        '${isAfterHours ? "After Hours: Yes (R100 fee applied)\n" : ""}'
        'Estimated Total Price: R$finalPrice\n\n'
        'Final price to be confirmed by stylist.\n\n'
        'I will send my reference photo below. Thank you.';

    final String webUrl = "https://api.whatsapp.com/send?phone=27672412217&text=${Uri.encodeComponent(message)}";
    
    if (kIsWeb) js.context.callMethod('open', [webUrl, '_blank']);
    else launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);

    FirebaseFirestore.instance.collection('bookings').add({
      'clientName': clientName,
      'phoneNumber': clientPhone,
      'service': servicesSummary, 
      'location': '$selectedLocation, $selectedProvince',
      'date': formattedDate,
      'time': formattedTime,
      'afterHours': isAfterHours,
      'price': finalPrice,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    widget.basketItems.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Basket Summary'), backgroundColor: Colors.pink.shade400),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          if (widget.basketItems.isEmpty)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Your basket is empty. Go add some styling services! 🌸', style: TextStyle(color: Colors.pink.shade900)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.basketItems.length,
              itemBuilder: (context, idx) {
                final item = widget.basketItems[idx];
                return ListTile(
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('R${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  leading: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => setState(() => widget.basketItems.removeAt(idx)),
                  ),
                );
              },
            ),
          const Divider(thickness: 2),
          const SizedBox(height: 10),
          TextField(decoration: InputDecoration(labelText: 'Your Name', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))), onChanged: (val) => clientName = val),
          const SizedBox(height: 10),
          TextField(decoration: InputDecoration(labelText: 'WhatsApp Number', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))), keyboardType: TextInputType.phone, onChanged: (val) => clientPhone = val),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Select Province', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
            items: provinceLocations.keys.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (val) => setState(() { selectedProvince = val; selectedLocation = null; }),
          ),
          const SizedBox(height: 15),
          if (selectedProvince != null)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Location', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              value: selectedLocation,
              items: provinceLocations[selectedProvince]!.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (val) => setState(() => selectedLocation = val),
            ),
          const SizedBox(height: 15),
          SwitchListTile(
            title: const Text("After Hours (R100 Fee)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            subtitle: Text(isAfterHours ? "Applied based on time selection." : "Slots before 8AM or after 6PM"),
            value: isAfterHours,
            activeColor: Colors.pink,
            onChanged: null, 
          ),
          const SizedBox(height: 15),
          Row(children: [
            Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.calendar_today, color: Colors.pink), label: Text(selectedDate == null ? "Date" : "${selectedDate!.day}/${selectedDate!.month}"), onPressed: () => _selectDate(context))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.access_time, color: Colors.pink), label: Text(selectedTime == null ? "Time" : selectedTime!.format(context)), onPressed: () => _selectTime(context))),
          ]),
          const SizedBox(height: 35),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade400, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            onPressed: triggerWhatsApp,
            child: Text('Book Basket (R$finalPrice)', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ]),
      ),
    );
  }
}

// ------------------------- ADMIN DASHBOARD (PART 1) -------------------------
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _auth = false;
  final TextEditingController _pass = TextEditingController();

  // Helper to parse "DD/MM/YYYY" string into a real DateTime for sorting
  DateTime _parseBookingDate(String dateStr) {
    try {
      List<String> parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (e) {
      print("Error parsing date: $dateStr");
    }
    return DateTime(2099); // Fallback to bottom if parsing fails
  }

  void _showEditDialog(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    TextEditingController serviceCtrl = TextEditingController(text: data['service']);
    TextEditingController priceCtrl = TextEditingController(text: data['price'].toString());
    TextEditingController locCtrl = TextEditingController(text: data['location']);
    TextEditingController dateCtrl = TextEditingController(text: data['date']);
    TextEditingController timeCtrl = TextEditingController(text: data['time']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit & Approve"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: serviceCtrl, decoration: const InputDecoration(labelText: "Service")),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: "Price (R)"), keyboardType: TextInputType.number),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: "Location")),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: "Date")),
              TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: "Time")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              doc.reference.update({
                'service': serviceCtrl.text, 
                'price': int.parse(priceCtrl.text), 
                'location': locCtrl.text,
                'date': dateCtrl.text,
                'time': timeCtrl.text,
                'status': 'Approved'
              });
              
              String msg = "Hello ${data['clientName']} 🌸,\n\n"
                  "Your booking for ${serviceCtrl.text} at NOMBU Beauty has been Approved!\n\n"
                  "Booking Details:\n"
                  "📍 Location: ${locCtrl.text}\n"
                  "📅 Date: ${dateCtrl.text} at ${timeCtrl.text}\n"
                  "💰 Total Price: R${priceCtrl.text}\n\n"
                  "To secure your slot, please pay a non-refundable deposit of R100.\n\n"
                  "Banking Details:\n"
                  "Bank: Capitec\nName: Mrs K Siwela\nAccount: 1867785194\nType: Savings\n\n"
                  "Please send proof of payment. We can't wait to see you! 💗";

              String rawPhone = data['phoneNumber'] ?? "";
              String cleanPhone = rawPhone.replaceAll(RegExp(r'[^0-9]'), ''); 

              if (cleanPhone.startsWith('270')) {
                cleanPhone = '27' + cleanPhone.substring(3);
              } else if (cleanPhone.startsWith('0')) {
                cleanPhone = '27' + cleanPhone.substring(1);
              } else if (!cleanPhone.startsWith('27')) {
                cleanPhone = '27' + cleanPhone;
              }

              final String url = "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(msg)}";
              
              if (kIsWeb) js.context.callMethod('open', [url, '_blank']);
              else launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              
              Navigator.pop(context);
            },
            child: const Text("Approve & WhatsApp"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_auth) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Login'), backgroundColor: Colors.pink.shade400),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock_outline, size: 60, color: Colors.pink),
            const SizedBox(height: 20),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade400), onPressed: () { if (_pass.text == '2478') setState(() => _auth = true); }, child: const Text('Login', style: TextStyle(color: Colors.white)))
          ]),
        )),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings Manager'),
          backgroundColor: Colors.pink.shade400,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.calendar_today), text: "Active Bookings"),
              Tab(icon: Icon(Icons.history), text: "History"),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            
            return TabBarView(
              children: [
                _buildBookingList(snapshot.data!.docs, false),
                _buildBookingList(snapshot.data!.docs, true),
              ],
            );
          },
        ),
      ),
    );
  }       // ------------------------- ADMIN DASHBOARD (PART 2 - REVENUE FIX) -------------------------
  Widget _buildBookingList(List<DocumentSnapshot> docs, bool isHistory) {
    // 1. Handle the Active Bookings Tab
    if (!isHistory) {
      List<DocumentSnapshot> activeList = docs.where((doc) {
        String status = (doc.data() as Map<String, dynamic>)['status'] ?? 'Pending';
        return status == 'Pending' || status == 'Approved';
      }).toList();

      // Custom Sorting Logic for Active bookings (Pending at top, Approved by date next)
      activeList.sort((a, b) {
        Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
        Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;

        String statusA = dataA['status'] ?? 'Pending';
        String statusB = dataB['status'] ?? 'Pending';

        if (statusA == 'Pending' && statusB != 'Pending') return -1;
        if (statusB == 'Pending' && statusA != 'Pending') return 1;

        if (statusA == 'Pending' && statusB == 'Pending') {
          Timestamp tA = dataA['timestamp'] ?? Timestamp.now();
          Timestamp tB = dataB['timestamp'] ?? Timestamp.now();
          return tB.compareTo(tA);
        }

        DateTime dateA = _parseBookingDate(dataA['date'] ?? "");
        DateTime dateB = _parseBookingDate(dataB['date'] ?? "");
        return dateA.compareTo(dateB);
      });

      if (activeList.isEmpty) {
        return Center(
          child: Text('No active client bookings!', style: TextStyle(color: Colors.pink.shade900, fontSize: 16)),
        );
      }

      return ListView.builder(
        itemCount: activeList.length,
        itemBuilder: (context, index) => _buildBookingCard(activeList[index], false),
      );
    }

    // 2. Handle the History Tab (Separate Completed and Cancelled)
    List<DocumentSnapshot> completedList = docs.where((doc) => ((doc.data() as Map<String, dynamic>)['status'] == 'Completed')).toList();
    List<DocumentSnapshot> cancelledList = docs.where((doc) => ((doc.data() as Map<String, dynamic>)['status'] == 'Cancelled')).toList();

    // Calculate Total Revenue from Completed Appointments
    int totalEarnings = completedList.fold(0, (sum, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      var priceVal = data['price'];
      int price = 0;
      if (priceVal is int) price = priceVal;
      else if (priceVal is String) price = int.tryParse(priceVal) ?? 0;
      return sum + price;
    });

    // Sort history records by newest submission timestamp first so recent history is on top
    var historySort = (DocumentSnapshot a, DocumentSnapshot b) {
      Timestamp tA = (a.data() as Map<String, dynamic>)['timestamp'] ?? Timestamp.now();
      Timestamp tB = (b.data() as Map<String, dynamic>)['timestamp'] ?? Timestamp.now();
      return tB.compareTo(tA);
    };
    completedList.sort(historySort);
    cancelledList.sort(historySort);

    if (completedList.isEmpty && cancelledList.isEmpty) {
      return Center(
        child: Text('No history matches found.', style: TextStyle(color: Colors.pink.shade900, fontSize: 16)),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // --- TOTAL REVENUE SUMMARY CARD ---
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.green.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.green.shade200)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.payments, color: Colors.green),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Revenue",
                      style: TextStyle(fontSize: 14, color: Colors.green.shade900, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "R$totalEarnings",
                      style: TextStyle(fontSize: 24, color: Colors.green.shade900, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 8),

        // --- COMPLETED SECTION ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green),
              const SizedBox(width: 8),
              Text("Completed Appointments (${completedList.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
        if (completedList.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("No completed appointments yet.", style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
          )
        else
          ...completedList.map((doc) => _buildBookingCard(doc, true)),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Divider(thickness: 1.5),
        ),

        // --- CANCELLED SECTION ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.cancel_outlined, color: Colors.orange),
              const SizedBox(width: 8),
              Text("Cancelled Appointments (${cancelledList.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
        ),
        if (cancelledList.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("No cancelled appointments yet.", style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
          )
        else
          ...cancelledList.map((doc) => _buildBookingCard(doc, true)),
      ],
    );
  }

  // Extracted card widget builder to keep layouts identical and code concise
  Widget _buildBookingCard(DocumentSnapshot doc, bool isHistory) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String status = data['status'] ?? 'Pending';

    Color badgeColor;
    Color textColor;
    if (status == 'Pending') {
      badgeColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    } else if (status == 'Approved') {
      badgeColor = Colors.blue.shade100;
      textColor = Colors.blue.shade800;
    } else if (status == 'Completed') {
      badgeColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else {
      badgeColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              data['clientName'] ?? 'No Name', 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
              child: Text(
                status, 
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            "${data['service'] ?? 'null'}\n📍 ${data['location'] ?? 'null'}\n📅 ${data['date'] ?? 'null'} at ${data['time'] ?? 'null'}",
            style: TextStyle(height: 1.3, color: Colors.grey.shade800),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isHistory) ...[
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 22),
                tooltip: 'Edit Details',
                onPressed: () => _showEditDialog(doc),
              ),
              if (status == 'Pending')
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green, size: 22),
                  tooltip: 'Approve & WhatsApp',
                  onPressed: () => _showEditDialog(doc),
                ),
              if (status == 'Approved')
                IconButton(
                  icon: const Icon(Icons.done_all, color: Colors.purple, size: 22),
                  tooltip: 'Mark as Completed',
                  onPressed: () => doc.reference.update({'status': 'Completed'}),
                ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.orange, size: 22),
                tooltip: 'Cancel Appointment',
                onPressed: () => doc.reference.update({'status': 'Cancelled'}),
              ),
            ],
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 22),
              tooltip: 'Delete Permanently',
              onPressed: () => doc.reference.delete(),
            ),
          ],
        ),
      ),
    );
  }
}
         
    
