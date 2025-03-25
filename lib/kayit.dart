import 'package:bitki_teshis/giris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  _KayitSayfasiState createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _registerWithEmail() async {
    setState(() => _isLoading = true);
    try {
      // Kullanıcıyı Firebase Authentication ile kaydet
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        // Kullanıcı profilini güncelle (displayName ekle)
        await user.updateDisplayName(_usernameController.text.trim());
        await user.reload();
        user = _auth.currentUser; // Güncellenmiş kullanıcıyı tekrar çek

        // Firestore veritabanına kullanıcı bilgilerini kaydet
        await _firestore.collection('users').doc(user?.uid).set({
          'email': user?.email,
          'username': _usernameController.text.trim(),
          'createdAt': Timestamp.now(),
        });
      }

      // Kayıt başarılı olduğunda giriş sayfasına yönlendir
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GirisSayfasi()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Kayıt yapılamadı. Tekrar deneyin.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hata"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Tamam"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Kayıt Ol",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Bitki hastalıklarını daha iyi teşhis etmek ve destek olmak için bize katılın.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  _usernameController,
                  "Kullanıcı Adı",
                  Icons.person,
                  false,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _emailController,
                  "E-posta",
                  Icons.email,
                  false,
                ),
                const SizedBox(height: 15),
                _buildTextField(_passwordController, "Şifre", Icons.lock, true),
                const SizedBox(height: 15),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _registerWithEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Kayıt Ol",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Hesabınız var mı?"),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Giriş Yap"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
