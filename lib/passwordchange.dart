import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordValid = true;

  void _checkPasswords() {
    setState(() {
      _isPasswordValid =
          _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Şifre Değiştir",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
          ).copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTextField(
              controller: _oldPasswordController,
              labelText: "Eski Şifre",
              obscureText: true,
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _newPasswordController,
              labelText: "Yeni Şifre",
              obscureText: true,
              onChanged: (value) => _checkPasswords(),
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _confirmPasswordController,
              labelText: "Yeni Şifreyi Tekrar Girin",
              obscureText: true,
              onChanged: (value) => _checkPasswords(),
            ),
            SizedBox(height: 10),
            if (!_isPasswordValid)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Yeni şifreler eşleşmiyor!",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_oldPasswordController.text.isNotEmpty &&
                    _newPasswordController.text.isNotEmpty &&
                    _confirmPasswordController.text.isNotEmpty &&
                    _isPasswordValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Şifreniz başarıyla değiştirildi.")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Lütfen tüm alanları doğru doldurun."),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                "Şifreyi Değiştir",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: "Lütfen şifrenizi girin",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.green),
      ),
      onChanged: onChanged,
    );
  }
}
