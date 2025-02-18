import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'contactos.dart';

class RealtimeDatabaseService {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.refFromURL(
      'https://agendacontactos-daf80-default-rtdb.europe-west1.firebasedatabase.app');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para obtener el UID del usuario autenticado
  String? _getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid;
  }

  // Referencia a los contactos del usuario actual
  DatabaseReference? _getUserContactsRef() {
    final userId = _getCurrentUserId();
    if (userId == null) return null;
    return databaseRef.child('users/$userId/contacts');
  }

  // Agregar un contacto
  Future<void> addContact(Contact contact) async {
    final userContactsRef = _getUserContactsRef();
    if (userContactsRef == null) {
      throw Exception("Usuario no autenticado.");
    }

    await userContactsRef.child(contact.id).set(contact.toMap());
  }

  // Actualizar un contacto existente
  Future<void> updateContact(Contact contact) async {
    final userContactsRef = _getUserContactsRef();
    if (userContactsRef == null) {
      throw Exception("Usuario no autenticado.");
    }

    await userContactsRef.child(contact.id).update(contact.toMap());
  }

  // Eliminar un contacto
  Future<void> deleteContact(String id) async {
    final userContactsRef = _getUserContactsRef();
    if (userContactsRef == null) {
      throw Exception("Usuario no autenticado.");
    }

    await userContactsRef.child(id).remove();
  }

  // Obtener todos los contactos como lista
  Future<List<Contact>> getAllContacts() async {
    final userContactsRef = _getUserContactsRef();
    if (userContactsRef == null) {
      throw Exception("Usuario no autenticado.");
    }

    final snapshot = await userContactsRef.get();
    if (snapshot.exists) {
      final contactsMap = snapshot.value as Map<dynamic, dynamic>;
      return contactsMap.entries.map((entry) {
        return Contact.fromMap(Map<String, dynamic>.from(entry.value));
      }).toList();
    } else {
      return [];
    }
  }

  // Stream de contactos (para cambios en tiempo real)
  Stream<List<Contact>> getContacts() {
    final userContactsRef = _getUserContactsRef();
    if (userContactsRef == null) {
      return const Stream.empty(); // Si no hay usuario autenticado, retorna un Stream vacío
    }

    return userContactsRef.onValue.map((event) {
      final contactsMap = event.snapshot.value as Map<dynamic, dynamic>?;
      if (contactsMap == null) return [];
      return contactsMap.entries.map((entry) {
        return Contact.fromMap(Map<String, dynamic>.from(entry.value));
      }).toList();
    });
  }

  // Obtener contactos una vez (para exportar)
  Future<List<Contact>> getContactsOnce() async {
    final userContactsRef = _getUserContactsRef();
    if (userContactsRef == null) {
      throw Exception("Usuario no autenticado.");
    }

    final snapshot = await userContactsRef.get();
    if (snapshot.exists) {
      final contactsMap = snapshot.value as Map<dynamic, dynamic>;
      return contactsMap.entries.map((entry) {
        return Contact.fromMap(Map<String, dynamic>.from(entry.value));
      }).toList();
    } else {
      return [];
    }
  }
}
