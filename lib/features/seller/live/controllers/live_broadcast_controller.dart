import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/live_session_data.dart';
import '../models/live_comment_model.dart';

/// Controller for the actual Live Broadcast screen.
/// Handles Camera initialization, stream statistics, and chat logic.
class LiveBroadcastController extends GetxController {
  late final LiveSessionData sessionData;

  // Camera State
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxBool hasCameraPermission = false.obs;

  // Chat State
  final RxList<LiveCommentModel> comments = <LiveCommentModel>[].obs;
  final TextEditingController chatInputController = TextEditingController();

  // Stream Stats
  final RxString viewerCount = '1.2K'.obs;

  void init(LiveSessionData data) {
    sessionData = data;
    _initializeCamera();
    _loadMockComments();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    chatInputController.dispose();
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    // Request permissions first
    final status = await Permission.camera.request();
    if (status.isGranted) {
      hasCameraPermission.value = true;
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // Default to front camera for live streaming
          final frontCamera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );

          cameraController = CameraController(
            frontCamera,
            ResolutionPreset.high,
            enableAudio: true, // Will also request mic permission automatically on start
          );

          await cameraController!.initialize();
          isCameraInitialized.value = true;
        }
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    } else {
      hasCameraPermission.value = false;
      debugPrint('Camera permission denied.');
    }
  }

  void _loadMockComments() {
    // Adding the mock comments from the screenshot
    comments.assignAll([
      LiveCommentModel(
        id: '1',
        userName: 'Rahul Ahmed',
        message: 'How much is the watch?',
        timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
      ),
      LiveCommentModel(
        id: '2',
        userName: 'Ayesha Khan',
        message: 'Do you ship to Chittagong?',
        timestamp: DateTime.now().subtract(const Duration(seconds: 15)),
      ),
    ]);
  }

  void sendMessage() {
    final text = chatInputController.text.trim();
    if (text.isNotEmpty) {
      comments.add(LiveCommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: 'Seller (You)',
        message: text,
        timestamp: DateTime.now(),
      ));
      chatInputController.clear();
      // Future API integration: Send this message to WebSocket server
    }
  }
}
