import 'package:flutter/cupertino.dart';
import '../data/coupang_model.dart';
import 'coupang_icons.dart';

class CoupangDesktopView extends StatefulWidget {
  final CoupangConfig config;
  final ValueChanged<CoupangConfig>? onConfigChanged;
  final ValueChanged<CoupangProductItem>? onSelectProduct;

  const CoupangDesktopView({
    super.key,
    required this.config,
    this.onConfigChanged,
    this.onSelectProduct,
  });

  @override
  State<CoupangDesktopView> createState() => _CoupangDesktopViewState();
}

class _CoupangDesktopViewState extends State<CoupangDesktopView> {
  int _currentBannerIndex = 0;
  int _selectedSubNavIndex = 0;
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _subNavItems = [
    '🚀 로켓배송',
    '🥗 로켓프레시',
    '📦 2026 베스트',
    '🏷️ 골드박스',
    '✨ 와우회원할인',
    '🎫 기획전/쿠폰',
    '✈️ 로켓직구',
  ];

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
      color: const Color(0xFFF0F0F0),
      child: Column(
        children: [
          // 1. Top Utility Header
          _buildTopUtilityBar(),

          // 2. Main GNB Header (Logo, Search, User/Cart)
          _buildMainGnbHeader(),

          // 3. Sub Nav Menu
          _buildSubNavBar(),

          // 4. Scrollable Main Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Hero Banner Carousel
                  _buildHeroBanner(),
                  const SizedBox(height: 20),

                  // Section 1: Today's Discovery Grid
                  _buildSectionHeader('오늘의 발견', '와우회원을 위한 로켓배송 특가 추천 상품'),
                  const SizedBox(height: 12),
                  _buildProductGrid(),
                  const SizedBox(height: 30),

                  // Desktop Footer
                  _buildDesktopFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUtilityBar() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(bottom: BorderSide(color: Color(0xFFE9ECEF), width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.location_solid, size: 12, color: Color(0xFF666666)),
              const SizedBox(width: 4),
              Text(
                widget.config.userLocation,
                style: const TextStyle(color: Color(0xFF555555), fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            children: [
              _buildUtilityLink('로그인'),
              _buildUtilityDivider(),
              _buildUtilityLink('회원가입'),
              _buildUtilityDivider(),
              _buildUtilityLink('고객센터'),
              _buildUtilityDivider(),
              _buildUtilityLink('쿠팡플레이'),
              _buildUtilityDivider(),
              _buildUtilityLink('제휴마케팅'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        title,
        style: const TextStyle(color: Color(0xFF666666), fontSize: 11),
      ),
    );
  }

  Widget _buildUtilityDivider() {
    return Container(
      width: 1,
      height: 10,
      color: const Color(0xFFDCDCDC),
    );
  }

  Widget _buildMainGnbHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: const Color(0xFFFFFFFF),
      child: Row(
        children: [
          // Category Menu Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0073E9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: const [
                Icon(CupertinoIcons.bars, color: Color(0xFFFFFFFF), size: 16),
                SizedBox(width: 8),
                Text(
                  '카테고리',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Coupang Logo
          CoupangIcons.logo(height: 32),
          const SizedBox(width: 30),

          // Search Bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0073E9), width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  // Filter dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: const [
                        Text('전체', style: TextStyle(color: Color(0xFF333333), fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(CupertinoIcons.chevron_down, size: 11, color: Color(0xFF666666)),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 20, color: const Color(0xFFE0E0E0)),
                  // Search Input
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CupertinoTextField(
                        controller: _searchCtrl,
                        placeholder: '찾고 싶은 상품을 검색해보세요!',
                        placeholderStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                        decoration: null,
                        style: const TextStyle(color: Color(0xFF111111), fontSize: 13),
                        onSubmitted: (val) {
                          widget.onConfigChanged?.call(widget.config.copyWith(searchKeyword: val));
                        },
                      ),
                    ),
                  ),
                  // Search Button
                  Container(
                    width: 48,
                    height: double.infinity,
                    color: const Color(0xFF0073E9),
                    child: const Center(
                      child: Icon(CupertinoIcons.search, color: Color(0xFFFFFFFF), size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),

          // Right My Coupang & Cart Action
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.person, color: Color(0xFF333333), size: 22),
                  SizedBox(height: 2),
                  Text('마이쿠팡', style: TextStyle(color: Color(0xFF333333), fontSize: 11)),
                ],
              ),
              const SizedBox(width: 20),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.cart, color: Color(0xFF333333), size: 22),
                      SizedBox(height: 2),
                      Text('장바구니', style: TextStyle(color: Color(0xFF333333), fontSize: 11)),
                    ],
                  ),
                  if (widget.config.cartCount > 0)
                    Positioned(
                      top: -4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE60023),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${widget.config.cartCount}',
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubNavBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 0.8),
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
        ),
      ),
      child: Row(
        children: List.generate(_subNavItems.length, (idx) {
          final isSelected = _selectedSubNavIndex == idx;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _selectedSubNavIndex = idx;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: isSelected
                    ? const Border(bottom: BorderSide(color: Color(0xFF0073E9), width: 3))
                    : null,
              ),
              child: Text(
                _subNavItems[idx],
                style: TextStyle(
                  color: isSelected ? const Color(0xFF0073E9) : const Color(0xFF333333),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeroBanner() {
    final banner = widget.config.banners[_currentBannerIndex % widget.config.banners.length];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(banner.bgColorHex),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 360,
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF222B45)),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(banner.bgColorHex),
                    Color(banner.bgColorHex).withValues(alpha: 0.95),
                    const Color(0x00000000),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            // Banner Content
            Positioned(
              left: 32,
              top: 30,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0073E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      banner.tag,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    banner.subTitle,
                    style: const TextStyle(
                      color: Color(0xFFDDDDDD),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Left / Right Navigation Arrows
            Positioned(
              left: 12,
              top: 74,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentBannerIndex = (_currentBannerIndex - 1 + widget.config.banners.length) % widget.config.banners.length;
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0x66000000),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(CupertinoIcons.chevron_left, color: Color(0xFFFFFFFF), size: 16)),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 74,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentBannerIndex = (_currentBannerIndex + 1) % widget.config.banners.length;
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0x66000000),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(CupertinoIcons.chevron_right, color: Color(0xFFFFFFFF), size: 16)),
                ),
              ),
            ),
            // Pagination dots
            Positioned(
              right: 16,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_currentBannerIndex + 1} / ${widget.config.banners.length}',
                  style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
            ),
          ),
          const Spacer(),
          const Text(
            '더보기 >',
            style: TextStyle(
              color: Color(0xFF0073E9),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = widget.config.products;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate column count (3 to 5 based on available width)
          final crossAxisCount = (constraints.maxWidth / 220).floor().clamp(3, 5);
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.62,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(CoupangProductItem product) {
    return GestureDetector(
      onTap: () => widget.onSelectProduct?.call(product),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 0.8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
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
                      child: Icon(CupertinoIcons.photo, color: Color(0xFFCCCCCC), size: 36),
                    ),
                  ),
                ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Badge
                    CoupangIcons.badge(product.badgeType),
                    const SizedBox(height: 6),

                    // Price Block
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
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          _formatPrice(product.price),
                          style: const TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          '원',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (product.originalPrice > product.price) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${_formatPrice(product.originalPrice)}원',
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Delivery Notice
                    Text(
                      product.deliveryNotice,
                      style: const TextStyle(
                        color: Color(0xFF00891A),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating & Reviews
                    Row(
                      children: [
                        CoupangIcons.ratingStars(product.rating, size: 11),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 10,
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

  Widget _buildDesktopFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF333333),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '쿠팡(주) 사업자 정보',
            style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 13, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '상호명: 쿠팡(주) | 대표이사: 강한승, 박대준 | 사업자등록번호: 120-88-00767\n'
            '통신판매업신고: 2017-서울송파-0158 | 고객센터: 1577-7011 (365일 24시간 운영)\n'
            '주소: 서울특별시 송파구 송파대로 570 (신천동)',
            style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 11, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            'FictionScreen Custom Coupang Simulation. All trademarks belong to their respective owners.',
            style: TextStyle(color: Color(0xFF777777), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
