import 'package:flutter/material.dart'; import 'package:url_launcher/url_launcher.dart'; import 'dart:convert'; import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(NombuBeautyApp());

class NombuBeautyApp extends StatelessWidget { @override Widget build(BuildContext context) { return MaterialApp( title: 'NOMBU Beauty', theme: ThemeData( primarySwatch: Colors.pink, scaffoldBackgroundColor: Color(0xFFFDE6EB), fontFamily: 'Poppins', ), debugShowCheckedModeBanner: false, home: HomeScreen(), ); } }

// ------------------------- HOME SCREEN ------------------------- class HomeScreen extends StatefulWidget { @override _HomeScreenState createState() => _HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> { final List<Map<String, dynamic>> categories = [ {'name': 'Hair Services', 'icon': Icons.content_cut}, {'name': 'Hair Laundry', 'icon': Icons.local_laundry_service}, {'name': 'Makeup', 'icon': Icons.brush}, {'name': 'Admin Dashboard', 'icon': Icons.admin_panel_settings}, ];

@override Widget build(BuildContext context) { return Scaffold( appBar: AppBar( title: Text('NOMBU Beauty'), backgroundColor: Colors.pink.shade400, ), body: Padding( padding: const EdgeInsets.all(16.0), child: GridView.builder( itemCount: categories.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1, ), itemBuilder: (context, index) { final category = categories[index]; return GestureDetector( onTap: () { if (category['name'] == 'Admin Dashboard') { Navigator.push(context, MaterialPageRoute(builder: () => AdminDashboard())); } else { Navigator.push(context, MaterialPageRoute(builder: () => ServiceScreen(category: category['name']))); } }, child: Container( decoration: BoxDecoration( gradient: LinearGradient( colors: [Colors.pink.shade100, Colors.pink.shade50], begin: Alignment.topLeft, end: Alignment.bottomRight, ), borderRadius: BorderRadius.circular(20), boxShadow: [ BoxShadow( color: Colors.pink.shade200.withOpacity(0.4), blurRadius: 8, offset: Offset(0, 4), ), ], ), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(category['icon'], size: 50, color: Colors.pink.shade800), SizedBox(height: 12), Text(category['name'], textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink.shade700)), ], ), ), ); }, ), ), ); } }

// ------------------------- SERVICE SCREEN ------------------------- class ServiceScreen extends StatefulWidget { final String category; ServiceScreen({required this.category});

@override _ServiceScreenState createState() => _ServiceScreenState(); }

class _ServiceScreenState extends State<ServiceScreen> { final Map<String, List<Map<String, dynamic>>> services = { 'Hair Services': [ {'name': 'Basic instal', 'price': 200}, {'name': 'Instal + styling', 'price': 280}, {'name': 'Sew-in instal', 'price': 300}, {'name': 'Instal + curling', 'price': 400}, {'name': 'Frontal ponytail', 'price': 350}, ], 'Hair Laundry': [ {'name': 'Wig wash', 'price': 150}, {'name': 'Plugging', 'price': 80}, {'name': 'Wig customisation (tint)', 'price': 180}, {'name': 'Bleaching + plugging', 'price': 220}, ], 'Makeup': [ {'name': 'Natural look', 'price': 300}, {'name': 'Soft glam', 'price': 400}, {'name': 'Soft glam (lashes)', 'price': 450}, {'name': 'Full glam', 'price': 500}, {'name': 'Full glam (lashes)', 'price': 550}, ], };

String? selectedService; int? selectedPrice; String? selectedLocation; String? selectedSubLocation; String selectedPayment = 'Cash';

final String whatsappNumber = '+27672412217';

List<String> locations = ['Pretoria', 'Limpopo']; Map<String, List<String>> subLocations = { 'Pretoria': ['Hammanskraal', 'Montana'], 'Limpopo': ['Polokwane'], };

void sendWhatsAppRequest() async { if (selectedService == null || selectedLocation == null || selectedSubLocation == null) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select service and location'))); return; }

String message =
    'Hello NOMBU Beauty 🌸\n\n'
    'I'd like to request a booking.\n\n'
    'Service: $selectedService\n'
    'Location: $selectedLocation - $selectedSubLocation\n'
    'Payment method: $selectedPayment';

String url = 'https://wa.me/$whatsappNumber?text=${Uri.encodeFull(message)}';
if (await canLaunch(url)) {
  await launch(url);
}

}

@override Widget build(BuildContext context) { List<Map<String, dynamic>> categoryServices = services[widget.category]!;

return Scaffold(
  appBar: AppBar(title: Text(widget.category), backgroundColor: Colors.pink.shade400),
  body: SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Select Service', filled: true, fillColor: Colors.pink.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          value: selectedService,
          items: categoryServices.map((s) => DropdownMenuItem(value: s['name'], child: Text('${s['name']} - R${s['price']}'))).toList(),
          onChanged: (val) => setState(() {
            selectedService = val;
            selectedPrice = categoryServices.firstWhere((s) => s['name'] == val)['price'];
          }),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Select Location', filled: true, fillColor: Colors.pink.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          value: selectedLocation,
          items: locations.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
          onChanged: (val) => setState(() {
            selectedLocation = val;
            selectedSubLocation = null;
          }),
        ),
        if (selectedLocation != null)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Select Area', filled: true, fillColor: Colors.pink.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            value: selectedSubLocation,
            items: subLocations[selectedLocation!]!.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (val) => setState(() => selectedSubLocation = val),
          ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Payment Method', filled: true, fillColor: Colors.pink.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          value: selectedPayment,
          items: ['Cash', 'Card', 'E-wallet'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
          onChanged: (val) => setState(() => selectedPayment = val!),
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade400, padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: sendWhatsAppRequest,
            child: Text('Send Booking Request via WhatsApp', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    ),
  ),
);

} }

// ------------------------- ADMIN DASHBOARD ------------------------- class AdminDashboard extends StatefulWidget { @override _AdminDashboardState createState() => _AdminDashboardState(); }

class _AdminDashboardState extends State<AdminDashboard> { final TextEditingController _passwordController = TextEditingController(); bool _authenticated = false;

List<Map<String, dynamic>> bookingRequests = []; // Replace with local storage in next step

void _checkPassword() { if (_passwordController.text == '2478') { setState(() => _authenticated = true); } else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password'))); } }

void sendAdminWhatsApp(String number, String service, String status, String date, String time, String payment) async { String message = ''; if (status == 'Confirmed') { message = 'Hello $number 🌸\nYour booking for $service on $date at $time has been confirmed.\nPayment method: $payment\nThank you for choosing NOMBU Beauty!'; } else { message = 'Hello $number 🌸\nUnfortunately, your booking for $service on $date at $time has been declined.\nPlease contact us if you’d like to reschedule.\nThank you for understanding.'; }

String url = 'https://wa.me/$number?text=${Uri.encodeFull(message)}';
if (await canLaunch(url)) await launch(url);

}

@override Widget build(BuildContext context) { if (!_authenticated) { return Scaffold( appBar: AppBar(title: Text('Admin Dashboard')), body: Padding( padding: EdgeInsets.all(20), child: Column( children: [ TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Enter password')), SizedBox(height: 20), ElevatedButton(onPressed: _checkPassword, child: Text('Enter')), ], ), ), ); }

return Scaffold(
  appBar: AppBar(title: Text('Admin Dashboard')),
  body: bookingRequests.isEmpty
      ? Center(child: Text('No booking requests yet'))
      : ListView.builder(
          itemCount: bookingRequests.length,
          itemBuilder: (context, index) {
            final req = bookingRequests[index];
            return Card(
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: ListTile(
                title: Text('${req['name']} - ${req['service']} (${req['status']})'),
                subtitle: Text('${req['date']} ${req['time']}\nPayment: ${req['payment']}\nLocation: ${req['location']} - ${req['subLocation']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => sendAdminWhatsApp(req['number'], req['service'], 'Confirmed', req['date'], req['time'], req['payment']),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => sendAdminWhatsApp(req['number'], req['service'], 'Declined', req['date'], req['time'], req['payment']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
);

} }
