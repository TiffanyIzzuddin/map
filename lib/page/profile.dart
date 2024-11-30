import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Import the swipeable package

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Text controllers untuk menangani input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  String? _selectedGender; // Untuk pilihan jenis kelamin

  // Fungsi untuk menyimpan data ke Firestore
  Future<void> _submitData() async {
    if (_nameController.text.isEmpty ||
        _dateOfBirthController.text.isEmpty ||
        _selectedGender == null ||
        _occupationController.text.isEmpty ||
        _educationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon lengkapi semua field')),
      );
      return;
    }

    try {
      // Simpan ke Firestore
      await FirebaseFirestore.instance.collection('users').add({
        'name': _nameController.text,
        'dateOfBirth': _dateOfBirthController.text,
        'gender': _selectedGender,
        'occupation': _occupationController.text,
        'education': _educationController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan')),
      );

      // Reset form setelah berhasil
      _nameController.clear();
      _dateOfBirthController.clear();
      _occupationController.clear();
      _educationController.clear();
      setState(() {
        _selectedGender = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  // Function to fetch data from Firestore
  Stream<QuerySnapshot> _fetchData() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  // Function to delete a document from Firestore
  Future<void> _deleteData(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form to enter user details
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _occupationController,
                decoration: InputDecoration(
                  labelText: 'Pekerjaan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _educationController,
                decoration: InputDecoration(
                  labelText: 'Pendidikan Terakhir',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  child: Text('Submit'),
                ),
              ),
              SizedBox(height: 32),
              // Display saved user profiles
              StreamBuilder<QuerySnapshot>(
                stream: _fetchData(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final data = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    // Make sure ListView is inside a SizedBox to limit its size
                    shrinkWrap:
                        true, // Ensures the ListView doesn't take infinite height
                    physics:
                        NeverScrollableScrollPhysics(), // Prevent scrolling in ListView, it's already scrollable
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      final doc = data[index];
                      final user = doc.data() as Map<String, dynamic>;
                      return Slidable(
                        // Replace 'actionPane' with 'startActionPane' or 'endActionPane'
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => _deleteData(doc.id),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(user['name'] ?? 'No name'),
                          subtitle: Text(
                              'DOB: ${user['dateOfBirth']}, Gender: ${user['gender']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
