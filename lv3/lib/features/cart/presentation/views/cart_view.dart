import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../generated/locales.g.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../domain/entities/cart_item.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: LocaleKeys.cart_title.tr,
      leading: const SizedBox.shrink(),
      actions: [
        Obx(
          () => controller.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Clear cart',
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => _confirmClear(controller),
                ),
        ),
      ],
      bottomBar: Obx(
        () => controller.isEmpty ? const SizedBox.shrink() : _summary(controller),
      ),
      body: Obx(() {
        if (controller.isEmpty) {
          return EmptyStateView(
            icon: Icons.shopping_cart_outlined,
            title: LocaleKeys.cart_emptyCart.tr,
            subtitle: '',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => AppDimens.gap12,
          itemBuilder: (_, i) => _line(controller, i, controller.items[i]),
        );
      }),
    );
  }

  Widget _line(CartController cart, int index, CartItem item) {
    final p = item.product;
    final hasImage = p.image != null && p.image!.isNotEmpty;
    return AppCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 52,
              width: 52,
              color: AppColors.surfaceMuted,
              child: hasImage
                  ? Image.network(p.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                          Icons.inventory_2_rounded,
                          color: AppColors.textMuted))
                  : Icon(Icons.inventory_2_rounded,
                      color: AppColors.textMuted),
            ),
          ),
          AppDimens.gap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(p.name),
                AppDimens.gap4,
                AppText.body('\$${p.price.toStringAsFixed(2)}',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700),
              ],
            ),
          ),
          _stepper(cart, index, item),
        ],
      ),
    );
  }

  Widget _stepper(CartController cart, int index, CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _stepBtn(Icons.remove_rounded, () => cart.decrement(index)),
          SizedBox(
            width: 28,
            child: Center(child: AppText.title('${item.quantity}')),
          ),
          _stepBtn(Icons.add_rounded, () => cart.increment(index)),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _summary(CartController cart) {
    return FormSaveBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body('Total (${cart.count} items)'),
              AppText.heading('\$${cart.totalPrice.toStringAsFixed(2)}'),
            ],
          ),
          AppDimens.gap12,
          AppButton(
            label: LocaleKeys.cart_checkout.tr,
            icon: Icons.check_rounded,
            onPressed: () => _checkout(cart),
          ),
        ],
      ),
    );
  }

  void _checkout(CartController cart) {
    final n = cart.count;
    cart.clear();
    AppDialogs.showToast(
      title: 'Success',
      message: 'Order placed — $n item(s)',
    );
  }

  void _confirmClear(CartController cart) {
    AppDialogs.showConfirm(
      title: LocaleKeys.cart_clearCart.tr,
      message: '',
      textConfirm: LocaleKeys.cart_clearCart.tr,
      onConfirm: () => cart.clear(),
    );
  }
}
