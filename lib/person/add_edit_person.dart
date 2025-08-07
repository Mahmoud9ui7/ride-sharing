import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practise/Screens/componets/constants.dart';

class AddEditPerson extends StatefulWidget {
  final String? personId;
  final Map<String, dynamic>? data;

  const AddEditPerson({super.key, this.personId, this.data});

  @override
  State<AddEditPerson> createState() => _AddEditPersonState();
}

class _AddEditPersonState extends State<AddEditPerson> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      nameController.text = widget.data!['name'];
      ageController.text = widget.data!['age'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.personId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "تعديل شخص" : "إضافة شخص"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "الاسم"),
                    validator: (value) =>
                        value!.isEmpty ? "الرجاء إدخال الاسم" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: "العمر"),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "الرجاء إدخال العمر" : null,
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              final person = {
                                "name": nameController.text.trim(),
                                "age": int.parse(ageController.text.trim())
                              };

                              final personsRef = FirebaseFirestore.instance
                                  .collection('persons');

                              if (isEdit) {
                                await personsRef
                                    .doc(widget.personId)
                                    .update(person);
                              } else {
                                await personsRef.add(person);
                              }

                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              }
                            }
                          },
                          icon: Icon(isEdit ? Icons.edit : Icons.add),
                          label: Text(
                            isEdit ? "تعديل" : "إضافة",
                            style: TextStyle(color: TextColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            iconColor: TextColor,
                            backgroundColor: primaryColor,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
