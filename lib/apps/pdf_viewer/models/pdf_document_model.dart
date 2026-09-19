enum PdfTemplateType {
  divorceAgreement,
  divorceApplication,
  exclusiveContract,
  nda,
  employmentContract,
  realEstateSale,
  realEstateRent,
  criminalComplaint,
  deathCertificate,
  loanAgreement,
  willNotary,
  resignationLetter,
  awardCertificate,
}

enum PdfTemplateCategory {
  family,
  business,
  realEstate,
  legal,
  medical,
  general,
}

enum StampShape {
  circle,
  oval,
  square,
}

/// 가상 서식 문서 데이터 모델
class PdfDocumentData {
  PdfTemplateType templateType;
  PdfTemplateCategory category;
  String title;
  String subtitle;
  String docNumber;
  String partyATitle;
  String partyAName;
  String partyAId;
  String partyAAddress;
  String partyBTitle;
  String partyBName;
  String partyBId;
  String partyBAddress;
  String amountText;
  String dateText;
  String institutionName;
  List<String> clauses;
  String specialTerms;
  String stampText;
  StampShape stampShape;
  bool isStampVisible;
  bool isWatermarkVisible;
  String watermarkText;
  bool isBarcodeVisible;

  PdfDocumentData({
    required this.templateType,
    required this.category,
    required this.title,
    this.subtitle = '',
    this.docNumber = '',
    this.partyATitle = '갑 (당사자)',
    this.partyAName = '',
    this.partyAId = '',
    this.partyAAddress = '',
    this.partyBTitle = '을 (당사자)',
    this.partyBName = '',
    this.partyBId = '',
    this.partyBAddress = '',
    this.amountText = '',
    this.dateText = '2026년 09월 19일',
    this.institutionName = '',
    required this.clauses,
    this.specialTerms = '',
    this.stampText = '인',
    this.stampShape = StampShape.circle,
    this.isStampVisible = true,
    this.isWatermarkVisible = false,
    this.watermarkText = '원본 대조필',
    this.isBarcodeVisible = true,
  });

  PdfDocumentData copyWith({
    PdfTemplateType? templateType,
    PdfTemplateCategory? category,
    String? title,
    String? subtitle,
    String? docNumber,
    String? partyATitle,
    String? partyAName,
    String? partyAId,
    String? partyAAddress,
    String? partyBTitle,
    String? partyBName,
    String? partyBId,
    String? partyBAddress,
    String? amountText,
    String? dateText,
    String? institutionName,
    List<String>? clauses,
    String? specialTerms,
    String? stampText,
    StampShape? stampShape,
    bool? isStampVisible,
    bool? isWatermarkVisible,
    String? watermarkText,
    bool? isBarcodeVisible,
  }) {
    return PdfDocumentData(
      templateType: templateType ?? this.templateType,
      category: category ?? this.category,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      docNumber: docNumber ?? this.docNumber,
      partyATitle: partyATitle ?? this.partyATitle,
      partyAName: partyAName ?? this.partyAName,
      partyAId: partyAId ?? this.partyAId,
      partyAAddress: partyAAddress ?? this.partyAAddress,
      partyBTitle: partyBTitle ?? this.partyBTitle,
      partyBName: partyBName ?? this.partyBName,
      partyBId: partyBId ?? this.partyBId,
      partyBAddress: partyBAddress ?? this.partyBAddress,
      amountText: amountText ?? this.amountText,
      dateText: dateText ?? this.dateText,
      institutionName: institutionName ?? this.institutionName,
      clauses: clauses ?? List.from(this.clauses),
      specialTerms: specialTerms ?? this.specialTerms,
      stampText: stampText ?? this.stampText,
      stampShape: stampShape ?? this.stampShape,
      isStampVisible: isStampVisible ?? this.isStampVisible,
      isWatermarkVisible: isWatermarkVisible ?? this.isWatermarkVisible,
      watermarkText: watermarkText ?? this.watermarkText,
      isBarcodeVisible: isBarcodeVisible ?? this.isBarcodeVisible,
    );
  }
}
