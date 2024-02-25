import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorlist/View/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateDonorScreen extends StatefulWidget {
  const UpdateDonorScreen({super.key});

  @override
  State<UpdateDonorScreen> createState() => _UpdateDonorScreenState();
}

class _UpdateDonorScreenState extends State<UpdateDonorScreen> {
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

  updateDonor(docId){
    final data = {
      'name': nameController.text,
      'phone': phoneNumberController.text,
      'group': selectedBloodGroup
    };
    donor.doc(docId).update(data).then((value) => Get.off(MyHomePage()));
  }


  @override
  Widget build(BuildContext context) {
    Map data = (Get.arguments) as Map<String, dynamic>;
    nameController.text = data['name'];
    phoneNumberController.text = data['phone'];
    selectedBloodGroup = data['group'];
    final docId = data['id'];
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
            'Update Donor',
            style: GoogleFonts.comfortaa(
                textStyle: const TextStyle(fontSize: 23, color: Colors.purple)),
          ),
        ),
        body: donorAddBody(data,docId),
      ),
    );
  }

  donorAddBody(Map data, docId) {
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
          addButton(data,docId)
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

  addButton(Map data, docId) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          updateDonor(docId);
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple.shade100),
            child: Center(
              child: Text(
                'Update',
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontSize: 23, color: Colors.purple)),
              ),
            )),
      ),
    );
  }
}
