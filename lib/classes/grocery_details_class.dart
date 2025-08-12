class GroceryItem {
  final String id;
  final String name;
  final bool purchased;
  final DateTime? purchasedDate;

  GroceryItem({
    required this.id,
    required this.name,
    this.purchased = false,
    this.purchasedDate,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    bool? purchased,
    DateTime? purchasedDate,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      purchased: purchased ?? this.purchased,
      purchasedDate: purchasedDate ?? this.purchasedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'purchased': purchased,
      'purchasedDate': purchasedDate?.toIso8601String(),
    };
  }

  factory GroceryItem.fromMap(String id, Map<String, dynamic> map) {
    return GroceryItem(
      id: id,
      name: map['name'] ?? '',
      purchased: map['purchased'] ?? false,
      purchasedDate: map['purchasedDate'] != null
          ? DateTime.parse(map['purchasedDate'])
          : null,
    );
  }
}
