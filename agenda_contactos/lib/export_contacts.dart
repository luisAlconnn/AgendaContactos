import 'dart:convert';
import 'dart:io' show File; // Usar solo en plataformas móviles/desktop
import 'dart:html' as html; // Usar en web
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'contactos.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportContacts {
  Future<void> exportContactsToCSV(List<Contact> contacts) async {
    try {
      // Crear encabezados y filas con los datos
      List<List<String>> data = [
        ["ID", "Name", "Phone", "Photo URL"], // Encabezados
        ...contacts.map((contact) => [
          contact.id,
          contact.name,
          contact.phone,
          contact.photoUrl,
        ]),
      ];

      // Convertir los datos a formato CSV
      String csvData = const ListToCsvConverter().convert(data);

      if (kIsWeb) {
        // Para la web: Descarga el archivo CSV en el navegador
        final bytes = utf8.encode(csvData);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'contacts.csv'
          ..click();
        html.Url.revokeObjectUrl(url);
        print("Archivo CSV descargado en el navegador.");
      } else {
        // Para plataformas móviles o desktop: Guardar en documentos
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/contacts.csv";
        final file = File(path);

        await file.writeAsString(csvData);
        print("Archivo CSV guardado en: $path");
      }
    } catch (e) {
      print("Error al exportar los contactos: $e");
    }
  }
}
