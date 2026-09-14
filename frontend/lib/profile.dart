import 'package:flutter/material.dart';

// Halaman profil murni tampilan - tidak ada tombol, tidak ada aksi apapun.
// Semua teks di sini statis (hardcoded), bukan dari data sungguhan.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _forest = Color(0xFF24463B);
  static const _cream = Color(0xFFFAF8F5);
  static const _ink = Color(0xFF1C1C1C);
  static const _muted = Color(0xFF6B6B6B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Avatar langsung tampil tanpa banner di belakangnya
              const CircleAvatar(
                radius: 44,
                backgroundColor: Color(0xFFE4DED3),
                child: Icon(Icons.person, size: 44, color: _muted),
              ),

              const SizedBox(height: 20),

              const Text(
                'User',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Penulis Blog',
                style: TextStyle(fontSize: 13, color: _muted),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Suka menulis tentang teknologi, buku, dan hal-hal kecil yang layak diceritakan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: _muted, height: 1.5),
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Divider(color: Colors.grey.shade300, thickness: 1),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}