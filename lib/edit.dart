import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_courses/components/coustemtextfild.dart';
import 'package:flutter_courses/components/custombuttonauth.dart';

TextEditingController name = TextEditingController();
CollectionReference categories = FirebaseFirestore.instance.collection(
  'categories',
);
bool lood = false;

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  editCategory() async {
    if (formState.currentState!.validate()) {
      try {
        lood = true;
        setState(() {});
        await categories.doc(widget.docid).update({"name": name.text});
        lood = false;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil("homepage", (route) => false);
      } catch (e) {
        print("Error$e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add category")),
      body: Form(
        key: formState,
        child: lood
            ? Center(child: Text("Loding.........."))
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: CustomTextFormAdd(
                      validator: (val) {
                        if (val == "") {
                          return "Your name can't be empte";
                        }
                        return null;
                      },
                      hinttext: "enter name",
                      mycontroller: name,
                    ),
                  ),
                  CustomButtonAuth(
                    title: "Save",
                    onPressed: () {
                      editCategory();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
