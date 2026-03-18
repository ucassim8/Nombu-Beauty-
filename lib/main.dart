import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

void main() {
  runApp(NombuBeautyApp());
}

class NombuBeautyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOMBU Beauty',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Color(0xFFFDE6EB),
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// -------------------- HOME SCREEN --------------------

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: Text('NOMBU Beauty'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                if (category['name'] == 'Admin Dashboard') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminDashboard()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ServiceScreen(category: category['name'])));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade100, Colors.pink.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade200.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category['icon'], size: 50, color: Colors.pink.shade800),
                    SizedBox(height: 12),
                    Text(category['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade700)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// -------------------- SERVICE SCREEN --------------------

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
      {'name': 'Full glam', 'price': 500},
      {'name': 'Full glam (lashes)', 'price': 550},
    ],
  };

  String? selectedService;
  String? selectedLocation;
  String? selectedSubLocation;
  String? selectedPayment;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  Map<String, List<String>> locationsMap = {
    'Pretoria': ['Montana', 'Hammanskraal'],
    'Limpopo': ['Polokwane'],
  };

  final List<String> payments = ['Cash', 'Card', 'E-wallet'];

  List<Map<String, dynamic>> get categoryServices =>
      services[widget.category]!;

  void sendWhatsAppMessage() async {
    if (nameController.text.isEmpty ||
        numberController.text.isEmpty ||
        selectedService == null ||
        selectedLocation == null ||
        selectedSubLocation == null ||
        selectedPayment == null ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill out all fields.')));
      return;
    }

    final message = Uri.encodeComponent(
        "I'd like to request a booking.\n\n"
        "Name: ${nameController.text}\n"
        "Number: ${numberController.text}\n"
        "Category: ${widget.category}\n"
        "Service: $selectedService\n"
        "Location: $selectedLocation - $selectedSubLocation\n"
        "Payment: $selectedPayment\n"
        "Date: ${dateController.text}\n"
        "Time: ${timeController.text}");

    final whatsappUrl = "https://wa.me/27${numberController.text}?text=$message";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open WhatsApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.pink.shade400,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: numberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select Service'),
              value: selectedService,
              items: categoryServices
                  .map((s) => DropdownMenuItem<String>(
                        value: s['name'].toString(),
                        child: Text('${s['name']} - R${s['price']}'),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedService = value),
            ),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select Location'),
              value: selectedLocation,
              items: locationsMap.keys
                  .map((l) => DropdownMenuItem<String>(
                        value: l,
                        child: Text(l),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                  selectedSubLocation = null;
                });
              },
            ),
            if (selectedLocation != null)
              DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select Sub-location'),
                value: selectedSubLocation,
                items: locationsMap[selectedLocation]!
                    .map((s) => DropdownMenuItem<String>(
                          value: s,
                          child: Text(s),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedSubLocation = value),
              ),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Payment Method'),
              value: selectedPayment,
              items: payments
                  .map((p) => DropdownMenuItem<String>(
                        value: p,
                        child: Text(p),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedPayment = value),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendWhatsAppMessage,
              child: Text('Send Booking Request via WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- ADMIN DASHBOARD --------------------

class BookingRequest {
  final String name;
  final String number;
  final String category;
  final String service;
  final String location;
  final String payment;
  final String date;
  final String time;

  BookingRequest({
    required this.name,
    required this.number,
    required this.category,
    required this.service,
    required this.location,
    required this.payment,
    required this.date,
    required this.time,
  });

  Map<String, String> toMap() => {
        'name': name,
        'number': number,
        'category': category,
        'service': service,
        'location': location,
        'payment': payment,
        'date': date,
        'time': time,
      };

  factory BookingRequest.fromMap(Map<String, dynamic> map) => BookingRequest(
        name: map['name'],
        number: map['number'],
        category: map['category'],
        service: map['service'],
        location: map['location'],
        payment: map['payment'],
        date: map['date'],
        time: map['time'],
      );
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _passwordController = TextEditingController();
  bool _authenticated = false;

  List<BookingRequest> bookingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('bookings');
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        bookingRequests =
            decoded.map((e) => BookingRequest.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveBookings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('bookings',
        jsonEncode(bookingRequests.map((e) => e.toMap()).toList()));
  }

  void _acceptBooking(BookingRequest request) async {
    final message =
        "Hi ${request.name}, your booking for ${request.service} on ${request.date} at ${request.time} is confirmed.";
    final whatsappUrl = "https://wa.me/27${request.number}?text=${Uri.encodeComponent(message)}";
    if (await canLaunch(whatsappUrl)) await launch(whatsappUrl);
  }

  void _declineBooking(BookingRequest request) async {
    final message =
        "Hi ${request.name}, unfortunately your booking for ${request.service} on ${request.date} at ${request.time} has been declined.";
    final whatsappUrl = "https://wa.me/27${request.number}?text=${Uri.encodeComponent(message)}";
    if (await canLaunch(whatsappUrl)) await launch(whatsappUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return Scaffold(
        appBar: AppBar(title: Text('Admin Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text == 'admin123') {
                      setState(() => _authenticated = true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Wrong password')));
                    }
                  },
                  child: Text('Login'))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: ListView.builder(
        itemCount: bookingRequests.length,
        itemBuilder: (context, index) {
          final req = bookingRequests[index];
          return Card(
            child: ListTile(
              title: Text('${req.name} - ${req.service}'),
              subtitle: Text(
                  '${req.category}\n${req.location}\nPayment: ${req.payment}\nDate: ${req.date} at ${req.time}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _acceptBooking(req)),
                  IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _declineBooking(req)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
