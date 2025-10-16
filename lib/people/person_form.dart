import 'package:flutter/material.dart';
import 'package:practise/people/person.dart';

class PersonFormPage extends StatefulWidget {
  final Person? person;
  const PersonFormPage({this.person, super.key});

  @override
  State<PersonFormPage> createState() => _PersonFormPageState();
}

class _PersonFormPageState extends State<PersonFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _first, _second, _third, _last, _national, _phone, _email, _address;

  @override
  void initState() {
    super.initState();
    final p = widget.person;
    _first = TextEditingController(text: p?.firstName ?? '');
    _second = TextEditingController(text: p?.secondName ?? '');
    _third = TextEditingController(text: p?.thirdName ?? '');
    _last = TextEditingController(text: p?.lastName ?? '');
    _national = TextEditingController(text: p?.nationalNo ?? '');
    _phone = TextEditingController(text: p?.phone ?? '');
    _email = TextEditingController(text: p?.email ?? '');
    _address = TextEditingController(text: p?.address ?? '');
  }

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    _third.dispose();
    _last.dispose();
    _national.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final p = Person(
      personID: widget.person?.personID ?? -1,
      firstName: _first.text,
      secondName: _second.text,
      thirdName: _third.text,
      lastName: _last.text,
      nationalNo: _national.text,
      phone: _phone.text,
      email: _email.text,
      address: _address.text,
    );
    Navigator.pop(context, p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.person == null ? 'إضافة شخص' : 'تعديل شخص')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _first, decoration: const InputDecoration(labelText: 'الاسم الأول'), validator: (v) => v!.isEmpty ? 'مطلوب' : null),
              TextFormField(controller: _second, decoration: const InputDecoration(labelText: 'الاسم الثاني')),
              TextFormField(controller: _third, decoration: const InputDecoration(labelText: 'الاسم الثالث')),
              TextFormField(controller: _last, decoration: const InputDecoration(labelText: 'الاسم الأخير')),
              TextFormField(controller: _national, decoration: const InputDecoration(labelText: 'رقم وطني')),
              TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'الهاتف')),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
              TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'العنوان')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('حفظ')),
            ],
          ),
        ),
      ),
    );
  }
}
