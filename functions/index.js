const { onRequest, onCall, HttpsError } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * 상태 확인 (Health Check) HTTP 엔드포인트
 */
exports.healthCheck = onRequest({ cors: true }, (req, res) => {
  logger.info("FictionScreen Functions HealthCheck executed", { structuredData: true });
  res.status(200).json({
    status: "ok",
    service: "FictionScreen Cloud Functions",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
  });
});

/**
 * 템플릿 프리셋 데이터 제공 Callable 함수
 */
exports.getTemplates = onCall({ cors: true }, async (request) => {
  logger.info("getTemplates called", { auth: request.auth ? request.auth.uid : "anonymous" });
  
  return {
    templates: [
      { id: "kakaotalk", name: "카카오톡 채팅방", category: "messenger" },
      { id: "windows_bsod", name: "Windows 블루스크린", category: "os" },
      { id: "youtube", name: "YouTube 비디오/댓글", category: "sns" },
      { id: "instagram", name: "인스타그램 피드", category: "sns" },
      { id: "delivery", name: "배달의민족 주문/배송", category: "lifestyle" },
    ],
  };
});

/**
 * 가짜 화면 시나리오 생성 AI 또는 스크립트 도우미 (Callable)
 */
exports.generateScenario = onCall({ cors: true }, async (request) => {
  const { topic, type } = request.data || {};
  
  if (!topic) {
    throw new HttpsError("invalid-argument", "시나리오 주제(topic)를 제공해야 합니다.");
  }

  logger.info("generateScenario called for topic:", topic);

  return {
    success: true,
    topic,
    type: type || "kakaotalk",
    dialogues: [
      { sender: "other", text: `${topic} 관련해서 지금 확인했어?`, time: "오후 2:30" },
      { sender: "me", text: "어 방금 확인했음 ㅋㅋㅋ 대박인데?", time: "오후 2:31" },
      { sender: "other", text: "이거 영상 소스로 바로 써도 되겠다", time: "오후 2:31" },
    ],
  };
});