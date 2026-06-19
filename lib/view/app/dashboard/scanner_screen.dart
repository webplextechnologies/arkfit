import 'dart:convert';

import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/dashboard/barcode_scanned_screen.dart';
import 'package:ark_fit_gym/view/app/home/model/barcode_food_model.dart';
import 'package:ark_fit_gym/view/app/home/model/scanned_food_model.dart';
import 'package:ark_fit_gym/view/app/scanner/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;

  Future<void> sendBarcodeToApi(String barcode) async {
    var body = {"barcode": barcode};
//999995377214
    try {
      final response = await ApiServices.postRequest(
        ApiUrls.scanBarcode,
        body: body,
      );
      print(body);
      print(ApiUrls.scanBarcode);

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        BarcodeFoodModel model = BarcodeFoodModel.fromJson(jsonResponse);
        // Get.to(() => BarcodeScannedScreen(scannedFood: model.data!));
        Get.off(() => BarcodeScannedScreen(scannedFood: model.data!));
        print(model.data!.name!);
        print(jsonResponse);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // Setup the "Laser" animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            /*   onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? "Unknown";
                debugPrint('Barcode found! $code');
                Navigator.pop(context, code);
              }
            }, */
            onDetect: (capture) async {
              if (isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isNotEmpty) {
                isScanned = true;

                final String code = barcodes.first.rawValue ?? "Unknown";

                cameraController.stop();

                await sendBarcodeToApi(code);

                //  Navigator.pop(context, code);
              }
            },
          ),
          _buildOverlay(context),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Text(
                  "SCAN CODE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.flash_off, color: Colors.grey),
                    onPressed: () => cameraController.toggleTorch(),
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Hint Text
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Align barcode within the frame to scan",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    double scanArea = MediaQuery.of(context).size.width * 0.7;
    return Stack(
      children: [
        // Dark semi-transparent background with a hole in the middle
        ColorFiltered(
          overlayColor: Colors.black.withOpacity(0.5),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
        ),
        // The actual frame
        Center(
          child: Container(
            width: scanArea,
            height: scanArea,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange.shade800, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Moving Laser Line
                    Positioned(
                      top: _animationController.value * scanArea,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        width: scanArea,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Special "Hole" Clipper for the background
class ColorFiltered extends StatelessWidget {
  final Color overlayColor;
  final Widget child;

  const ColorFiltered({
    super.key,
    required this.overlayColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          colors: [overlayColor, overlayColor],
        ).createShader(rect);
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}
