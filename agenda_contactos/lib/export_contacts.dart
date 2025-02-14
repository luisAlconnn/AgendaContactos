import 'dart:convert';
import 'dart:io' show File; // Solo para los duros en móvil/desktop 📱💻
import 'dart:html' as html; // Para los que andan webeando 🌍
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'contactos.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportContacts {
  Future<void> exportContactsToCSV(List<Contact> contactosBellacos) async {
    try {
      // 🎤 Vamos a romper con estos datos 🔥
      List<List<String>> datosCSV = [
        ["ID", "Nombre", "Teléfono", "Foto URL"], // Encabezados con flow 💎
        ...contactosBellacos.map((contacto) => [
          contacto.id,
          contacto.name,
          contacto.phone,
          contacto.photoUrl,
        ]),
      ];

      // Transformamos el mambo a formato CSV 🕺
      String csvFinal = const ListToCsvConverter().convert(datosCSV);

      if (kIsWeb) {
        // 🌍 Para la web: Se descarga solo como si fuera un hit mundial 🎶
        final bytes = utf8.encode(csvFinal);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final ancla = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'contactos_bellacos.csv'
          ..click();
        html.Url.revokeObjectUrl(url);
        print("🔥 CSV descargado como hit viral en el navegadoorrr 🔥");
      } else {
        // 📱 Para móvil o desktop: Lo guardamos pa' la historia 📂
        final directorio = await getApplicationDocumentsDirectory();
        final rutaArchivo = "${directorio.path}/contactos_bellacos.csv";
        final archivo = File(rutaArchivo);

        await archivo.writeAsString(csvFinal);
        print("✅ Archivo CSV guardado con flow en: $rutaArchivo");
      }
    } catch (e) {
      print("💀 Error al exportar los contactos: $e. No salió como queríamos, pero seguimos bellacos. 💀");
    }
  }
}
