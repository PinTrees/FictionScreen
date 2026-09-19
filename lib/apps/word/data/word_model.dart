import 'package:flutter/material.dart';

enum WordParagraphType {
  title,
  subtitle,
  heading,
  body,
  clause,
  redacted,
  signature,
}

class WordParagraph {
  WordParagraphType type;
  String text;
  bool isBold;
  bool isRedacted; // 블랙 마스킹 바 (REDACTED) 처리
  TextAlign align;
  String? clauseNumber; // e.g. "제1조 (목적)"

  WordParagraph({
    this.type = WordParagraphType.body,
    required this.text,
    this.isBold = false,
    this.isRedacted = false,
    this.align = TextAlign.left,
    this.clauseNumber,
  });

  WordParagraph copyWith({
    WordParagraphType? type,
    String? text,
    bool? isBold,
    bool? isRedacted,
    TextAlign? align,
    String? clauseNumber,
  }) {
    return WordParagraph(
      type: type ?? this.type,
      text: text ?? this.text,
      isBold: isBold ?? this.isBold,
      isRedacted: isRedacted ?? this.isRedacted,
      align: align ?? this.align,
      clauseNumber: clauseNumber ?? this.clauseNumber,
    );
  }
}

class WordConfig {
  String documentTitle;
  String documentCode; // e.g. "DOC-2026-TOPSECRET-049"
  String department;
  String author;
  String issueDate;
  String? confidentialStamp; // e.g. "1급 기밀 // TOP SECRET"
  String? officialSealName; // e.g. "대한민국 헌터관리국인"
  List<WordParagraph> paragraphs;
  int pageCount;
  int wordCount;

  WordConfig({
    this.documentTitle = '국가 1급 기밀 취급 인가 보고서',
    this.documentCode = 'KC-2026-TOPSECRET-884',
    this.department = '국가정보원 특수공작대 / 헌터관리국',
    this.author = '수석 분석관 강태현',
    this.issueDate = '2026년 9월 19일',
    this.confidentialStamp = '1급 비밀 (TOP SECRET)',
    this.officialSealName = '대한민국 헌터관리국장 인',
    required this.paragraphs,
    this.pageCount = 1,
    this.wordCount = 1420,
  });

  WordConfig copyWith({
    String? documentTitle,
    String? documentCode,
    String? department,
    String? author,
    String? issueDate,
    String? confidentialStamp,
    String? officialSealName,
    List<WordParagraph>? paragraphs,
    int? pageCount,
    int? wordCount,
  }) {
    return WordConfig(
      documentTitle: documentTitle ?? this.documentTitle,
      documentCode: documentCode ?? this.documentCode,
      department: department ?? this.department,
      author: author ?? this.author,
      issueDate: issueDate ?? this.issueDate,
      confidentialStamp: confidentialStamp ?? this.confidentialStamp,
      officialSealName: officialSealName ?? this.officialSealName,
      paragraphs: paragraphs ?? this.paragraphs.map((p) => p.copyWith()).toList(),
      pageCount: pageCount ?? this.pageCount,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  // -------------------------------------------------------------
  // 4대 웹소설/웹툰 특화 프리셋
  // -------------------------------------------------------------
  static WordConfig defaultPreset() => topSecretPreset();

  /// 1. 🔒 1급 국가 기밀 취급 보고서 (TOP SECRET)
  static WordConfig topSecretPreset() {
    return WordConfig(
      documentTitle: '각성자 신체 개조 및 인공 마력 핵 이식 결과 보고서',
      documentCode: 'NIS-2026-CLASSIFIED-007',
      department: '국가정보원 해외공작국 / 특수연구소',
      author: '책임연구원 닥터 헬만',
      issueDate: '2026년 09월 14일',
      confidentialStamp: '1급 비밀 // TOP SECRET',
      officialSealName: '국가정보원장 인',
      paragraphs: [
        WordParagraph(
          type: WordParagraphType.heading,
          text: '1. 피험체 식별 코드 및 각성 배경',
          isBold: true,
        ),
        WordParagraph(
          text: '본 프로젝트는 2026년 수도권 7등급 게이트 붕괴 당시 유일하게 생존한 일반인 F급 짐꾼 피험체(코드명: K)를 대상으로 진행된 비인가 마나 핵 결속 실험에 관한 최종 경과 보고임.',
        ),
        WordParagraph(
          type: WordParagraphType.redacted,
          text: '※ 경고: 피험체의 체내 마력량은 이미 공인 랭킹 1위 S급 헌터를 300% 이상 상회하며, 마력 폭주 시 서울 전역 반경 20km 소멸 가능성 상존함.',
          isRedacted: true, // 블랙 마스킹 연출!
        ),
        WordParagraph(
          type: WordParagraphType.heading,
          text: '2. 3단계 인공 코어 결속 결과',
          isBold: true,
        ),
        WordParagraph(
          text: '고대 유물 「용혈석」 파편 3기를 심장 부근에 성공적으로 안착시켰으며, 신경계 거부 반응은 0.02% 미만으로 통제되고 있음. 단, 피험체의 과거 기억 소거 조치가 불완전하여 감정 고조 시 통제 불능 상태에 진입할 위험이 있음.',
        ),
        WordParagraph(
          type: WordParagraphType.clause,
          clauseNumber: '특약 제3호',
          text: '피험체 K가 본 연구소의 존재를 외부에 누설하거나 통제 구역을 이탈할 시, 뇌간에 매설된 나노 폭탄을 즉시 기폭시키는 것에 동의함.',
          isBold: true,
        ),
        WordParagraph(
          type: WordParagraphType.signature,
          text: '상기 보고 내용은 국가보안법 및 군사기밀보호법에 의거하여 엄격히 보호되며, 무단 복제 및 반출 시 사형 또는 무기징역에 처함.',
        ),
      ],
      pageCount: 2,
      wordCount: 1680,
    );
  }

  /// 2. 📜 경영권 포기 및 비밀 유지 서약서 (NDA)
  static WordConfig ndaPreset() {
    return WordConfig(
      documentTitle: '비자금 조성 관리 및 경영권 포기 각서',
      documentCode: 'LEGAL-2026-NDA-912',
      department: '○○그룹 회장 부속실 / 법무팀',
      author: '법무법인 율촌 담당 변호사',
      issueDate: '2026년 08월 21일',
      confidentialStamp: '절대 비밀 (EXTREME SECRET)',
      officialSealName: '○○그룹 회장 인',
      paragraphs: [
        WordParagraph(
          type: WordParagraphType.heading,
          text: '비밀 유지 및 민·형사상 이의 제기 포기 확약서',
          isBold: true,
          align: TextAlign.center,
        ),
        WordParagraph(
          text: '본 각서인(이하 "을")은 ○○그룹 총수 일가의 지시로 집행된 해외 페이퍼컴퍼니 자금 송금 및 비자금 1,400억원 조성에 관하여 평생 비밀을 유지할 것을 서약하며 아래 사항을 엄수한다.',
        ),
        WordParagraph(
          type: WordParagraphType.clause,
          clauseNumber: '제1조 (침묵의 의무)',
          text: '을은 검찰, 경찰, 금융감독원, 언론 등 어떠한 기관이나 제3자에게도 비밀 장부 및 차명 계좌의 실소유주에 관하여 일체 진술하지 아니한다.',
        ),
        WordParagraph(
          type: WordParagraphType.clause,
          clauseNumber: '제2조 (위약벌 및 손해배상)',
          text: '을이 본 서약서를 위반하여 진술하거나 비밀을 누설할 경우, 즉시 위약벌 금 1,000억원을 현금 배상하여야 하며 모든 민·형사상 책임을 단독으로 부담한다.',
          isBold: true,
        ),
        WordParagraph(
          type: WordParagraphType.signature,
          text: '2026년 08월 21일\n서약인 (을): 재무팀장 최민석 (인)\n수취인 (갑): ○○그룹 회장 비서실 (직인 생략)',
        ),
      ],
      pageCount: 1,
      wordCount: 890,
    );
  }

  /// 3. ⚖️ 재벌 총수 일가 주식 양도 계약서 및 비밀 유언장
  static WordConfig willPreset() {
    return WordConfig(
      documentTitle: '피상속인 지분 증여 및 경영권 승계 최종 유언 공증서',
      documentCode: 'NOTARY-2026-WILL-410',
      department: '대한공증인협회 인가 공증인가 한결',
      author: '공증담당 변호사 박진우',
      issueDate: '2026년 07월 10일',
      confidentialStamp: '공증 문서 // 열람 제한',
      officialSealName: '공증인가 한결 직인',
      paragraphs: [
        WordParagraph(
          type: WordParagraphType.heading,
          text: '경영권 및 차명 주식 100% 승계에 관한 유언 전문',
          isBold: true,
          align: TextAlign.center,
        ),
        WordParagraph(
          text: '본 공증인은 민법 제1068조에 의거하여 피상속인 ○○○ 회장의 구수 유언을 엄격히 녹취 및 공증하여 다음과 같이 기록함.',
        ),
        WordParagraph(
          type: WordParagraphType.clause,
          clauseNumber: '제1조 (핵심 지분의 귀속)',
          text: '장남 및 장녀의 모든 경영권을 박탈하며, 그룹 지주사 지분 38.5% 전량을 숨겨진 혼외자(막내 아들)에게 단독 상속한다.',
          isBold: true,
        ),
        WordParagraph(
          type: WordParagraphType.clause,
          clauseNumber: '제2조 (조건부 효력)',
          text: '본 유언장은 피상속인의 사망 선고 즉시 법원에 공탁되며, 어떠한 유류분 반환 청구 소송도 일체 허용하지 아니한다.',
        ),
      ],
      pageCount: 1,
      wordCount: 750,
    );
  }

  /// 4. ⚔️ 세계 헌터 협회 공인 S급 각성 인증서
  static WordConfig hunterCertPreset() {
    return WordConfig(
      documentTitle: '국제 공인 S급 헌터 자격 공인 증서',
      documentCode: 'WHA-2026-S-RANK-001',
      department: '세계헌터협회(WHA) 대한민국 지부',
      author: '협회장 송치열',
      issueDate: '2026년 09월 19일',
      confidentialStamp: 'OFFICIAL CERTIFICATE',
      officialSealName: '세계헌터협회 공인 직인',
      paragraphs: [
        WordParagraph(
          type: WordParagraphType.heading,
          text: 'S-RANK HUNTER LICENSE',
          isBold: true,
          align: TextAlign.center,
        ),
        WordParagraph(
          text: '성명: 강태현 (KANG TAE-HYUN)\n식별 번호: WHA-KR-2026-0919\n측정 마나 등급: S급 (OVERFLOW - 측정 한계치 초과)',
          isBold: true,
          align: TextAlign.center,
        ),
        WordParagraph(
          text: '위 사람은 헌터관리법 제12조 및 국제헌터조약에 의거하여 전 세계 0.001% 미만의 극소수에게만 부여되는 S급 헌터 자격을 정식 취득하였음을 공인함.',
        ),
        WordParagraph(
          type: WordParagraphType.clause,
          clauseNumber: '특전 1',
          text: '국가 비상사태 시 단독 군사 작전 지휘권 및 정당방위 살상 면책 특권 보유.',
          isBold: true,
        ),
        WordParagraph(
          type: WordParagraphType.clause,
          clauseNumber: '특전 2',
          text: '전 세계 190개국 무비자 출입국 및 외교관에 준하는 면책특권 부여.',
        ),
      ],
      pageCount: 1,
      wordCount: 620,
    );
  }
}
