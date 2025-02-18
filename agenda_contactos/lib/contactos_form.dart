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

  // 🔥 Función para escoger la imagen con flow 🔥
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      print("📸 Imagen lista pa'l contacto.");
    }
  }

  // 🚀 Subir imagen a la nube, como un reggaetón pegajoso 🚀
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      print("🔥 Subiendo imagen, ponte ready...");
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('contact_photos/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() => {});
      _photoUrl = await snapshot.ref.getDownloadURL();
      print("✅ Imagen subida con éxito!");
    } on FirebaseException catch (e) {
      print('❌ Error al subir imagen: ${e.message}');
    }
  }

  // 🎤 Guardar contacto con todo el flow 🎤
  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        await _uploadImage();
      }

      final newContact = Contact(
        id: widget.contact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        photoUrl: _photoUrl ?? '',
      );

      try {
        if (widget.contact == null) {
          await databaseService.addContact(newContact);
          print("🎉 Nuevo contacto guardado en la playlist.");
        } else {
          await databaseService.updateContact(newContact);
          print("🔄 Contacto actualizado con flow.");
        }

        Navigator.pop(context);
      } catch (e) {
        print("❌ Error al guardar el contacto: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // 🖤 Fondo oscuro, puro perreo
      appBar: AppBar(
        title: Text(
          widget.contact == null ? '🚀 Nuevo Contacto' : '✍️ Editar Contacto',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent, // 💖 Puro brillo y flow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: '👤 Nombre',
                  labelStyle: const TextStyle(color: Colors.pinkAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.pinkAccent),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? '⚠️ Ingresa un nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: '📞 Teléfono',
                  labelStyle: const TextStyle(color: Colors.pinkAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.pinkAccent),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? '⚠️ Ingresa un número' : null,
              ),
              const SizedBox(height: 16),

              // 🖼️ Imagen con estilo
              _photoUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(_photoUrl!, width: 100, height: 100, fit: BoxFit.cover),
              )
                  : const Text('🚫 No hay imagen seleccionada', style: TextStyle(color: Colors.white)),

              const SizedBox(height: 16),

              // 🎨 Botón para escoger imagen con estilo 🔥
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text('📸 Escoger Imagen', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              // 💾 Botón de guardar bien bellaco
              ElevatedButton.icon(
                onPressed: _saveContact,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('💾 Guardar Contacto', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
