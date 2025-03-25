import 'package:bitki_teshis/passwordchange.dart';
import 'package:flutter/material.dart';
import 'package:bitki_teshis/profil.dart';
import 'main.dart'; // themeNotifier'ı kullanabilmek için

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = "Türkçe"; // Varsayılan dil

  void _showLanguageSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Dil Seçimi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.language),
                title: Text("Türkçe"),
                onTap: () {
                  setState(() {
                    selectedLanguage = "Türkçe";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text("English"),
                onTap: () {
                  setState(() {
                    selectedLanguage = "English";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Profil Ayarları"),
          _buildListTile(Icons.person, "Profil Bilgileri", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }),
          _buildListTile(Icons.lock, "Şifre Değiştir", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PasswordChange()),
            );
          }),

          SizedBox(height: 20),
          _buildSectionHeader("Uygulama Tercihleri"),
          _buildSwitchListTile(
            "Bildirimler",
            "Bitki hastalığı hakkında bildirimler alın.",
            true,
            (bool value) {},
          ),

          // 🔥 Dil Seçimi (Güncellendi)
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Dil Seçimi"),
            subtitle: Text(selectedLanguage),
            onTap: _showLanguageSelection,
          ),

          SwitchListTile(
            title: Text("Koyu Mod"),
            subtitle: Text("Uygulama temasını değiştirin."),
            value: themeNotifier.value == ThemeMode.dark,
            onChanged: (bool isDark) {
              themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
            },
            secondary: Icon(Icons.nightlight_round),
          ),

          SizedBox(height: 20),
          _buildSectionHeader("Konum Ayarları"),
          _buildSwitchListTile(
            "Konum İzni",
            "Bitki hastalıklarını çevrenizde teşhis etmek için konum izni verin.",
            true,
            (bool value) {},
          ),

          SizedBox(height: 20),
          _buildSectionHeader("Yardım ve Destek"),
          _buildListTile(Icons.help_outline, "Sıkça Sorulan Sorular", () {}),
          _buildListTile(Icons.phone, "Bize Ulaşın", () {}),

          SizedBox(height: 20),
          _buildSectionHeader("Hesap Ayarları"),
          _buildListTile(Icons.exit_to_app, "Çıkış Yap", () {}),
          _buildListTile(Icons.delete_forever, "Hesap Sil", () {}),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onTap(),
    );
  }

  Widget _buildSwitchListTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
