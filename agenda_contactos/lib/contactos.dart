class Contact {
  String id;
  String name;
  String phone;
  String photoUrl;

  Contact({required this.id, required this.name, required this.phone, required this.photoUrl});

  // Crear un mapa para insertar los datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }

  // Convertir un mapa a un contacto
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
    );
  }
}