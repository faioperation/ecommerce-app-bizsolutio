import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/live_activity_model.dart';

class LiveBiddingController extends GetxController {
  final commentController = TextEditingController();
  final scrollController = ScrollController();

  // Auction State Variables
  Timer? _auctionTimer;
  final secondsRemaining = 35.obs;
  final isAuctionEnded = false.obs;
  final showEndBanner = false.obs;

  // Active Bidding metrics
  final currentBid = 420.0.obs;
  final highestBidder = 'Alex'.obs;
  final totalBids = 23.obs;

  // Interactive UI
  final isLiked = false.obs;

  // Activities log (comments + bids)
  final activities = <LiveActivityModel>[
    LiveActivityModel(username: 'Rifat', text: 'How much? 🤔', isBid: false),
    LiveActivityModel(username: 'Alex', text: 'Start auction 🔥', isBid: false),
    LiveActivityModel(username: 'Nayeem', text: 'placed £400', isBid: true),
    LiveActivityModel(username: 'Sarah', text: 'This is amazing!', isBid: false),
    LiveActivityModel(username: 'Alex', text: 'placed £420', isBid: true),
  ].obs;

  // Callback to display the Victory Dialog
  Function? onAuctionWonCallback;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _auctionTimer?.cancel();
    commentController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Starts the countdown timer
  void startTimer() {
    _auctionTimer?.cancel();
    _auctionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _auctionTimer?.cancel();
        _endAuction();
      }
    });
  }

  // Resets the auction states to default for demo testing
  void resetAuction() {
    secondsRemaining.value = 35;
    isAuctionEnded.value = false;
    showEndBanner.value = false;
    currentBid.value = 420.0;
    highestBidder.value = 'Alex';
    totalBids.value = 23;
    
    // Remove user placed activities
    activities.removeWhere((act) => act.username == 'You');
    
    startTimer();
    
    Get.snackbar(
      'Auction Reset', 
      'The live auction has restarted! Place your bid to test the winning flow.',
      backgroundColor: Colors.blueAccent.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Handle Auction ending
  void _endAuction() {
    isAuctionEnded.value = true;
    if (highestBidder.value == 'You') {
      // Trigger Winner Dialog callback
      if (onAuctionWonCallback != null) {
        onAuctionWonCallback!();
      }
    } else {
      // Show Auction Ended Toast Overlay
      showEndBanner.value = true;
    }
  }

  // Place a custom bid amount
  void placeBid(double amount) {
    currentBid.value = amount;
    highestBidder.value = 'You';
    totalBids.value++;
    
    activities.add(LiveActivityModel(
      username: 'You',
      text: 'placed £${amount.toStringAsFixed(0)}',
      isBid: true,
    ));

    Get.snackbar(
      'Bid Placed!', 
      'You are now the highest bidder at £${amount.toStringAsFixed(0)}!',
      backgroundColor: Colors.pinkAccent.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    _scrollFeedToBottom();
  }

  // Handle typing a comment or custom bid in bottom text bar
  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    bool isBid = text.toLowerCase().contains('placed') || 
                 text.toLowerCase().contains('£') || 
                 RegExp(r'\d+').hasMatch(text);

    activities.add(LiveActivityModel(
      username: 'You',
      text: isBid ? 'placed $text' : text,
      isBid: isBid,
    ));
    commentController.clear();

    _scrollFeedToBottom();
  }

  void _scrollFeedToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Toggle Love react
  void toggleLike() {
    isLiked.toggle();
    Get.snackbar(
      isLiked.value ? 'Loved!' : 'Unloved', 
      isLiked.value ? 'You liked the live stream!' : 'You removed your like.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isLiked.value 
          ? Colors.pink.withValues(alpha: 0.8) 
          : Colors.black87.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }
}
