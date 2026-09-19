import 'package:flutter/material.dart';

class ExcelCell {
  String value;
  bool isBold;
  Color? textColor;
  Color? bgColor;
  TextAlign align;
  bool isHeader;

  ExcelCell({
    required this.value,
    this.isBold = false,
    this.textColor,
    this.bgColor,
    this.align = TextAlign.left,
    this.isHeader = false,
  });

  ExcelCell copyWith({
    String? value,
    bool? isBold,
    Color? textColor,
    Color? bgColor,
    TextAlign? align,
    bool? isHeader,
  }) {
    return ExcelCell(
      value: value ?? this.value,
      isBold: isBold ?? this.isBold,
      textColor: textColor ?? this.textColor,
      bgColor: bgColor ?? this.bgColor,
      align: align ?? this.align,
      isHeader: isHeader ?? this.isHeader,
    );
  }
}

class ExcelSheet {
  String name;
  int rowCount;
  int colCount;
  Map<String, ExcelCell> cells; // "A1", "B2" etc.
  List<double> colWidths;

  ExcelSheet({
    required this.name,
    this.rowCount = 35,
    this.colCount = 10,
    required this.cells,
    List<double>? colWidths,
  }) : colWidths = colWidths ?? List.filled(colCount, 120.0);

  ExcelCell? getCell(String key) => cells[key];

  ExcelSheet copyWith({
    String? name,
    int? rowCount,
    int? colCount,
    Map<String, ExcelCell>? cells,
    List<double>? colWidths,
  }) {
    return ExcelSheet(
      name: name ?? this.name,
      rowCount: rowCount ?? this.rowCount,
      colCount: colCount ?? this.colCount,
      cells: cells ?? Map.from(this.cells),
      colWidths: colWidths ?? List.from(this.colWidths),
    );
  }
}

class ExcelConfig {
  String fileName;
  String author;
  List<ExcelSheet> sheets;
  int activeSheetIndex;
  String selectedCellKey;
  String formulaText;
  String statusMessage;
  String sumText;
  String avgText;
  String countText;

  ExcelConfig({
    this.fileName = '비자금_자금집행내역서_대외비.xlsx',
    this.author = '재무관리본부 비밀자금팀',
    required this.sheets,
    this.activeSheetIndex = 0,
    this.selectedCellKey = 'D5',
    this.formulaText = '=SUM(D2:D12)*1.15',
    this.statusMessage = '준비',
    this.sumText = '₩142,500,000,000',
    this.avgText = '₩11,875,000,000',
    this.countText = '12',
  });

  ExcelSheet get activeSheet => sheets[activeSheetIndex];

  ExcelConfig copyWith({
    String? fileName,
    String? author,
    List<ExcelSheet>? sheets,
    int? activeSheetIndex,
    String? selectedCellKey,
    String? formulaText,
    String? statusMessage,
    String? sumText,
    String? avgText,
    String? countText,
  }) {
    return ExcelConfig(
      fileName: fileName ?? this.fileName,
      author: author ?? this.author,
      sheets: sheets ?? this.sheets.map((s) => s.copyWith()).toList(),
      activeSheetIndex: activeSheetIndex ?? this.activeSheetIndex,
      selectedCellKey: selectedCellKey ?? this.selectedCellKey,
      formulaText: formulaText ?? this.formulaText,
      statusMessage: statusMessage ?? this.statusMessage,
      sumText: sumText ?? this.sumText,
      avgText: avgText ?? this.avgText,
      countText: countText ?? this.countText,
    );
  }

  // -------------------------------------------------------------
  // 4대 웹소설/웹툰 특화 프리셋
  // -------------------------------------------------------------
  static ExcelConfig defaultPreset() => slushFundPreset();

  /// 1. 🕵️ 재벌가 비밀 자금 회계 장부 (비자금/페이퍼컴퍼니)
  static ExcelConfig slushFundPreset() {
    final cells = <String, ExcelCell>{
      // Headers (Row 1)
      'A1': ExcelCell(value: '순번', isBold: true, isHeader: true, align: TextAlign.center, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'B1': ExcelCell(value: '집행 일자', isBold: true, isHeader: true, align: TextAlign.center, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'C1': ExcelCell(value: '수취 페이퍼컴퍼니/차명계좌', isBold: true, isHeader: true, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'D1': ExcelCell(value: '집행 금액 (원화)', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'E1': ExcelCell(value: '경유 은행 (스위스/케이맨)', isBold: true, isHeader: true, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'F1': ExcelCell(value: '비고 / 특검 수사 리스크', isBold: true, isHeader: true, bgColor: const Color(0xFF107C41), textColor: Colors.white),

      // Row 2
      'A2': ExcelCell(value: '1', align: TextAlign.center),
      'B2': ExcelCell(value: '2026-01-14', align: TextAlign.center),
      'C2': ExcelCell(value: 'Apex Global Holdings (BVI)', isBold: true),
      'D2': ExcelCell(value: '₩35,000,000,000', align: TextAlign.right, isBold: true),
      'E2': ExcelCell(value: 'UBS Zurich Secret Acct #492'),
      'F2': ExcelCell(value: '총수 장남 해외 지분 매입용 (극비)', textColor: const Color(0xFFD32F2F), isBold: true),

      // Row 3
      'A3': ExcelCell(value: '2', align: TextAlign.center),
      'B3': ExcelCell(value: '2026-02-03', align: TextAlign.center),
      'C3': ExcelCell(value: 'SilverStone Partners Ltd.', isBold: true),
      'D3': ExcelCell(value: '₩18,500,000,000', align: TextAlign.right, isBold: true),
      'E3': ExcelCell(value: 'Credit Suisse Cayman #109'),
      'F3': ExcelCell(value: '정관계 로비 및 사외이사 무마비', textColor: const Color(0xFFD32F2F), isBold: true),

      // Row 4
      'A4': ExcelCell(value: '3', align: TextAlign.center),
      'B4': ExcelCell(value: '2026-03-12', align: TextAlign.center),
      'C4': ExcelCell(value: '○○물산 위장 무역 리베이트', isBold: true),
      'D4': ExcelCell(value: '₩42,000,000,000', align: TextAlign.right, isBold: true),
      'E4': ExcelCell(value: 'Bank of Singapore Private'),
      'F4': ExcelCell(value: '세무조사 무마용 현금성 채권 전달', textColor: const Color(0xFFE65100), isBold: true),

      // Row 5
      'A5': ExcelCell(value: '4', align: TextAlign.center),
      'B5': ExcelCell(value: '2026-04-20', align: TextAlign.center),
      'C5': ExcelCell(value: 'Golden Gate Trust 차명신탁', isBold: true),
      'D5': ExcelCell(value: '₩27,000,000,000', align: TextAlign.right, isBold: true),
      'E5': ExcelCell(value: 'Liechtenstein Private Vault'),
      'F5': ExcelCell(value: '경영권 승계 합병 비율 조작 자금', textColor: const Color(0xFFD32F2F), isBold: true),

      // Row 6
      'A6': ExcelCell(value: '5', align: TextAlign.center),
      'B6': ExcelCell(value: '2026-05-18', align: TextAlign.center),
      'C6': ExcelCell(value: '법무법인 ○○ 특별자문료', isBold: true),
      'D6': ExcelCell(value: '₩20,000,000,000', align: TextAlign.right, isBold: true),
      'E6': ExcelCell(value: 'KEB하나 특수신탁 계좌'),
      'F6': ExcelCell(value: '검찰 특수부 압수수색 사전 차단용', textColor: const Color(0xFFD32F2F), isBold: true),

      // Row 7 (Total)
      'A7': ExcelCell(value: '합계', isBold: true, align: TextAlign.center, bgColor: const Color(0xFFE8F5E9)),
      'B7': ExcelCell(value: '-', align: TextAlign.center, bgColor: const Color(0xFFE8F5E9)),
      'C7': ExcelCell(value: '총 5건 해외 페이퍼컴퍼니 송금', isBold: true, bgColor: const Color(0xFFE8F5E9)),
      'D7': ExcelCell(value: '₩142,500,000,000', align: TextAlign.right, isBold: true, textColor: const Color(0xFFD32F2F), bgColor: const Color(0xFFE8F5E9)),
      'E7': ExcelCell(value: '전액 해외 비밀계좌 분산 완료', bgColor: const Color(0xFFE8F5E9)),
      'F7': ExcelCell(value: '※ 열람 즉시 파기 요망 (1급 대외비)', isBold: true, textColor: const Color(0xFFD32F2F), bgColor: const Color(0xFFE8F5E9)),
    };

    return ExcelConfig(
      fileName: '그룹_총수일가_비밀자금집행부_대외비.xlsx',
      author: '미래전략실 재무팀',
      sheets: [
        ExcelSheet(name: '2026 비자금 내역', cells: cells, colWidths: [60, 110, 220, 160, 210, 240]),
        ExcelSheet(name: '스위스 비밀계좌 잔고', cells: {}, colWidths: [60, 120, 200, 150]),
        ExcelSheet(name: '정관계 리베이트 리스트', cells: {}, colWidths: [60, 120, 200, 150]),
      ],
      selectedCellKey: 'D7',
      formulaText: '=SUM(D2:D6)',
      sumText: '₩142,500,000,000',
      avgText: '₩28,500,000,000',
      countText: '5',
    );
  }

  /// 2. ⚔️ S급 헌터 레이드 공략 보상 정산서
  static ExcelConfig hunterRaidPreset() {
    final cells = <String, ExcelCell>{
      'A1': ExcelCell(value: '순번', isBold: true, isHeader: true, align: TextAlign.center, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'B1': ExcelCell(value: '던전 전리품 / 아티팩트', isBold: true, isHeader: true, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'C1': ExcelCell(value: '등급 (Grade)', isBold: true, isHeader: true, align: TextAlign.center, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'D1': ExcelCell(value: '수량', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'E1': ExcelCell(value: '경매 낙찰가 (원)', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'F1': ExcelCell(value: '분배 대상자 및 특이사항', isBold: true, isHeader: true, bgColor: const Color(0xFF107C41), textColor: Colors.white),

      'A2': ExcelCell(value: '1', align: TextAlign.center),
      'B2': ExcelCell(value: '고대 화염용의 심장 (마석)', isBold: true),
      'C2': ExcelCell(value: 'S급 (최상급)', align: TextAlign.center, isBold: true, textColor: const Color(0xFFE65100)),
      'D2': ExcelCell(value: '1개', align: TextAlign.right),
      'E2': ExcelCell(value: '₩45,000,000,000', align: TextAlign.right, isBold: true),
      'F2': ExcelCell(value: '공격대장 메인 딜러 우선 분배', isBold: true),

      'A3': ExcelCell(value: '2', align: TextAlign.center),
      'B3': ExcelCell(value: '멸망의 용기사 건틀릿', isBold: true),
      'C3': ExcelCell(value: 'S급 (유니크)', align: TextAlign.center, isBold: true, textColor: const Color(0xFF9C27B0)),
      'D3': ExcelCell(value: '1개', align: TextAlign.right),
      'E3': ExcelCell(value: '₩28,500,000,000', align: TextAlign.right, isBold: true),
      'F3': ExcelCell(value: 'F급 짐꾼 단독 킬 기여도 인정 (경매 낙찰)', textColor: const Color(0xFF107C41), isBold: true),

      'A4': ExcelCell(value: '3', align: TextAlign.center),
      'B4': ExcelCell(value: '용혈 정수 엘릭서 원액', isBold: true),
      'C4': ExcelCell(value: 'A급 (영약)', align: TextAlign.center, isBold: true, textColor: const Color(0xFF1976D2)),
      'D4': ExcelCell(value: '12병', align: TextAlign.right),
      'E4': ExcelCell(value: '₩14,400,000,000', align: TextAlign.right, isBold: true),
      'F4': ExcelCell(value: '힐러진 및 탱커 생존자 4:6 분할', isBold: true),

      'A5': ExcelCell(value: '4', align: TextAlign.center),
      'B5': ExcelCell(value: '용비늘 아다만티움 장갑판', isBold: true),
      'C5': ExcelCell(value: 'A급 (특수광물)', align: TextAlign.center, isBold: true, textColor: const Color(0xFF1976D2)),
      'D5': ExcelCell(value: '85kg', align: TextAlign.right),
      'E5': ExcelCell(value: '₩8,500,000,000', align: TextAlign.right, isBold: true),
      'F5': ExcelCell(value: '국가 헌터협회 납품 지정', isBold: true),

      'A6': ExcelCell(value: '합계', isBold: true, align: TextAlign.center, bgColor: const Color(0xFFE8F5E9)),
      'B6': ExcelCell(value: '레이드 총 정산액 (길드 수수료 10% 제외 전)', isBold: true, bgColor: const Color(0xFFE8F5E9)),
      'C6': ExcelCell(value: 'S급 게이트', align: TextAlign.center, isBold: true, bgColor: const Color(0xFFE8F5E9)),
      'D6': ExcelCell(value: '-', align: TextAlign.right, bgColor: const Color(0xFFE8F5E9)),
      'E6': ExcelCell(value: '₩96,400,000,000', align: TextAlign.right, isBold: true, textColor: const Color(0xFF107C41), bgColor: const Color(0xFFE8F5E9)),
      'F6': ExcelCell(value: '세금 3.3% 원천징수 후 개인 계좌 이체 완료', bgColor: const Color(0xFFE8F5E9)),
    };

    return ExcelConfig(
      fileName: '제7구역_S급_게이트_전리품_정산서.xlsx',
      author: '백호길드 정산관리실',
      sheets: [
        ExcelSheet(name: '전리품 정산표', cells: cells, colWidths: [60, 220, 110, 80, 160, 260]),
        ExcelSheet(name: '부상자 위로금 명단', cells: {}, colWidths: [60, 120, 180, 150]),
      ],
      selectedCellKey: 'E6',
      formulaText: '=SUM(E2:E5)',
      sumText: '₩96,400,000,000',
      avgText: '₩24,100,000,000',
      countText: '4',
    );
  }

  /// 3. 📉 코인/선물 포지션 강제 청산 내역서
  static ExcelConfig coinPreset() {
    final cells = <String, ExcelCell>{
      'A1': ExcelCell(value: '종목 (Pair)', isBold: true, isHeader: true, align: TextAlign.center, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'B1': ExcelCell(value: '포지션 / 배율', isBold: true, isHeader: true, align: TextAlign.center, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'C1': ExcelCell(value: '진입 가격 (Entry)', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'D1': ExcelCell(value: '청산 가격 (Liq)', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'E1': ExcelCell(value: '투자 원금 (USDT)', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'F1': ExcelCell(value: '확정 손익 (PnL)', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),

      'A2': ExcelCell(value: 'BTC/USDT', isBold: true, align: TextAlign.center),
      'B2': ExcelCell(value: 'SHORT 50X', align: TextAlign.center, textColor: const Color(0xFF1976D2), isBold: true),
      'C2': ExcelCell(value: '\$64,200.00', align: TextAlign.right),
      'D2': ExcelCell(value: '\$65,480.00', align: TextAlign.right),
      'E2': ExcelCell(value: '\$500,000', align: TextAlign.right),
      'F2': ExcelCell(value: '-\$500,000 (-100.0%) [강제청산]', align: TextAlign.right, textColor: const Color(0xFFD32F2F), isBold: true),

      'A3': ExcelCell(value: 'ETH/USDT', isBold: true, align: TextAlign.center),
      'B3': ExcelCell(value: 'LONG 75X', align: TextAlign.center, textColor: const Color(0xFFD32F2F), isBold: true),
      'C3': ExcelCell(value: '\$3,480.50', align: TextAlign.right),
      'D3': ExcelCell(value: '\$3,434.00', align: TextAlign.right),
      'E3': ExcelCell(value: '\$450,000', align: TextAlign.right),
      'F3': ExcelCell(value: '-\$450,000 (-100.0%) [강제청산]', align: TextAlign.right, textColor: const Color(0xFFD32F2F), isBold: true),

      'A4': ExcelCell(value: 'SOL/USDT', isBold: true, align: TextAlign.center),
      'B4': ExcelCell(value: 'LONG 100X', align: TextAlign.center, textColor: const Color(0xFFD32F2F), isBold: true),
      'C4': ExcelCell(value: '\$148.20', align: TextAlign.right),
      'D4': ExcelCell(value: '\$146.70', align: TextAlign.right),
      'E4': ExcelCell(value: '\$320,000', align: TextAlign.right),
      'F4': ExcelCell(value: '-\$320,000 (-100.0%) [강제청산]', align: TextAlign.right, textColor: const Color(0xFFD32F2F), isBold: true),

      'A5': ExcelCell(value: '총 손실액', isBold: true, align: TextAlign.center, bgColor: const Color(0xFFFFEBEE)),
      'B5': ExcelCell(value: '전 포지션 마진콜', align: TextAlign.center, isBold: true, textColor: const Color(0xFFD32F2F), bgColor: const Color(0xFFFFEBEE)),
      'C5': ExcelCell(value: '-', align: TextAlign.right, bgColor: const Color(0xFFFFEBEE)),
      'D5': ExcelCell(value: '잔고: \$0.14', align: TextAlign.right, isBold: true, bgColor: const Color(0xFFFFEBEE)),
      'E5': ExcelCell(value: '\$1,270,000', align: TextAlign.right, isBold: true, bgColor: const Color(0xFFFFEBEE)),
      'F5': ExcelCell(value: '-\$1,270,000 (₩17억 2천만 증발)', align: TextAlign.right, textColor: const Color(0xFFD32F2F), isBold: true, bgColor: const Color(0xFFFFEBEE)),
    };

    return ExcelConfig(
      fileName: '바이낸스_선물계좌_마진콜_청산보고서.xlsx',
      author: '트레이더_개미의눈물',
      sheets: [
        ExcelSheet(name: '선물 청산 내역', cells: cells, colWidths: [110, 120, 140, 140, 140, 260]),
      ],
      selectedCellKey: 'F5',
      formulaText: '=SUM(F2:F4)',
      sumText: '-\$1,270,000',
      avgText: '-\$423,333',
      countText: '3',
    );
  }

  /// 4. 🚀 스타트업 캡테이블 및 매출 성장표
  static ExcelConfig startupPreset() {
    final cells = <String, ExcelCell>{
      'A1': ExcelCell(value: '주주명 / 투자사', isBold: true, isHeader: true, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'B1': ExcelCell(value: '주식 종류', isBold: true, isHeader: true, align: TextAlign.center, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'C1': ExcelCell(value: '보유 주식 수', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'D1': ExcelCell(value: '지분율 (%)', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'E1': ExcelCell(value: '투자 유치액', isBold: true, isHeader: true, align: TextAlign.right, bgColor: const Color(0xFF107C41), textColor: Colors.white),
      'F1': ExcelCell(value: '비고 / 의결권', isBold: true, isHeader: true, bgColor: const Color(0xFF107C41), textColor: Colors.white),

      'A2': ExcelCell(value: '대표이사 강태현 (창업자)', isBold: true),
      'B2': ExcelCell(value: '보통주', align: TextAlign.center),
      'C2': ExcelCell(value: '5,200,000주', align: TextAlign.right),
      'D2': ExcelCell(value: '52.0%', align: TextAlign.right, isBold: true, textColor: const Color(0xFF107C41)),
      'E2': ExcelCell(value: '₩50,000,000 (자본금)', align: TextAlign.right),
      'F2': ExcelCell(value: '단독 경영권 및 거부권(Veto) 보유', isBold: true),

      'A3': ExcelCell(value: '알토스 벤처 캐피탈 (시리즈A)', isBold: true),
      'B3': ExcelCell(value: '상환전환우선주 (RCPS)', align: TextAlign.center),
      'C3': ExcelCell(value: '2,000,000주', align: TextAlign.right),
      'D3': ExcelCell(value: '20.0%', align: TextAlign.right, isBold: true),
      'E3': ExcelCell(value: '₩6,000,000,000', align: TextAlign.right),
      'F3': ExcelCell(value: '포스트 밸류 300억 인정', isBold: true),

      'A4': ExcelCell(value: '소프트뱅크 비전펀드 (시리즈B)', isBold: true),
      'B4': ExcelCell(value: '전환우선주 (CPS)', align: TextAlign.center),
      'C4': ExcelCell(value: '1,800,000주', align: TextAlign.right),
      'D4': ExcelCell(value: '18.0%', align: TextAlign.right, isBold: true),
      'E4': ExcelCell(value: '₩18,000,000,000', align: TextAlign.right),
      'F4': ExcelCell(value: '포스트 밸류 1,000억 (예비 유니콘)', textColor: const Color(0xFF1976D2), isBold: true),

      'A5': ExcelCell(value: '임직원 스톡옵션 풀', isBold: true),
      'B5': ExcelCell(value: '신주인수권', align: TextAlign.center),
      'C5': ExcelCell(value: '1,000,000주', align: TextAlign.right),
      'D5': ExcelCell(value: '10.0%', align: TextAlign.right, isBold: true),
      'E5': ExcelCell(value: '-', align: TextAlign.right),
      'F5': ExcelCell(value: '핵심 AI 개발진 4년 베스팅 조건', isBold: true),

      'A6': ExcelCell(value: '합계', isBold: true, align: TextAlign.center, bgColor: const Color(0xFFE8F5E9)),
      'B6': ExcelCell(value: '총 발행 주식수', align: TextAlign.center, isBold: true, bgColor: const Color(0xFFE8F5E9)),
      'C6': ExcelCell(value: '10,000,000주', align: TextAlign.right, isBold: true, bgColor: const Color(0xFFE8F5E9)),
      'D6': ExcelCell(value: '100.0%', align: TextAlign.right, isBold: true, bgColor: const Color(0xFFE8F5E9)),
      'E6': ExcelCell(value: '₩24,050,000,000', align: TextAlign.right, isBold: true, textColor: const Color(0xFF107C41), bgColor: const Color(0xFFE8F5E9)),
      'F6': ExcelCell(value: '기업가치 1,000억원 공식 평가', isBold: true, bgColor: const Color(0xFFE8F5E9)),
    };

    return ExcelConfig(
      fileName: '넥스트코어_CapTable_투자유치현황.xlsx',
      author: '전략기획실',
      sheets: [
        ExcelSheet(name: '주주명부 (Cap Table)', cells: cells, colWidths: [220, 150, 120, 100, 160, 240]),
        ExcelSheet(name: '월별 MRR 성장추이', cells: {}, colWidths: [100, 120, 140, 140]),
      ],
      selectedCellKey: 'E6',
      formulaText: '=SUM(E2:E5)',
      sumText: '₩24,050,000,000',
      avgText: '₩8,016,666,666',
      countText: '4',
    );
  }
}
