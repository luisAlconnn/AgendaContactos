import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'contactos.dart';
import 'realtime_database_service.dart';
import 'dart:io';

class ContactForm extends StatefulWidget {
  final Contact? contact;

  const ContactForm({Key? key, this.contact}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _photoUrl;
  File? _imageFile;

  final RealtimeDatabaseService databaseService = RealtimeDatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _photoUrl = widget.contact!.photoUrl;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance.ref().child('contact_photos/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() => {});
      _photoUrl = await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('Error: ${e.message}');
    }
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        await _uploadImage();
      }

      final newContact = Contact(
        id: widget.contact?.id ?? databaseService.contactsRef.push().key!,
        name: _nameController.text,
        phone: _phoneController.text,
        photoUrl: _photoUrl ?? '',
      );

      if (widget.contact == null) {
        await databaseService.addContact(newContact);
      } else {
        await databaseService.updateContact(newContact);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Add Contact' : 'Edit Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _photoUrl != null
                  ? Image.network(_photoUrl!)
                  : const Text('No image selected'),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveContact,
                child: const Text('Save Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}