import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zuperr/Services/CategoryService/CandidateService.dart';
import 'package:zuperr/Utils/AppConstants.dart';

class CategorySelectorDialog extends StatefulWidget {
  final List<String> selectedCategories;

  const CategorySelectorDialog({super.key, required this.selectedCategories});

  @override
  State<CategorySelectorDialog> createState() => _CategorySelectorDialogState();
}

class _CategorySelectorDialogState extends State<CategorySelectorDialog> {
  final TextEditingController searchController = TextEditingController();

  List<String> allCategories = [];
List<String> filteredCategories = [];
late List<String> selected;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    selected = List.from(widget.selectedCategories);

    loadCategories();
  }
Future<void> loadCategories() async {
  try {
    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/employer/job-categories/unique",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> categories = data["categories"] ?? [];

      allCategories = {
        ...categories.cast<String>(),
        ...widget.selectedCategories,
      }.toList();

      allCategories.sort();

      filteredCategories = List.from(allCategories);
    }
  } catch (e) {
    debugPrint("Error loading categories: $e");
  }

  if (mounted) {
    setState(() {
      loading = false;
    });
  }
}

  void search(String value) {
    setState(() {
      filteredCategories = allCategories.where((category) {
        return category.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
Widget build(BuildContext context) {
  final displayCategories = [
    ...selected,
    ...filteredCategories.where((e) => !selected.contains(e)),
  ];

  return Dialog(
    insetPadding: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * .95,
      height: MediaQuery.of(context).size.height * .90,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Choose Categories",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search Categories...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

    Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: SizedBox(
    height: 80,
    child: SingleChildScrollView(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selected.map((skill) {
            return Chip(
              label: Text(skill),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  selected.remove(skill);
                });
              },
            );
          }).toList(),
        ),
      ),
    ),
  ),
),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Text(
                  "${selected.length}/6 Selected",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  "${displayCategories.length} Categories",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: displayCategories.length,
                    itemBuilder: (context, index) {
                      final category = displayCategories[index];

                      final isSelected =
                          selected.contains(category);

                      final canSelect =
                          isSelected || selected.length < 6;

                      return Card(
                        elevation: 0,
                        margin:
                            const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          controlAffinity:
                              ListTileControlAffinity.leading,
                          title: Text(
                            category,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onChanged: (_) {
                            if (!canSelect) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "You can select only 6 categories"),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              if (isSelected) {
                                selected.remove(category);
                              } else {
                                selected.add(category);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final success =
                        await CandidateService.updateCategories(
                            selected);

                    if (!success) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text("Unable to save"),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context, selected);
                  },
                  child: const Text(
                    "Save Categories",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}}