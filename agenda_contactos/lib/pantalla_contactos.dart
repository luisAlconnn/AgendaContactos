import 'package:flutter/material.dart';
import 'contactos.dart';
import 'contactos_form.dart';
import 'realtime_database_service.dart';
import 'export_contacts.dart';

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
  final ExportContacts exportContacts = ExportContacts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // 🖤 Fondo oscuro, perreo intenso
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent, // 💖 Puro brillo y flow
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () async {
              final contacts = await databaseService.getContacts().first;
              exportContacts.exportContactsToCSV(contacts);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📂 Contactos exportados con éxito')),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '🔍 Busca tu contacto',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
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
            return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                '🚫 No tienes contactos guardados.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          final contacts = snapshot.data!
              .where((contact) => contact.name.toLowerCase().contains(searchQuery) ||
              contact.phone.toLowerCase().contains(searchQuery))
              .toList();

          if (contacts.isEmpty) {
            return const Center(
              child: Text(
                '😞 No hay contactos que coincidan.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                color: Colors.pinkAccent.withOpacity(0.2), // 💖 Tarjetas con flow
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: contact.photoUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(contact.photoUrl, width: 50, height: 50, fit: BoxFit.cover),
                  )
                      : const Icon(Icons.person, size: 50, color: Colors.white70),
                  title: Text(contact.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(contact.phone, style: const TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      databaseService.deleteContact(contact.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('🗑️ ${contact.name} eliminado')),
                      );
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
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
