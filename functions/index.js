const { onRequest, onCall, HttpsError } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp();
}
const db = admin.firestore();

/**
 * 💡 [Auth Trigger] 유저 생성 시 Firestore user 문서 자동 생성
 * Firebase Authentication 계정 생성 시 즉시 users/{uid} 기본 문서를 프로비저닝합니다.
 */
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;
  const email = user.email || "";
  const displayName = user.displayName || (email ? email.split("@")[0] : "사용자");
  const photoURL = user.photoURL || "";

  logger.info(`[Auth Trigger] Auto-creating user document for ${uid} (${email})`);

  try {
    const userDocRef = db.collection("users").doc(uid);
    const snap = await userDocRef.get();
    if (!snap.exists) {
      await userDocRef.set({
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        role: "user",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      logger.info(`[Auth Trigger] Successfully created users/${uid}`);
    }

    // 기본 테마 설정 초기화
    const themeRef = userDocRef.collection("settings").doc("theme_config");
    const themeSnap = await themeRef.get();
    if (!themeSnap.exists) {
      await themeRef.set({
        themeMode: "system",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  } catch (error) {
    logger.error(`[Auth Trigger] Failed to create user document for ${uid}:`, error);
  }
});

/**
 * 💡 [보완용 Callable] 유저 데이터 부트스트랩
 * 클라이언트 로그인 후 유저 문서가 누락된 경우 즉시 복구 생성
 */
exports.bootstrapUser = onCall({ cors: true }, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요합니다.");
  }
  const uid = request.auth.uid;
  const token = request.auth.token || {};
  const email = token.email || "";
  const displayName = token.name || (email ? email.split("@")[0] : "사용자");
  const photoURL = token.picture || "";

  logger.info(`[bootstrapUser] Ensuring user document for ${uid}`);

  const userDocRef = db.collection("users").doc(uid);
  const snap = await userDocRef.get();
  if (!snap.exists) {
    await userDocRef.set({
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      role: "user",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    logger.info(`[bootstrapUser] Created users/${uid}`);
  }

  return { success: true, uid };
});

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