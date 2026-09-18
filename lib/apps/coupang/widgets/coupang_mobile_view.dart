import 'package:flutter/cupertino.dart';
import '../data/coupang_model.dart';
import 'coupang_icons.dart';

class CoupangMobileView extends StatefulWidget {
  final CoupangConfig config;
  final ValueChanged<CoupangConfig>? onConfigChanged;
  final ValueChanged<CoupangProductItem>? onSelectProduct;

  const CoupangMobileView({
    super.key,
    required this.config,
    this.onConfigChanged,
    this.onSelectProduct,
  });

  @override
  State<CoupangMobileView> createState() => _CoupangMobileViewState();
}

class _CoupangMobileViewState extends State<CoupangMobileView> {
  int _currentTabIndex = 2; // Default to 'Home' (index 2)
  int _bannerIndex = 0;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = widget.config.searchKeyword;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: Column(
        children: [
          // 1. Mobile Top Search Bar
          _buildMobileHeader(),

          // 2. Mobile Main Scrollable Feed
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Location Bar
                  _buildLocationBar(),

                  // Category Icon Grid
                  _buildCategoryGrid(),
                  const SizedBox(height: 10),

                  // Promotional Banner
                  _buildBannerSlider(),
                  const SizedBox(height: 14),

                  // Product Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '오늘의 골드박스 & 로켓추천',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '전체보기 >',
                          style: TextStyle(
                            color: Color(0xFF0073E9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2-Column Product Grid
                  _buildMobileProductGrid(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 3. Mobile 5-Tab Bottom Navigation
          _buildMobileBottomNav(),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      color: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Column(
        children: [
          Row(
            children: [
              CoupangIcons.logo(height: 24),
              const Spacer(),
              const Icon(CupertinoIcons.bell, color: Color(0xFF333333), size: 22),
              const SizedBox(width: 14),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(CupertinoIcons.cart, color: Color(0xFF333333), size: 22),
                  if (widget.config.cartCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE60023),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${widget.config.cartCount}',
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Search Pill
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFF0073E9), width: 1.5),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(CupertinoIcons.search, color: Color(0xFF0073E9), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: CupertinoTextField(
                    controller: _searchCtrl,
                    placeholder: '쿠팡에서 검색하세요!',
                    placeholderStyle: const TextStyle(color: Color(0xFF999999), fontSize: 13),
                    decoration: null,
                    style: const TextStyle(color: Color(0xFF111111), fontSize: 13),
                    onSubmitted: (val) {
                      widget.onConfigChanged?.call(widget.config.copyWith(searchKeyword: val));
                    },
                  ),
                ),
                const Icon(CupertinoIcons.camera, color: Color(0xFF777777), size: 18),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBar() {
    return Container(
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          const Icon(CupertinoIcons.location_solid, color: Color(0xFF0073E9), size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              widget.config.userLocation,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(CupertinoIcons.chevron_right, color: Color(0xFF888888), size: 12),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = widget.config.categories;
    return Container(
      color: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.85,
          crossAxisSpacing: 4,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getCategoryBg(cat.iconKey),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(cat.iconKey),
                    color: _getCategoryIconColor(cat.iconKey),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                cat.name,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getCategoryBg(String key) {
    switch (key) {
      case 'rocket':
        return const Color(0xFFE6F2FF);
      case 'fresh':
        return const Color(0xFFE6F8ED);
      case 'gold':
        return const Color(0xFFFFF7E6);
      case 'global':
        return const Color(0xFFF0EBFB);
      case 'wow':
        return const Color(0xFFFCE7F3);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  IconData _getCategoryIcon(String key) {
    switch (key) {
      case 'rocket':
        return CupertinoIcons.paperplane_fill;
      case 'fresh':
        return CupertinoIcons.leaf_arrow_circlepath;
      case 'gold':
        return CupertinoIcons.gift_fill;
      case 'global':
        return CupertinoIcons.airplane;
      case 'wow':
        return CupertinoIcons.sparkles;
      case 'tech':
        return CupertinoIcons.device_laptop;
      case 'fashion':
        return CupertinoIcons.tag_fill;
      case 'food':
        return CupertinoIcons.cart_fill;
      case 'home':
        return CupertinoIcons.house_alt_fill;
      case 'play':
        return CupertinoIcons.play_circle_fill;
      default:
        return CupertinoIcons.cube_box_fill;
    }
  }

  Color _getCategoryIconColor(String key) {
    switch (key) {
      case 'rocket':
        return const Color(0xFF0073E9);
      case 'fresh':
        return const Color(0xFF009245);
      case 'gold':
        return const Color(0xFFF59E0B);
      case 'global':
        return const Color(0xFF6B21A8);
      case 'wow':
        return const Color(0xFFDB2777);
      default:
        return const Color(0xFF4B5563);
    }
  }

  Widget _buildBannerSlider() {
    final banner = widget.config.banners[_bannerIndex % widget.config.banners.length];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _bannerIndex = (_bannerIndex + 1) % widget.config.banners.length;
          });
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Color(banner.bgColorHex),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 140,
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1E293B)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(banner.bgColorHex),
                    Color(banner.bgColorHex).withValues(alpha: 0.8),
                    const Color(0x00000000),
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              bottom: 16,
              right: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0073E9),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      banner.tag,
                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_bannerIndex + 1} / ${widget.config.banners.length}',
                  style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildMobileProductGrid() {
    final products = widget.config.products;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildMobileProductCard(product);
        },
      ),
    );
  }

  Widget _buildMobileProductCard(CoupangProductItem product) {
    return GestureDetector(
      onTap: () => widget.onSelectProduct?.call(product),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                color: const Color(0xFFFAFAFA),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFEEEEEE),
                    child: const Center(
                      child: Icon(CupertinoIcons.photo, color: Color(0xFFCCCCCC), size: 28),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 11,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    CoupangIcons.badge(product.badgeType, scale: 0.9),
                    const SizedBox(height: 4),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (product.discountPercent > 0) ...[
                          Text(
                            '${product.discountPercent}%',
                            style: const TextStyle(
                              color: Color(0xFFCB1400),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          _formatPrice(product.price),
                          style: const TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          '원',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Text(
                      product.deliveryNotice,
                      style: const TextStyle(
                        color: Color(0xFF00891A),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    Row(
                      children: [
                        CoupangIcons.ratingStars(product.rating, size: 9),
                        const SizedBox(width: 3),
                        Text(
                          '(${product.reviewCount})',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 0.8),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(0, '카테고리', CupertinoIcons.bars),
          _buildBottomNavItem(1, '검색', CupertinoIcons.search),
          _buildBottomNavItem(2, '홈', CupertinoIcons.house_fill),
          _buildBottomNavItem(3, '마이쿠팡', CupertinoIcons.person_fill),
          _buildBottomNavItem(4, '장바구니', CupertinoIcons.cart_fill, badge: widget.config.cartCount),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(int index, String label, IconData icon, {int badge = 0}) {
    final isSelected = _currentTabIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF0073E9) : const Color(0xFF666666),
                size: 22,
              ),
              if (badge > 0)
                Positioned(
                  top: -3,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE60023),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0073E9) : const Color(0xFF666666),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
