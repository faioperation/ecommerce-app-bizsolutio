import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../models/address_model.dart';
import '../models/payment_method_model.dart';
import '../models/delivery_option_model.dart';
import '../models/order_item_model.dart';

class CheckoutController extends GetxController {
  // ─── Selected Checkout Data ───────────────────────────────────────────────
  final selectedAddressId = ''.obs;
  final selectedPaymentId = ''.obs;
  final selectedDeliveryId = ''.obs;
  final isPlacingOrder = false.obs;

  // ─── Order Result ─────────────────────────────────────────────────────────
  final orderNumber = ''.obs;
  final estimatedDelivery = ''.obs;

  // ─── Mock Address List (Replace with API call) ────────────────────────────
  final addresses = <AddressModel>[
    AddressModel(
      id: 'addr1',
      label: 'Home',
      name: 'John Doe',
      house: '123 Main Street',
      street: 'San Francisco, CA 94102',
      town: 'California',
      phone: '+1 (555) 123-4567',
      isDefault: true,
    ),
    AddressModel(
      id: 'addr2',
      label: 'Work',
      name: 'John Doe',
      house: '456 Office Plaza',
      street: 'San Francisco, CA 94103',
      town: 'California',
      phone: '+1 (555) 123-4567',
    ),
  ].obs;

  // ─── Mock Payment Methods (Replace with API call) ─────────────────────────
  final paymentMethods = <PaymentMethodModel>[
    PaymentMethodModel(
      id: 'wallet',
      type: 'wallet',
      label: 'Vango Wallet',
      walletBalance: 150.50,
    ),
    PaymentMethodModel(
      id: 'card1',
      type: 'card',
      label: 'Visa',
      last4: '4242',
      expiry: '12/24',
      isDefault: true,
    ),
    PaymentMethodModel(
      id: 'card2',
      type: 'card',
      label: 'Mastercard',
      last4: '8888',
      expiry: '06/25',
    ),
    PaymentMethodModel(
      id: 'cash',
      type: 'cash',
      label: 'Cash on Delivery',
    ),
  ].obs;

  // ─── Mock Delivery Options (Replace with API call) ────────────────────────
  final deliveryOptions = <DeliveryOptionModel>[
    DeliveryOptionModel(
      id: 'standard',
      name: 'Standard Delivery',
      duration: '3-5 days',
      price: 0.0,
    ),
    DeliveryOptionModel(
      id: 'express',
      name: 'Express Delivery',
      duration: '1-2 days',
      price: 15.0,
    ),
    DeliveryOptionModel(
      id: 'sameday',
      name: 'Same Day Delivery',
      duration: 'Today by 9pm',
      price: 25.0,
    ),
  ].obs;

  // ─── Order Items (passed from product details screen) ─────────────────────
  final orderItems = <OrderItemModel>[].obs;

  // ─── Getters ──────────────────────────────────────────────────────────────
  AddressModel? get selectedAddress {
    try {
      return addresses.firstWhere((a) => a.id == selectedAddressId.value);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  PaymentMethodModel? get selectedPayment {
    try {
      return paymentMethods.firstWhere((p) => p.id == selectedPaymentId.value);
    } catch (_) {
      return paymentMethods.firstWhere(
        (p) => p.isDefault,
        orElse: () => paymentMethods.first,
      );
    }
  }

  DeliveryOptionModel? get selectedDelivery {
    try {
      return deliveryOptions.firstWhere((d) => d.id == selectedDeliveryId.value);
    } catch (_) {
      return deliveryOptions.isNotEmpty ? deliveryOptions.first : null;
    }
  }

  double get itemsTotal =>
      orderItems.fold(0.0, (sum, item) => sum + item.subtotal);

  double get deliveryFee => selectedDelivery?.price ?? 0.0;

  double get grandTotal => itemsTotal + deliveryFee;

  // ─── Init ─────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Set defaults
    selectedAddressId.value =
        addresses.firstWhereOrNull((a) => a.isDefault)?.id ??
        addresses.first.id;
    selectedPaymentId.value =
        paymentMethods.firstWhereOrNull((p) => p.isDefault)?.id ??
        paymentMethods.first.id;
    selectedDeliveryId.value = deliveryOptions.first.id;
  }

  // ─── Load Product for Buy Now (Called from Product Details Screen) ─────────
  void loadBuyNowItem(OrderItemModel item) {
    orderItems.clear();
    orderItems.add(item);
  }

  // ─── Address Operations ───────────────────────────────────────────────────
  void selectAddress(String id) => selectedAddressId.value = id;

  void addAddress(AddressModel address) {
    addresses.add(address);
    selectedAddressId.value = address.id;
  }

  // ─── Payment Operations ───────────────────────────────────────────────────
  void selectPayment(String id) => selectedPaymentId.value = id;

  void addCard({
    required String label,
    required String cardNumber,
    required String expiry,
    required String cvv,
  }) {
    final last4 = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
    paymentMethods.add(PaymentMethodModel(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      type: 'card',
      label: label,
      last4: last4,
      expiry: expiry,
    ));
  }

  // ─── Delivery Selection ───────────────────────────────────────────────────
  void selectDelivery(String id) => selectedDeliveryId.value = id;

  // ─── Place Order ──────────────────────────────────────────────────────────
  Future<void> placeOrder(BuildContext context) async {
    if (orderItems.isEmpty) return;

    isPlacingOrder.value = true;

    // Capture router reference BEFORE the async gap (avoids use_build_context_synchronously)
    final router = GoRouter.of(context);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Generate mock order result
    orderNumber.value =
        '#ORD-${DateTime.now().year}-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';

    final deliveryDays = selectedDelivery?.id == 'express'
        ? 2
        : selectedDelivery?.id == 'sameday'
            ? 0
            : 4;
    final deliveryDate =
        DateTime.now().add(Duration(days: deliveryDays));
    estimatedDelivery.value =
        '${_monthName(deliveryDate.month)} ${deliveryDate.day}-${deliveryDate.day + 2}, ${deliveryDate.year}';

    isPlacingOrder.value = false;

    // Navigate to Order Success Screen using captured GoRouter
    router.push('/checkout/success');
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}
