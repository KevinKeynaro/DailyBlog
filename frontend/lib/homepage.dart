import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'edit_article.dart';
import 'article_detail.dart';
import 'article_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  List articles = [];

  Future<void> getArticles() async {
    final response = await http.get(
      Uri.parse("http://localhost:8000/api/articles"),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded is Map && decoded.containsKey('data')
          ? decoded['data']
          : decoded;

      setState(() {
        articles = data is List ? data : [];
      });
    } else {
      debugPrint("data gagal di ambil");
    }
  }

  Future<void> deleteArticle(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8000/api/articles/$id'),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Artikel Berhasil Dihapus: ${response.statusCode}'),
        ),
      );

      setState(() {
        articles.removeWhere((article) => article['id'] == id);
      });
    } else {
      debugPrint('Gagal menghapus artikel: ${response.statusCode}');
    }
  }

  Future<void> goToDetail(Map item) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticleDetailPage(article: item)),
    );
    if (updated == true) getArticles();
  }

  Future<void> goToEdit(Map item) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditArticlePage(article: item)),
    );
    if (updated == true) getArticles();
  }

  @override
  void initState() {
    super.initState();
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: getArticles,
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final item = articles[index];

            return ArticleCard(
              category: item["category"] ?? '-',
              title: item["title"] ?? '',
              content: item["content"] ?? '',
              onTap: () => goToDetail(item),
              onEdit: () => goToEdit(item),
              onDelete: () => deleteArticle(item['id']),
            );
          },
        ),
      ),
    );
  }
}
