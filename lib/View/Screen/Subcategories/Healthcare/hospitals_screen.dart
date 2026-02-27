import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final List<Map<String, dynamic>> _allHospitals = [
    {
      'name': 'City General Hospital',
      'address': '123 Main St, Central Taluka',
      'taluka': 'Central',
      'contact': '+91 98765 43210',
      'discount': '10% off on OPD',
      'image': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3',
    },
    {
      'name': 'Sunrise Medical Center',
      'address': '456 West Ave, North Taluka',
      'taluka': 'North',
      'contact': '+91 98765 43211',
      'discount': null,
      'image': 'https://images.unsplash.com/photo-1579684385127-1ef15d508118',
    },
    {
      'name': 'Green Valley Hospital',
      'address': '789 East Rd, South Taluka',
      'taluka': 'South',
      'contact': '+91 98765 43212',
      'discount': '5% off on Lab Tests',
      'image': 'https://images.unsplash.com/photo-1584982751601-97dcc096659c',
    },
  ];

  String _selectedTaluka = 'All';
  late List<String> _talukas;

  @override
  void initState() {
    super.initState();
    final talukaSet = _allHospitals.map((h) => h['taluka'] as String).toSet();
    _talukas = ['All', ...talukaSet];
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hospitals = _selectedTaluka == 'All'
        ? _allHospitals
        : _allHospitals.where((h) => h['taluka'] == _selectedTaluka).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: const Text("Hospitals"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          /// 🔹 FILTER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.filter_alt_outlined, size: 20),
                const SizedBox(width: 8),
                const Text("Taluka",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _selectedTaluka,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _talukas
                        .map((t) =>
                            DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedTaluka = val!),
                  ),
                )
              ],
            ),
          ),

          /// 🔹 LIST
          Expanded(
            child: hospitals.isEmpty
                ? const Center(
                    child: Text("No hospitals found",
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: hospitals.length,
                    itemBuilder: (_, i) => _HospitalCard(
                      data: hospitals[i],
                      onCall: () =>
                          _makePhoneCall(hospitals[i]['contact']),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final Map data;
  final VoidCallback onCall;

  const _HospitalCard({required this.data, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            spreadRadius: -5,
            color: Colors.black.withOpacity(.08),
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ⭐ IMAGE HEADER
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  data['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  /// loading shimmer
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },

                  /// fallback image
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.local_hospital,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),

              /// subtle gradient overlay (premium feel)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.35),
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              const Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: FaIcon(FontAwesomeIcons.hospital,
                      size: 16, color: Colors.red),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(data['address'],
                          style: TextStyle(color: Colors.grey.shade700)),
                    )
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.phone,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(data['contact'],
                        style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),

                if (data['discount'] != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade50,
                          Colors.green.shade100
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      data['discount'],
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCall,
                        icon: const Icon(Icons.call),
                        label: const Text("Call"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red.shade300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "View Details",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}