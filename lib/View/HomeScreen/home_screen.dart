import 'package:donorlist/View/AddDonorScreen/add_donor_screen.dart';
import 'package:donorlist/View/UpdateDonorScreen/update_donor_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');
  
  void deleteDonor(id){
    donor.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body:
            homePageBody() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  homePageBody() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              addButton(),
              SizedBox(
                height: 20,
              ),
              donorsList()
            ],
          ),
        ),
      ),
    );
  }

  title() {
    return Expanded(
      flex: 2,
      child: Center(
          child: Text(
        'Hi, \nCheckout The Blood Donors Details Here.',
        style: GoogleFonts.comfortaa(
            textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.purple)),
      )),
    );
  }

  donorsList() {
    return Expanded(
      flex: 6,
      child: StreamBuilder(
          stream: donor.orderBy('name').snapshots(),
          builder: (context,  AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot donorSnap = snapshot.data.docs[index];
                    return donorCard(donorSnap['group'], donorSnap['phone'], donorSnap['name'],donorSnap);
                  });
            } else {
              return Container(
                child: Text('No Data'),
              );
            }
          }),
    );
  }

  donorCard(String bloodGroup, String phoneNumber, String name, DocumentSnapshot<Object?> donorSnap) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(bloodGroup,
              style: GoogleFonts
                  .comfortaa()), // Displaying first letter of the name
        ),
        title: Text(
          name,
          style: GoogleFonts.comfortaa(),
        ),
        subtitle: Text(phoneNumber, style: GoogleFonts.comfortaa()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Get.off(UpdateDonorScreen(),arguments: {
                  'name': donorSnap['name'],
                  'phone': donorSnap['phone'],
                  'group': donorSnap['group'],
                  'id': donorSnap.id
                });
                // Add edit functionality here
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteDonor(donorSnap.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  addButton() {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () => Get.offAll(const DonorAddScreen()),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 1),
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple.shade100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle,
                color: Colors.purple,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Add A New Donor',
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontSize: 23, color: Colors.purple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
