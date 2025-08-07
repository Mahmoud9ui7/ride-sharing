import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practise/Screens/componets/constants.dart';

import 'add_edit_person.dart';

class peopleScreen extends StatelessWidget {
  const peopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final personsRef = FirebaseFirestore.instance.collection('persons');

    return Scaffold(
      appBar: AppBar(
        title: const Text("الأشخاص"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: personsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("حدث خطأ"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final persons = snapshot.data!.docs;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  final person = persons[index];
                  return GestureDetector(
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text("تعديل"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEditPerson(
                                      personId: person.id,
                                      data:
                                          person.data() as Map<String, dynamic>,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading:
                                  const Icon(Icons.delete, color: Colors.red),
                              title: const Text("حذف"),
                              onTap: () async {
                                // إغلاق BottomSheet
                                Navigator.pop(context);

                                // إظهار مؤشر التحميل
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                      child: CircularProgressIndicator()),
                                );

                                // تنفيذ عملية الحذف
                                await personsRef.doc(person.id).delete();

                                // إغلاق Dialog التحميل بعد الحذف
                                if (context.mounted) Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(person['name']),
                        subtitle: Text("العمر: ${person['age']}"),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditPerson()),
        ),
        child: const Icon(
          Icons.add,
          color: TextColor,
        ),
      ),
    );
  }
}
