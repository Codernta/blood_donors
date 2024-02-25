import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorlist/View/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DonorAddScreen extends StatefulWidget {
  const DonorAddScreen({super.key});

  @override
  State<DonorAddScreen> createState() => _DonorAddScreenState();
}

class _DonorAddScreenState extends State<DonorAddScreen> {
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  String selectedBloodGroup = 'A+';

   addDonor() {
    final data = {'name': nameController.text, 'phone': phoneNumberController.text, 'group': selectedBloodGroup};
    donor.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(MyHomePage());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.offAll(MyHomePage()),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.purple,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Add A New Donor',
            style: GoogleFonts.comfortaa(
                textStyle: const TextStyle(fontSize: 23, color: Colors.purple)),
          ),
        ),
        body: donorAddBody(),
      ),
    );
  }

  donorAddBody() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          textFields(),
          const SizedBox(
            height: 50,
          ),
          addButton()
        ],
      ),
    );
  }

  textFields() {
    return Expanded(
      flex: 3,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedBloodGroup,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBloodGroup = newValue!;
                  });
                },
                items:
                    bloodGroups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Blood Group',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addButton() {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {addDonor();Get.off(MyHomePage());},
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple.shade100),
            child: Center(
              child: Text(
                'Submit',
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontSize: 23, color: Colors.purple)),
              ),
            )),
      ),
    );
  }
}
