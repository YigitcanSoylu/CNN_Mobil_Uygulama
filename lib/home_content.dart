import 'dart:io';
import 'package:bitki_teshis/teshissonuc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:image_picker/image_picker.dart'; // For picking images from gallery
import 'package:camera/camera.dart'; // For camera functionality

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFirstPlay = true;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath; // Store the selected or captured image path

  @override
  void initState() {
    super.initState();

    // AnimationController setup
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Restart animation after completion
        _controller.forward(from: 0.76736111111);
      }
    });

    _initializeCamera();
  }

  // Check if the user is logged in
  bool get _isUserLoggedIn => _auth.currentUser != null;

  // Initialize camera
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animation
            Center(
              child: Lottie.asset(
                'assets/plant_animation.json',
                width: 300,
                height: 300,
                controller: _controller,
                onLoaded: (composition) {
                  if (_isFirstPlay) {
                    _controller.forward();
                    _isFirstPlay = false;
                  } else {
                    _controller.forward(from: 0.7);
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "Bitkinizin hastalığını teşhis edin!",
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Buttons (Camera and Gallery)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  icon: Icons.camera_alt,
                  label: "Kamera ile Çek",
                  onTap: _isUserLoggedIn ? _onCameraTap : _showLoginPrompt,
                ),
                _buildButton(
                  icon: Icons.image,
                  label: "Galeriden Seç",
                  onTap: _isUserLoggedIn ? _onGalleryTap : _showLoginPrompt,
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Display selected or captured image
            if (_imagePath != null) ...[
              Image.file(
                File(_imagePath!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TeshisSonucPage(
                            diseaseName:
                                "Fungal Infection", // Example disease name
                            diseaseImageUrl:
                                "https://example.com/disease_image.jpg", // Example image URL
                          ),
                    ),
                  );
                },
                child: Text("Teşhis Et"),
              ),
            ],
            const SizedBox(height: 20),
            // Recent Diagnoses
            Text(
              "Son Teşhisler",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildHistoryList(),
            const SizedBox(height: 20),
            // Plant Care Guide
            Text(
              "Bitki Bakım Rehberi",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildGuideCard(),
          ],
        ),
      ),
    );
  }

  // Button builder
  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green[100],
            child: Icon(icon, size: 30, color: Colors.green[700]),
          ),
          const SizedBox(height: 10),
          Text(label, style: GoogleFonts.poppins(fontSize: 15)),
        ],
      ),
    );
  }

  // Camera button action
  void _onCameraTap() async {
    if (_isCameraInitialized) {
      // Implement camera functionality
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _imagePath = image.path; // Save the captured image path
        });
        print("Kamera ile fotoğraf çekildi: ${image.path}");
        // Process the captured image
      }
    } else {
      print("Kamera başlatılmadı");
    }
  }

  // Gallery button action
  void _onGalleryTap() async {
    // Implement gallery selection functionality
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path; // Save the selected image path
      });
      print("Galeriden fotoğraf seçildi: ${image.path}");
      // Process the selected image
    }
  }

  // Show login prompt if the user is not logged in
  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Giriş Yapın"),
          content: Text("Bu işlemi yapabilmek için giriş yapmanız gerekiyor."),
          actions: [
            TextButton(
              child: Text("Tamam"),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Recent Diagnosis list
  Widget _buildHistoryList() {
    return Column(
      children: [
        _buildHistoryItem(
          imageUrl:
              "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=100&h=100&fit=crop",
          diseaseName: "Mildiyö Hastalığı",
          date: "10 Mart 2025",
        ),
        _buildHistoryItem(
          imageUrl:
              "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=100&h=100&fit=crop",
          diseaseName: "Külleme Hastalığı",
          date: "5 Mart 2025",
        ),
      ],
    );
  }

  // History item builder
  Widget _buildHistoryItem({
    required String imageUrl,
    required String diseaseName,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          diseaseName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(date),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // Plant care guide card
  Widget _buildGuideCard() {
    return Card(
      color: Colors.green[50],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bitkileriniz için öneriler!",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("✓ Düzenli sulayın, ancak fazla su vermeyin."),
            Text("✓ Bitkinizi doğrudan güneş ışığından koruyun."),
            Text("✓ Toprak nemini düzenli kontrol edin."),
          ],
        ),
      ),
    );
  }
}

// Example Diagnosis Page
