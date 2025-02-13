/*
import 'package:firebase_database/firebase_database.dart';
import 'contactos.dart';

class RealtimeDatabaseService {
  final DatabaseReference contactsRef = FirebaseDatabase.instance.ref().child('contacts');

  Future<void> addContact(Contact contact) {
    return contactsRef.child(contact.id).set(contact.toMap());
  }

  Future<void> updateContact(Contact contact) {
    return contactsRef.child(contact.id).update(contact.toMap());
  }

  Future<void> deleteContact(String id) {
    return contactsRef.child(id).remove();
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

 */