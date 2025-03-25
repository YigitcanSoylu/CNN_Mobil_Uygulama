import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeshisSonucPage extends StatelessWidget {
  final String diseaseName; // Teşhis edilen hastalık adı
  final String diseaseImageUrl; // Hastalıkla ilgili görsel (örnek)

  // Constructor
  TeshisSonucPage({required this.diseaseName, required this.diseaseImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teşhis Sonucu",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hastalık Başlığı
            Text(
              diseaseName,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            // Hastalık Görseli
            Center(
              child: Image.network(
                diseaseImageUrl,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Hastalık Açıklaması
            Text(
              "Hastalık Açıklaması:",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Bu hastalık, bitkinin sağlığını tehdit eden önemli bir sorundur. "
              "Bitkilerde genellikle yapraklarda lekeler ve sararmalar görülür. "
              "Etkilenen bitkilerde verim kaybı yaşanabilir. Erken müdahale önemlidir.",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Tedavi ve Bakım Önerileri
            Text(
              "Tedavi ve Bakım Önerileri:",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "✓ Hastalıklı yaprakları temizleyin ve ortadan kaldırın.\n"
              "✓ Bitkinizi düzenli aralıklarla sulayın ancak aşırı su vermemeye özen gösterin.\n"
              "✓ Kimyasal tedavi veya ilaç kullanmadan önce bir uzmana danışın.\n"
              "✓ Bitkinin hava almasını sağlayacak şekilde bakım yapın.",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Sonraki Adımlar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Burada kullanıcının başka bir sayfaya yönlendirilmesi sağlanabilir
                  Navigator.pop(context); // Önceki sayfaya dön
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text("Sonraki Adım"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
