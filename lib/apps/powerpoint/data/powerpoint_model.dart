import 'package:flutter/material.dart';

class PowerPointKpi {
  String label;
  String value;
  String? subtext;
  Color? color;

  PowerPointKpi({
    required this.label,
    required this.value,
    this.subtext,
    this.color,
  });

  PowerPointKpi copyWith({
    String? label,
    String? value,
    String? subtext,
    Color? color,
  }) {
    return PowerPointKpi(
      label: label ?? this.label,
      value: value ?? this.value,
      subtext: subtext ?? this.subtext,
      color: color ?? this.color,
    );
  }
}

class PowerPointSlide {
  String slideNumber;
  String title;
  String subtitle;
  List<String> bullets;
  List<PowerPointKpi> kpis;
  String? confidentialBadge; // e.g. "TOP SECRET // LEVEL 5"
  Color? slideBgColor;
  String? sideNote;

  PowerPointSlide({
    required this.slideNumber,
    required this.title,
    this.subtitle = '',
    this.bullets = const [],
    this.kpis = const [],
    this.confidentialBadge,
    this.slideBgColor,
    this.sideNote,
  });

  PowerPointSlide copyWith({
    String? slideNumber,
    String? title,
    String? subtitle,
    List<String>? bullets,
    List<PowerPointKpi>? kpis,
    String? confidentialBadge,
    Color? slideBgColor,
    String? sideNote,
  }) {
    return PowerPointSlide(
      slideNumber: slideNumber ?? this.slideNumber,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      bullets: bullets ?? List.from(this.bullets),
      kpis: kpis ?? this.kpis.map((k) => k.copyWith()).toList(),
      confidentialBadge: confidentialBadge ?? this.confidentialBadge,
      slideBgColor: slideBgColor ?? this.slideBgColor,
      sideNote: sideNote ?? this.sideNote,
    );
  }
}

class PowerPointConfig {
  String presentationTitle;
  String author;
  List<PowerPointSlide> slides;
  int activeSlideIndex;
  bool isSlideShowMode;

  PowerPointConfig({
    this.presentationTitle = '프로젝트_아틀라스_극비IR_피칭덱.pptx',
    this.author = '미래신기술 R&D 총괄',
    required this.slides,
    this.activeSlideIndex = 0,
    this.isSlideShowMode = false,
  });

  PowerPointSlide get activeSlide => slides[activeSlideIndex];

  PowerPointConfig copyWith({
    String? presentationTitle,
    String? author,
    List<PowerPointSlide>? slides,
    int? activeSlideIndex,
    bool? isSlideShowMode,
  }) {
    return PowerPointConfig(
      presentationTitle: presentationTitle ?? this.presentationTitle,
      author: author ?? this.author,
      slides: slides ?? this.slides.map((s) => s.copyWith()).toList(),
      activeSlideIndex: activeSlideIndex ?? this.activeSlideIndex,
      isSlideShowMode: isSlideShowMode ?? this.isSlideShowMode,
    );
  }

  // -------------------------------------------------------------
  // 4대 웹소설/웹툰 특화 프리셋
  // -------------------------------------------------------------
  static PowerPointConfig defaultPreset() => techIrPreset();

  /// 1. 🚀 극비 신기술 투자 IR 피칭 덱
  static PowerPointConfig techIrPreset() {
    return PowerPointConfig(
      presentationTitle: '프로젝트_아틀라스_인공지능_마력코어_상용화IR.pptx',
      author: '미래신기술 R&D 총괄 강태현',
      slides: [
        PowerPointSlide(
          slideNumber: '1',
          title: 'PROJECT ATLAS\n차세대 인공지능 마력 반응로 상용화 계획',
          subtitle: '세계 최초 4세대 마나 코어 기반 영구 동력원 개발 및 양산 로드맵',
          confidentialBadge: 'CONFIDENTIAL // 1급 대외비 (열람제한)',
          bullets: [
            '기존 S급 마석 대비 에너지 전환 효율 1,480% 향상',
            '마력 역류 제어 인공지능 알고리즘 특허 14건 단독 출원',
            '글로벌 에너지 패러다임을 바꿀 궁극의 청정 마나 그리드 구축',
          ],
          kpis: [
            PowerPointKpi(label: '에너지 밀도', value: '48.5 GWh', subtext: '기존 대비 15배'),
            PowerPointKpi(label: '타겟 시장 규모', value: '₩45.2조원', subtext: '글로벌 발전 시장'),
            PowerPointKpi(label: '투자 유치 목표', value: '₩1,000억원', subtext: '지분율 12% 배정'),
          ],
        ),
        PowerPointSlide(
          slideNumber: '2',
          title: '핵심 기술: 양자 마력 결속 메커니즘 (Quantum Mana Fusion)',
          subtitle: '던전 브레이크 마력 파동을 안정적으로 전력망으로 변환하는 혁신 기술',
          confidentialBadge: '국가 핵심 전략 기술 지정',
          bullets: [
            '핵심 코어 내 마력 임계치 도달 시 자동 냉각 감쇄 필드 가동',
            'S급 헌터의 마나 방출량에 필적하는 단일 발전 유닛 소형화 성공',
            '주요 3대 대기업 컨소시엄 납품 의향서(LOI) 체결 완료',
          ],
          kpis: [
            PowerPointKpi(label: '출력 안정도', value: '99.98%', subtext: '무중단 연속 가동 720h'),
            PowerPointKpi(label: '원가 절감율', value: '-68.4%', subtext: '기존 화석/원자력 대비'),
          ],
        ),
        PowerPointSlide(
          slideNumber: '3',
          title: '사업화 및 글로벌 독점 점유율 목표 (2026-2030)',
          subtitle: '수도권 마나 시티 시범 가동을 시작으로 아시아-태평양 독점 공급',
          bullets: [
            '2026 Q4: 판교 제3테크노밸리 제1호 상업 발전소 완공',
            '2027 Q2: 미국/일본 국방성 방호 쉴드 전력망 수출 계약',
            '2028: 글로벌 나스닥(NASDAQ) 상장 및 시가총액 10조원 달성',
          ],
          kpis: [
            PowerPointKpi(label: '2027 예상 매출', value: '₩1조 2,000억', subtext: '영업이익률 42%'),
            PowerPointKpi(label: '상장 목표 밸류', value: '₩12.5조원', subtext: '유니콘 등극'),
          ],
        ),
      ],
    );
  }

  /// 2. 🚨 국가 비상사태 / 괴담 재난 대응 브리핑
  static PowerPointConfig emergencyBriefingPreset() {
    return PowerPointConfig(
      presentationTitle: '수도권_10등급_게이트_비상계엄_대응전략.pptx',
      author: '대통령실 국가안보실 / 합동참모본부',
      slides: [
        PowerPointSlide(
          slideNumber: '1',
          title: '국가 비상사태 선포 및 수도권 사수 작전',
          subtitle: '도심 10등급 게이트 발생에 따른 전방위 결전 대응 계획',
          confidentialBadge: 'TOP SECRET // 국가 1급 비밀',
          slideBgColor: const Color(0xFF1E1E1E),
          bullets: [
            '서울 중심부 반경 15km 전역 주민 강제 소개령 및 벙커 대피 발령',
            '대한민국 전역 S급/A급 공인 헌터 총동원 징집 영장 발부',
            '최악의 상황(돌파 시) 전술 마나 탄두 공격 사전 승인 요청',
          ],
          kpis: [
            PowerPointKpi(label: '경보 등급', value: 'DEFCON 1', subtext: '국가 최고 비상', color: Colors.red),
            PowerPointKpi(label: '징집 헌터 수', value: '1,420명', subtext: '전투 가용 인원'),
            PowerPointKpi(label: '예상 사상자', value: '최소화 목표', subtext: '골든타임 6시간'),
          ],
        ),
        PowerPointSlide(
          slideNumber: '2',
          title: '3단계 방어선 구축 및 공략 편제',
          subtitle: '광화문 1차 저지선, 한강 이남 2차 결전선, 수도권 외곽 차단선',
          confidentialBadge: 'TOP SECRET',
          bullets: [
            '1선 (최전방): 국방부 육군 기동군단 + S급 헌터 타격대',
            '2선 (후방 지원): 원거리 마도사 포병대 집중 포격 지원',
            '결전 병기: 비밀리에 양성된 특수 각성자 부대 긴급 투입',
          ],
          kpis: [
            PowerPointKpi(label: '저지 성공률', value: '82.4%', subtext: '수석 전략관 시뮬레이션'),
            PowerPointKpi(label: '작전 개시', value: 'D-Day 06:00', subtext: '전면 총공세'),
          ],
        ),
      ],
    );
  }

  /// 3. 🏛️ 재벌 그룹 후계 구도 및 적대적 M&A 작전
  static PowerPointConfig conglomerateMaPreset() {
    return PowerPointConfig(
      presentationTitle: '○○그룹_경영권_방어_및_적대적인수_로드맵.pptx',
      author: '전략기획총괄 TF팀',
      slides: [
        PowerPointSlide(
          slideNumber: '1',
          title: '○○그룹 경영권 장악 및 지분 매집 전략',
          subtitle: '주주총회 표 대결 승리를 위한 우호 지분 확보 및 해외 펀드 연대',
          confidentialBadge: '대외비 (임원 외 열람 금지)',
          bullets: [
            '총수 일가 내부 분쟁 틈타 사모펀드(PEF) 연합 28.5% 지분 확보',
            '국민연금 의결권 찬성표 유치를 위한 ESG 및 지배구조 개선안 제시',
            '현 경영진의 횡령·배임 혐의 검찰 고발 및 여론전 동시 개시',
          ],
          kpis: [
            PowerPointKpi(label: '확보 우호 지분', value: '44.8%', subtext: '승리 기준 50%'),
            PowerPointKpi(label: '소요 M&A 자금', value: '₩2조 4,000억', subtext: '신디케이트 론 완료'),
            PowerPointKpi(label: 'D-Day 주총', value: '2026. 03. 27', subtext: '운명의 날'),
          ],
        ),
      ],
    );
  }

  /// 4. ⚔️ S급 레이드 공략 작전 브리핑
  static PowerPointConfig raidBriefingPreset() {
    return PowerPointConfig(
      presentationTitle: '제8구역_고대룡의둥지_S급레이드_공략작전.pptx',
      author: '최정예 공격대 전술참모',
      slides: [
        PowerPointSlide(
          slideNumber: '1',
          title: '제8구역 「화염룡 이그니스」 토벌 작전 브리핑',
          subtitle: '전멸 방지를 위한 3페이즈별 핵심 공략 및 포지셔닝 가이드',
          confidentialBadge: '길드 극비 작전 문서',
          bullets: [
            '1페이즈 (100%~70%): 화염 브레스 유도 및 꼬리 치기 회피',
            '2페이즈 (70%~30%): 비행 상태 용린 보호막 파괴 및 마력 사슬 구속',
            '3페이즈 (30%~0%): 광폭화 전멸기 발동 전 극딜 버스트 (30초 한계)',
          ],
          kpis: [
            PowerPointKpi(label: '공격대 인원', value: '24명 정예', subtext: 'S급 8명, A급 16명'),
            PowerPointKpi(label: '예상 소요 시간', value: '45분', subtext: '포션 소모 한계선'),
            PowerPointKpi(label: '성공 보상액', value: '₩1,200억원', subtext: '아티팩트 경매 제외'),
          ],
        ),
      ],
    );
  }
}
