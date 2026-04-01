import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure Firebase is initialized here
  runApp(const NombuBeautyApp());
}

class NombuBeautyApp extends StatelessWidget {
  const NombuBeautyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF5F8),
      ),
      home: const HomeScreen(),
    );
  }
}

// ------------------------- HOME SCREEN -------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Hair Services', 'icon': Icons.content_cut, 'price': 'R200'},
    {'name': 'Hair Laundry', 'icon': Icons.local_laundry_service, 'price': 'R150'},
    {'name': 'Makeup', 'icon': Icons.brush, 'price': 'R300'},
    {'name': 'Admin Dashboard', 'icon': Icons.admin_panel_settings, 'price': ''},
  ];

  void _showFullPriceList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
            children: [
              Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              const Text("NOMBU Beauty Menu", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink)),
              const Divider(),
              _priceItem("Hair Services", ["Basic Install: R200", "Sew-in: R300", "Closure: R250"]),
              _priceItem("Laundry", ["Wig Wash: R150", "Plucking: R80"]),
              _priceItem("Makeup", ["Natural: R300", "Soft Glam: R400"]),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("* R100 non-refundable deposit required\n* After-hours (18:00+) fee: R100", 
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceItem(String title, List<String> details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.pink)),
          ...details.map((d) => Text(d, style: const TextStyle(fontSize: 16))).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NOMBU BEAUTY"), centerTitle: true, backgroundColor: Colors.pink[400]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showFullPriceList(context),
              icon: const Icon(Icons.list_alt),
              label: const Text("VIEW FULL PRICE LIST"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300], minimumSize: const Size(double.infinity, 50)),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    if (categories[i]['name'] == 'Admin Dashboard') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(category: categories[i])));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 10)]),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(categories[i]['icon'], size: 40, color: Colors.pink),
                      const SizedBox(height: 10),
                      Text(categories[i]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------- BOOKING SCREEN (WITH EDIT & CALCULATOR) -------------------------
class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> category;
  const BookingScreen({super.key, required this.category});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  bool _afterHours = false;
  bool _agreedToTerms = false;

  double _calculateTotal() {
    double base = double.tryParse(widget.category['price'].replaceAll('R', '')) ?? 0.0;
    return _afterHours ? base + 100 : base;
  }

  void _reviewBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Review Booking"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Client: ${_nameController.text}"),
            Text("Service: ${widget.category['name']}"),
            Text("Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
            Text("Time: ${_selectedTime.format(context)}"),
            Text("Total: R${_calculateTotal()}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Edit")),
          ElevatedButton(onPressed: _confirmAndSend, child: const Text("Confirm & WhatsApp")),
        ],
      ),
    );
  }

  void _confirmAndSend() async {
    String msg = "New Booking: ${widget.category['name']}\nName: ${_nameController.text}\nDate: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}\nTime: ${_selectedTime.format(context)}\nTotal: R${_calculateTotal()}";
    var url = "https://wa.me/27123456789?text=${Uri.encodeComponent(msg)}"; // Replace with your number
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      FirebaseFirestore.instance.collection('bookings').add({
        'clientName': _nameController.text,
        'phone': _phoneController.text,
        'service': widget.category['name'],
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'time': _selectedTime.format(context),
        'status': 'Pending',
        'price': 'R${_calculateTotal()}',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book ${widget.category['name']}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            ListTile(
              title: Text("Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2027));
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            ListTile(
              title: Text("Time: ${_selectedTime.format(context)}"),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                    _afterHours = picked.hour >= 18;
                  });
                }
              },
            ),
            CheckboxListTile(
              title: const Text("I agree to the R100 deposit & policies"),
              value: _agreedToTerms,
              onChanged: (v) => setState(() => _agreedToTerms = v!),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL DUE:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("R${_calculateTotal()}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _agreedToTerms ? _reviewBooking : null,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("REVIEW BOOKING"),
            )
          ],
        ),
      ),
    );
  }
}

// ------------------------- ADMIN DASHBOARD (SEARCH + EARNINGS + CALL) -------------------------
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _searchQuery = "";

  void _callClient(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: "Search name...", fillColor: Colors.white, filled: true, prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          var docs = snapshot.data!.docs.where((d) => d['clientName'].toString().toLowerCase().contains(_searchQuery)).toList();
          double totalPaid = 0;
          for (var d in docs) {
            if (d['status'] == 'Paid') totalPaid += double.tryParse(d['price'].toString().replaceAll('R', '')) ?? 0;
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.pink[700],
                child: Text("TOTAL PAID TODAY: R$totalPaid", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    var data = docs[i].data() as Map<String, dynamic>;
                    Color statusColor = data['status'] == 'Paid' ? Colors.green : (data['status'] == 'Pending' ? Colors.blue : Colors.orange);
                    
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: statusColor, radius: 5),
                        title: Text(data['clientName']),
                        subtitle: Text("${data['service']} | ${data['date']} @ ${data['time']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.phone, color: Colors.green), onPressed: () => _callClient(data['phone'])),
                            PopupMenuButton(
                              onSelected: (val) => docs[i].reference.update({'status': val}),
                              itemBuilder: (_) => [
                                const PopupMenuItem(value: 'Pending', child: Text("Set Pending")),
                                const PopupMenuItem(value: 'Approved', child: Text("Set Approved")),
                                const PopupMenuItem(value: 'Paid', child: Text("Set Paid")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
