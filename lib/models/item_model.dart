class Item {
  final String id;
  final String name;
  final String category;
  final String price;
  final DateTime date;

  Item ({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.date
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final properties = map['properties'] as Map<String, dynamic>;
    final dateString = properties['Fecha']?['date']?['start'];
    // print(properties['Precio']?['number']); 
    return Item(
      id: id,
      name: properties['Nombre']?['title']?[0]?['plain_text'] ?? '?', 
      category: properties['Categorías']?['select']?['name'] ?? '?', 
      price: properties['Precio']?['number'].toString() ?? '0', 
      date: dateString != null ? DateTime.parse(dateString) : DateTime.now(),
    );
  }
}