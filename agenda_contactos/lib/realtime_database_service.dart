import 'package:firebase_database/firebase_database.dart';
import 'contactos.dart';

class RealtimeDatabaseService {
  final DatabaseReference contactsRef = FirebaseDatabase.instance.refFromURL('https://agendacontactos-daf80-default-rtdb.europe-west1.firebasedatabase.app').child('contacts');

  get databaseReference => null;

  Future<void> addContact(Contact contact) {
    return contactsRef.child(contact.id).set(contact.toMap());
  }

  Future<void> updateContact(Contact contact) {
    return contactsRef.child(contact.id).update(contact.toMap());
  }

  Future<void> deleteContact(String id) {
    return contactsRef.child(id).remove();
  }
  // Método para obtener todos los contactos
  Future<List<Contact>> getAllContacts() async {
    final snapshot = await databaseReference.once(); // Reemplaza con tu lógica de Firebase
    return snapshot.children.map((e) => Contact.fromMap(e.value as Map<String, dynamic>)).toList();
  }

  Stream<List<Contact>> getContacts() {
    return contactsRef.onValue.map((event) {
      final contactsMap = event.snapshot.value as Map<dynamic, dynamic>;
      final contactsList = contactsMap.entries.map((entry) {
        return Contact.fromMap(Map<String, dynamic>.from(entry.value));
      }).toList();
      return contactsList;
    });
  }
}