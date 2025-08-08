import 'package:flutter/material.dart';

class SearchHandler<T> {
  final ValueNotifier<List<T>> filteredItemsNotifier;
  final List<T> allItems;
  final String Function(T) filterProperty;

  SearchHandler({required this.allItems, required this.filterProperty})
    : filteredItemsNotifier = ValueNotifier<List<T>>(allItems);

  void filter(String query) {
    final lowercaseQuery = query.toLowerCase();
    filteredItemsNotifier.value =
        allItems
            .where(
              (item) =>
                  filterProperty(item).toLowerCase().contains(lowercaseQuery),
            )
            .toList();
  }

  void reset() {
    filteredItemsNotifier.value = allItems;
  }

  void dispose() {
    filteredItemsNotifier.dispose();
  }
}

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;

  const SearchWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
