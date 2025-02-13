import 'package:flutter/material.dart';
import 'contactos.dart';
import 'contactos_form.dart';
import 'realtime_database_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RealtimeDatabaseService databaseService = RealtimeDatabaseService();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Contact>>(
        stream: databaseService.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts added.'));
          }

          final contacts = snapshot.data!
              .where((contact) => contact.name.toLowerCase().contains(searchQuery) ||
              contact.phone.toLowerCase().contains(searchQuery))
              .toList();

          if (contacts.isEmpty) {
            return const Center(child: Text('No matching contacts found.'));
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                child: ListTile(
                  leading: contact.photoUrl.isNotEmpty
                      ? Image.network(contact.photoUrl)
                      : const Icon(Icons.person),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      databaseService.deleteContact(contact.id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactForm(contact: contact),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
