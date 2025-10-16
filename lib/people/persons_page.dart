import 'package:flutter/material.dart';
import 'package:practise/people/person.dart';
import 'persons_api.dart';

class PersonsPage extends StatefulWidget {
  const PersonsPage({super.key});

  @override
  State<PersonsPage> createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  final ValueNotifier<List<Person>> _people = ValueNotifier([]);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchNextPage();
  }

  Future<void> _fetchNextPage() async {
    if (!_hasMore) return;
    _loading.value = true;
    try {
      final list = await PersonsApi.getAll(pageNumber: _currentPage, pageSize: _pageSize);
      if (list.isEmpty || list.length < _pageSize) {
        _hasMore = false;
      }
      _people.value = [..._people.value, ...list];
      _currentPage++;
    } catch (e) {
      _showMessage('حدث خطأ أثناء جلب الأشخاص: $e', isError: true);
    } finally {
      _loading.value = false;
    }
  }

  void _showMessage(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _deletePerson(Person p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف ${p.fullName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await PersonsApi.delete(p.personID);
    if (success) {
      _people.value = _people.value.where((e) => e.personID != p.personID).toList();
      _showMessage('تم حذف ${p.fullName}');
    } else {
      _showMessage('فشل الحذف', isError: true);
    }
  }

  Future<void> _editPerson(Person p) async {
    final edited = await showModalBottomSheet<Person>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PersonFormSheet(person: p),
    );
    if (edited != null) {
      final updated = await PersonsApi.update(p.personID, edited);
      if (updated != null) {
        int index = _people.value.indexWhere((e) => e.personID == p.personID);
        if (index != -1) {
          _people.value[index] = updated;
          // _people.notifyListeners();
        }
        _showMessage('تم تعديل ${p.fullName}');
      } else {
        _showMessage('فشل التعديل', isError: true);
      }
    }
  }

  Widget _buildCard(Person p) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: p.imagePath.isNotEmpty
                  ? NetworkImage(p.imagePath)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(p.email, style:   TextStyle(color: Colors.grey[700])),
                  Text(p.phone, style:   TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editPerson(p)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deletePerson(p)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل الأشخاص')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<Person>>(
                valueListenable: _people,
                builder: (context, list, _) {
                  if (list.isEmpty) return const Center(child: Text('لا يوجد بيانات'));
                  return ListView.builder(
                    itemCount: list.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= list.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: ElevatedButton(onPressed: _fetchNextPage, child: const Text('عرض المزيد')),
                          ),
                        );
                      }
                      return _buildCard(list[index]);
                    },
                  );
                },
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _loading,
              builder: (_, loading, __) =>
                  loading ? const LinearProgressIndicator(minHeight: 3) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newPerson = await showModalBottomSheet<Person>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const _PersonFormSheet(),
          );
          if (newPerson != null) {
            final created = await PersonsApi.create(newPerson);
            if (created != null) {
              _people.value = [created, ..._people.value];
              _showMessage('تم إضافة ${created.fullName}');
            } else {
              _showMessage('فشل الإضافة', isError: true);
            }
          }
        },
      ),
    );
  }
}

// ===================== نموذج إضافة/تعديل شخص =====================
class _PersonFormSheet extends StatefulWidget {
  final Person? person;
  const _PersonFormSheet({this.person});

  @override
  State<_PersonFormSheet> createState() => _PersonFormSheetState();
}

class _PersonFormSheetState extends State<_PersonFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _secondNameController;
  late TextEditingController _thirdNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.person?.firstName ?? '');
    _secondNameController = TextEditingController(text: widget.person?.secondName ?? '');
    _thirdNameController = TextEditingController(text: widget.person?.thirdName ?? '');
    _lastNameController = TextEditingController(text: widget.person?.lastName ?? '');
    _phoneController = TextEditingController(text: widget.person?.phone ?? '');
    _emailController = TextEditingController(text: widget.person?.email ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.person == null ? 'إضافة شخص جديد' : 'تعديل بيانات الشخص',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'الاسم الأول'),
                validator: (v) => v!.isEmpty ? 'الرجاء إدخال الاسم الأول' : null,
              ),
              TextFormField(
                controller: _secondNameController,
                decoration: const InputDecoration(labelText: 'الاسم الثاني'),
              ),
              TextFormField(
                controller: _thirdNameController,
                decoration: const InputDecoration(labelText: 'الاسم الثالث'),
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'اسم العائلة'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'الهاتف'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(
                        context,
                        Person(
                          personID: widget.person?.personID ?? -1,
                          firstName: _firstNameController.text,
                          secondName: _secondNameController.text,
                          thirdName: _thirdNameController.text,
                          lastName: _lastNameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                        ));
                  }
                },
                child: const Text('حفظ'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
