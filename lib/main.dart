import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

// ------------------------- MAIN -------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(NombuBeautyApp());
}

class NombuBeautyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOMBU Beauty',
      theme: ThemeData(
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFDE6EB),
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: BookingPoliciesScreen(),
    );
  }
}

// ------------------------- BOOKING POLICIES -------------------------
class BookingPoliciesScreen extends StatelessWidget {
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
* Clients arriving more than an hour late may need to reschedule and the deposit will be forfeited.
* If we can still accommodate your appointment despite tardiness, a late fee of R50 will apply.

Refund & Satisfaction Policy
* No refunds on services. 

By booking an appointment, you agree to abide by our salon policies. Thank you for trusting us with your wig care!💗
@NOMBU BEAUTY
                  ''',
                  style: TextStyle(fontSize: 14, color: Colors.pink.shade700, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SplashScreen())),
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink.shade100, Colors.white], 
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.jpg', width: 150, height: 150),
                const SizedBox(height: 16),
                Text('NOMBU Beauty', 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink.shade800)),
                const SizedBox(height: 8),
                Text('Your beauty, your way 🌸',
                    style: TextStyle(fontSize: 16, color: Colors.pink.shade400, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------- HOME SCREEN -------------------------
class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Hair Services', 'icon': Icons.content_cut},
    {'name': 'Hair Laundry', 'icon': Icons.local_laundry_service},
    {'name': 'Makeup', 'icon': Icons.brush},
    {'name': 'Admin Dashboard', 'icon': Icons.admin_panel_settings},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOMBU Beauty', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              mainAxisSpacing: 16, 
              crossAxisSpacing: 16,
              childAspectRatio: 1.0
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              onTap: () {
                if (category['name'] == 'Admin Dashboard') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceScreen(category: category['name'])));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(20), 
                  boxShadow: [BoxShadow(color: Colors.pink.shade100, blurRadius: 10, offset: const Offset(0, 4))]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Icon(category['icon'], size: 50, color: Colors.pink.shade400),
                    const SizedBox(height: 12),
                    Text(category['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ------------------------- SERVICE SCREEN -------------------------
class ServiceScreen extends StatefulWidget {
  final String category;
  ServiceScreen({required this.category});
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final Map<String, List<Map<String, dynamic>>> services = {
    'Hair Services': [
      {'name': 'Basic instal', 'price': 200}, 
      {'name': 'Instal + styling', 'price': 280}, 
      {'name': 'Sew-in instal', 'price': 300}
    ],
    'Hair Laundry': [
      {'name': 'Wig wash', 'price': 150}, 
      {'name': 'Plugging', 'price': 80}
    ],
    'Makeup': [
      {'name': 'Natural look', 'price': 300}, 
      {'name': 'Soft glam', 'price': 400}
    ],
  };

  String? selectedService, selectedProvince, selectedLocation, clientName, phoneNumber;
  int? selectedPrice;

  final String stylistWhatsapp = '27672412217'; 

  void triggerWhatsApp() async {
    if (selectedService == null || clientName == null || phoneNumber == null || selectedProvince == null || selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields!')));
      return;
    }

    String message = 'Hello NOMBU Beauty 🌸\n\n'
        'Booking Request:\n'
        'Name: $clientName\n'
        'Service: $selectedService\n'
        'Location: $selectedLocation, $selectedProvince\n'
        'Price: R${selectedPrice ?? 0}';

    final String webUrl = "https://api.whatsapp.com/send?phone=$stylistWhatsapp&text=${Uri.encodeComponent(message)}";
    
    if (kIsWeb) {
      js.context.callMethod('open', [webUrl, '_blank']);
    } else {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }

    // Save to Firebase quietly in background
    FirebaseFirestore.instance.collection('bookings').add({
      'clientName': clientName,
      'service': selectedService,
      'phoneNumber': phoneNumber,
      'location': '$selectedLocation, $selectedProvince',
      'price': selectedPrice,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request sent!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category), backgroundColor: Colors.pink.shade400),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(decoration: const InputDecoration(labelText: 'Your Name', border: OutlineInputBorder()), onChanged: (val) => clientName = val),
          const SizedBox(height: 15),
          TextField(decoration: const InputDecoration(labelText: 'WhatsApp Number', border: OutlineInputBorder()), onChanged: (val) => phoneNumber = val),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Province', border: OutlineInputBorder()),
            items: ['Pretoria', 'Limpopo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => selectedProvince = val),
          ),
          const SizedBox(height: 15),
          TextField(decoration: const InputDecoration(labelText: 'City/Suburb', border: OutlineInputBorder()), onChanged: (val) => selectedLocation = val),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Select Service', border: OutlineInputBorder()),
            items: services[widget.category]!.map((e) => DropdownMenuItem(value: e['name'] as String, child: Text("${e['name']} (R${e['price']})"))).toList(),
            onChanged: (val) {
              setState(() {
                selectedService = val;
                selectedPrice = services[widget.category]!.firstWhere((element) => element['name'] == val)['price'] as int;
              });
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade400, 
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            onPressed: triggerWhatsApp,
            child: const Text('Send via WhatsApp', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ]),
      ),
    );
  }
}

// ------------------------- ADMIN DASHBOARD -------------------------
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _auth = false;
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!_auth) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Login'), backgroundColor: Colors.pink.shade400),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Admin Password', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade400, minimumSize: const Size(200, 50)),
              onPressed: () { if (_pass.text == '2478') setState(() => _auth = true); else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect Password')));
              }}, 
              child: const Text('Login', style: TextStyle(color: Colors.white))
            )
          ]),
        )),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings Dashboard'), backgroundColor: Colors.pink.shade400),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Center(child: Text('No bookings found.'));
          
          return ListView(children: snapshot.data!.docs.map((doc) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(doc['clientName'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${doc['service']} - ${doc['location']}\nStatus: ${doc['status']}"),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green), 
                onPressed: () => doc.reference.update({'status': 'Approved'})
              ),
            ),
          )).toList());
        },
      ),
    );
  }
}
