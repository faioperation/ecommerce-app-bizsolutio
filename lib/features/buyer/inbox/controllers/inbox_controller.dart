import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

/// InboxController manages the conversations list and messages per chat.
/// Designed for easy API integration: replace the mock data methods with
/// real API calls in the future.
class InboxController extends GetxController {
  /// All conversations, sorted by latest message.
  final chatList = <ChatModel>[].obs;

  /// Messages per chatId. Key = chatId, Value = list of messages.
  final Map<String, RxList<MessageModel>> _messagesMap = {};

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  // ── MOCK DATA (Replace with API calls) ───────────────────────────────────

  void _loadMockData() {
    chatList.assignAll([
      ChatModel(
        id: 'techstore',
        name: 'TechStore',
        profileImage:
            'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=200',
        lastMessage: 'Your order has been shipped! 🚀',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 2,
      ),
      ChatModel(
        id: 'fashionhub',
        name: 'FashionHub',
        profileImage:
            'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=200',
        lastMessage: 'Thanks for your purchase! 🛍️',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 0,
      ),
      ChatModel(
        id: 'audiophile',
        name: 'AudioPhile',
        profileImage:
            'https://images.unsplash.com/photo-1545127398-14699f92334b?q=80&w=200',
        lastMessage: 'Let me know if you need anything else.',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 1,
      ),
    ]);

    _messagesMap['techstore'] = <MessageModel>[
      MessageModel(
        id: 'm1',
        chatId: 'techstore',
        text: 'Hi, I ordered a headphone. Is it shipped?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 10),
        ),
        isMe: true,
      ),
      MessageModel(
        id: 'm2',
        chatId: 'techstore',
        text: 'Yes! Your order has been shipped! 🚀',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: false,
      ),
    ].obs;

    _messagesMap['fashionhub'] = <MessageModel>[
      MessageModel(
        id: 'm3',
        chatId: 'fashionhub',
        text: 'I love the jacket!',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 3, minutes: 10),
        ),
        isMe: true,
      ),
      MessageModel(
        id: 'm4',
        chatId: 'fashionhub',
        text: 'Thanks for your purchase! 🛍️',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
    ].obs;
  }

  // ── PUBLIC METHODS (API-ready) ────────────────────────────────────────────

  /// Fetch all chats – replace body with API call.
  Future<void> fetchChats() async {
    // TODO: final response = await ApiService.getChats();
    // chatList.assignAll(response.map(ChatModel.fromJson));
  }

  /// Get or create messages list for a given chatId.
  RxList<MessageModel> getMessages(String chatId) {
    _messagesMap.putIfAbsent(chatId, () => <MessageModel>[].obs);
    return _messagesMap[chatId]!;
  }

  /// Open/start a chat with a shop. Called from ShopProfileScreen.
  void openOrCreateChat({
    required String chatId,
    required String name,
    required String profileImage,
  }) {
    final existing = chatList.indexWhere((c) => c.id == chatId);
    if (existing == -1) {
      chatList.insert(
        0,
        ChatModel(
          id: chatId,
          name: name,
          profileImage: profileImage,
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        ),
      );
    } else {
      // Move to top
      final chat = chatList.removeAt(existing);
      chatList.insert(0, chat);
    }
    _messagesMap.putIfAbsent(chatId, () => <MessageModel>[].obs);

    // Mark as read when opening
    markAsRead(chatId);
  }

  /// Send a message – add to local state and update inbox list.
  void sendMessage(String chatId, String text) {
    if (text.trim().isEmpty) return;

    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      text: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    );

    _messagesMap.putIfAbsent(chatId, () => <MessageModel>[].obs);
    _messagesMap[chatId]!.add(msg);

    // Update inbox list entry
    final idx = chatList.indexWhere((c) => c.id == chatId);
    if (idx != -1) {
      chatList[idx].lastMessage = text.trim();
      chatList[idx].lastMessageTime = DateTime.now();
      final chat = chatList.removeAt(idx);
      chatList.insert(0, chat);
    }

    // TODO: await ApiService.sendMessage(chatId, text);
  }

  /// Mark all messages in a chat as read.
  void markAsRead(String chatId) {
    final idx = chatList.indexWhere((c) => c.id == chatId);
    if (idx != -1) {
      chatList[idx].unreadCount = 0;
      chatList.refresh(); // Notify Obx
    }
    // TODO: await ApiService.markRead(chatId);
  }

  // ── HELPERS ────────────────────────────────────────────────────────────────

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays == 0 && now.day == time.day) {
      final h = time.hour > 12
          ? time.hour - 12
          : (time.hour == 0 ? 12 : time.hour);
      final m = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $period';
    } else if (diff.inDays <= 1) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
