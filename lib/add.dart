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
// Addcategory() async {
//   lood = true;
//   if (formState.currentState!.validate()) {
//     try {
//       lood = true;
//       setState(() {});
//       DocumentReference respos = await categories.add({
//         "name": name.text,
//         "id": FirebaseAuth.instance.currentUser!.uid,
//       });
//       Navigator.of(
//         context,
//       ).pushNamedAndRemoveUntil("homepage", (route) => false);
//     } catch (e) {
//       print("Error$e");
//     }
//   }
// }

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  addcategory() async {
    if (formState.currentState!.validate()) {
      try {
        lood = true;
        setState(() {});
        DocumentReference response = await categories.add({
          "name": name.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        });
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
                    title: "Add",
                    onPressed: () {
                      addcategory();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
