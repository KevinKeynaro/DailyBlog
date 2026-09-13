import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Read-only: categories hanya dikelola manual lewat MySQL Workbench,
// jadi halaman ini cuma menampilkan, tidak ada tambah/edit/hapus.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List categories = [];
  bool isLoading = true;

  Future<void> getCategories() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse("http://localhost:8000/api/categories"),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded['data'] as List;

      setState(() {
        categories = data;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      debugPrint("data categories gagal di ambil");
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getCategories,
              child: categories.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(child: Text('Belum ada kategori')),
                      ],
                    )
                  : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return ListTile(
                          leading: const Icon(Icons.label_outline),
                          title: Text(item['name'] ?? ''),
                        );
                      },
                    ),
            ),
    );
  }
}