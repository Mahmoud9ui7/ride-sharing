import 'package:flutter/material.dart';
import 'package:practise/people/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PersonCard({required this.person, this.onEdit, this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(person.fullName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم وطني: ${person.nationalNo}'),
            Text('الهاتف: ${person.phone}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
