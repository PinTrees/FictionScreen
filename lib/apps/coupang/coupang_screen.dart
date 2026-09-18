import 'package:flutter/cupertino.dart';
import 'data/coupang_model.dart';
import 'widgets/coupang_desktop_view.dart';
import 'widgets/coupang_icons.dart';
import 'widgets/coupang_mobile_view.dart';

class CoupangScreen extends StatefulWidget {
  final CoupangConfig config;
  final ValueChanged<CoupangConfig>? onConfigChanged;

  const CoupangScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<CoupangScreen> createState() => _CoupangScreenState();
}

class _CoupangScreenState extends State<CoupangScreen> {
  late CoupangConfig _activeConfig;
  CoupangProductItem? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _activeConfig = widget.config;
  }

  @override
  void didUpdateWidget(covariant CoupangScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _activeConfig = widget.config;
    }
  }

  void _updateConfig(CoupangConfig newConfig) {
    setState(() {
      _activeConfig = newConfig;
    });
    widget.onConfigChanged?.call(newConfig);
  }

  void _openProductSheet(CoupangProductItem product) {
    setState(() {
      _selectedProduct = product;
    });
  }

  void _closeProductSheet() {
    setState(() {
      _selectedProduct = null;
    });
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Responsive Layout
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 650) {
              return CoupangDesktopView(
                config: _activeConfig,
                onConfigChanged: _updateConfig,
                onSelectProduct: _openProductSheet,
              );
            } else {
              return CoupangMobileView(
                config: _activeConfig,
                onConfigChanged: _updateConfig,
                onSelectProduct: _openProductSheet,
              );
            }
          },
        ),

        // In-Window Product Quick Detail Sheet
        if (_selectedProduct != null) ...[
          GestureDetector(
            onTap: _closeProductSheet,
            child: Container(
              color: const Color(0x66000000),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildProductDetailSheet(_selectedProduct!),
          ),
        ],
      ],
    );
  }

  Widget _buildProductDetailSheet(CoupangProductItem product) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 460),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header with Close
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFFEEEEEE),
                    child: const Center(child: Icon(CupertinoIcons.photo, color: Color(0xFFCCCCCC))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoupangIcons.badge(product.badgeType),
                    const SizedBox(height: 4),
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (product.discountPercent > 0) ...[
                          Text(
                            '${product.discountPercent}%',
                            style: const TextStyle(
                              color: Color(0xFFCB1400),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          '${_formatPrice(product.price)}원',
                          style: const TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _closeProductSheet,
                child: const Icon(CupertinoIcons.xmark, color: Color(0xFF888888), size: 20),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Container(height: 1, color: const Color(0xFFEEEEEE)),
          const SizedBox(height: 14),

          // Delivery info row
          Row(
            children: [
              const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF00891A), size: 16),
              const SizedBox(width: 6),
              Text(
                product.deliveryNotice,
                style: const TextStyle(
                  color: Color(0xFF00891A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CoupangIcons.ratingStars(product.rating, size: 13),
              const SizedBox(width: 6),
              Text(
                '${product.rating}점 · 상품평 ${product.reviewCount}개',
                style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
              ),
            ],
          ),
          if (product.cashReward > 0) ...[
            const SizedBox(height: 8),
            Text(
              '💰 와우 회원 최대 ${_formatPrice(product.cashReward)}원 캐시 적립',
              style: const TextStyle(color: Color(0xFF0073E9), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],

          const SizedBox(height: 20),

          // Action Buttons: Cart & Buy Now
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _updateConfig(_activeConfig.copyWith(cartCount: _activeConfig.cartCount + 1));
                    _closeProductSheet();
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF0073E9), width: 1.5),
                    ),
                    child: const Center(
                      child: Text(
                        '장바구니 담기',
                        style: TextStyle(
                          color: Color(0xFF0073E9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: _closeProductSheet,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0073E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        '바로구매 >',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
