import 'package:flutter/material.dart';

// Catatan: search bar di sini murni tampilan (UI mockup).
// Belum ada logic filter/pencarian yang sesungguhnya.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari artikel...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // onChanged/onSubmitted sengaja belum diisi -
              // ini masih tampilan saja sesuai permintaan.
            ),
            const SizedBox(height: 40),
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Text(
              'Fitur pencarian belum aktif',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}