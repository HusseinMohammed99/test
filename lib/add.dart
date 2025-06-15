import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_courses/components/coustemtextfild.dart';
import 'package:flutter_courses/components/custombuttonauth.dart';

TextEditingController name = TextEditingController();
CollectionReference categories = FirebaseFirestore.instance.collection(
  'categories',
);

Addcategory(BuildContext context) async {
  DocumentReference respos = await categories.add({"name": name.text});
  Navigator.of(context).pushReplacementNamed("homepage");
}

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formestat = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add category")),
      body: Form(
        key: formestat,
        child: Column(
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
              title: "Add",
              onPressed: () {
                Addcategory(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
