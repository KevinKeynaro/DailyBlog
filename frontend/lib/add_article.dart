import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddArticlePage extends StatefulWidget {
  final VoidCallback? onArticleAdded;

  const AddArticlePage({super.key, this.onArticleAdded});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  List<Map<String, dynamic>> categories = [];
  int? selectedCategoryId;
  bool isLoadingCategories = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/categories'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'] as List;

        setState(() {
          categories = data.cast<Map<String, dynamic>>();
          isLoadingCategories = false;
        });
      } else {
        setState(() => isLoadingCategories = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingCategories = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat kategori: $e')));
    }
  }

  Future<void> addArticle() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty || selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi, termasuk kategori'),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/articles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'category_id': selectedCategoryId,
      }),
    );

    if (!mounted) return;

    setState(() => isSaving = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menyimpan artikel')),
      );

      titleController.clear();
      contentController.clear();
      setState(() => selectedCategoryId = null);
      widget.onArticleAdded?.call();
    } else {
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            body['message'] ??
                'Gagal menyimpan artikel: ${response.statusCode}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Article title',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Content',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
            ),
            const SizedBox(height: 16),
            isLoadingCategories
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonFormField<int>(
                      initialValue: selectedCategoryId,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Category',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      hint: const Text('Pilih kategori'),
                      items: categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category['id'] as int,
                          child: Text(category['name'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedCategoryId = value);
                      },
                    ),
                  ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : addArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C6EF5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
