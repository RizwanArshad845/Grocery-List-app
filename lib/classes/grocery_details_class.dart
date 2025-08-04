import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//The grocery Item will be displayed by these features wrapped in a card
class GroceryItem {
  final String id;
  final String name;
  final bool purchased;

  GroceryItem({required this.id, required this.name, this.purchased = false});

  GroceryItem copyWith({String? name, bool? purchased}) {
    return GroceryItem(
      id: this.id,
      name: name ?? this.name,
      purchased: purchased ?? this.purchased,
    );
  }
}
