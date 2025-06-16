// ignore_for_file: prefer_const_literals_to_create_immutables
// import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_courses/edit.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List data = [];
  bool loding = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where(
          "id",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        ) //لعرض فقط المبيانات التي باسم حساب او الايدي
        .get();
    loding = false;
    data.addAll(querySnapshot.docs);

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              Navigator.pushNamedAndRemoveUntil(
                context,
                'login',
                (route) => false,
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: loding == true
          ? Center(child: CircularProgressIndicator.adaptive())
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 200,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: "حذف الحساب",
                      desc: "هل انت متاكد من حذف ؟",
                      btnCancelText: 'حذف',
                      btnOkText: 'تعديل',
                      btnOkOnPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditCategory(
                              docid: data[index].id,
                              oldname: data[index]['name'],
                            ),
                          ),
                        );
                      },
                      btnCancelOnPress: () {
                        FirebaseFirestore.instance
                            .collection("categories")
                            .doc(data[index].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("homepage");
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(15),

                      child: Column(
                        children: [
                          Image.asset("images/folder.png", height: 130),

                          Text("${data[index]['name']}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
