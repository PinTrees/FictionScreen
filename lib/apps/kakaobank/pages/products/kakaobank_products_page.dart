import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KakaoBankProductsPage extends StatefulWidget {
  final VoidCallback? onApplyProduct;

  const KakaoBankProductsPage({super.key, this.onApplyProduct});

  @override
  State<KakaoBankProductsPage> createState() => _KakaoBankProductsPageState();
}

class _KakaoBankProductsPageState extends State<KakaoBankProductsPage> {
  String _selectedCategory = '예적금';

  final List<String> _categories = ['예적금', '대출', '카드', '투자/외환'];

  final Map<String, List<Map<String, String>>> _productsData = {
    '예적금': [
      {'title': '26주적금', 'desc': '매주 도전하는 저축의 즐거움, 캐릭터 스탬프', 'badge': '연 3.80%', 'icon': '🐱'},
      {'title': '세이프박스', 'desc': '하루만 맡겨도 연 2.0% 이자, 계좌 속 금고', 'badge': '연 2.00%', 'icon': '🔒'},
      {'title': '저금통', 'desc': '동전 알아서 척척, 10만원 모으기', 'badge': '연 8.00%', 'icon': '🐷'},
      {'title': '정기예금', 'desc': '목돈 굴리기, 복잡한 우대조건 없이', 'badge': '연 3.40%', 'icon': '💰'},
    ],
    '대출': [
      {'title': '비상금대출', 'desc': '직장/소득 상관없이 60초면 완료', 'badge': '최저 연 4.52%', 'icon': '⚡'},
      {'title': '마이너스 통장대출', 'desc': '쓴 만큼만 이자를 내는 편리함', 'badge': '최저 연 4.88%', 'icon': '💳'},
      {'title': '신용대출', 'desc': '중신용 고객도 든든하게 넉넉한 한도', 'badge': '최저 연 4.12%', 'icon': '🏦'},
    ],
    '카드': [
      {'title': '프렌즈 체크카드', 'desc': '라이언, 춘식이 디자인의 생활 캐시백', 'badge': '인기', 'icon': '🦁'},
      {'title': '모임 체크카드', 'desc': '모임통장 전용 간편 결제 카드', 'badge': '신규', 'icon': '👥'},
    ],
    '투자/외환': [
      {'title': '달러박스', 'desc': '수수료 없이 환전하고 보관하는 달러', 'badge': '환전수수료 0원', 'icon': '💵'},
      {'title': '펀드', 'desc': '1,000원부터 시작하는 똑똑한 투자', 'badge': 'AI 추천', 'icon': '📈'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentList = _productsData[_selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFF16161A),
              child: const Row(
                children: [
                  Text('상품 / 서비스', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // 카테고리 가로 스크롤 칩
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF131317),
              child: Row(
                children: _categories.map((cat) {
                  final isSel = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(color: isSel ? const Color(0xFF111111) : Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                      selected: isSel,
                      selectedColor: const Color(0xFFFEE500),
                      backgroundColor: const Color(0xFF222228),
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 상품 카드 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: currentList.length,
                itemBuilder: (context, index) {
                  final item = currentList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(item['icon']!, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(item['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEE500).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(item['badge']!, style: const TextStyle(color: Color(0xFFFEE500), fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(item['desc']!, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(CupertinoIcons.chevron_right, color: Colors.white24, size: 14),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
