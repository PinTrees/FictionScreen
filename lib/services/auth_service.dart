import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 유저 문서 존재 확인 및 없으면 즉시 생성 (클라이언트 자동 복구 및 동기화)
  static Future<void> ensureUserDocument(User user) async {
    try {
      final docRef = _firestore.collection('users').doc(user.uid);
      final snap = await docRef.get();
      if (!snap.exists) {
        final email = user.email ?? '';
        final displayName = user.displayName ?? (email.isNotEmpty ? email.split('@').first : '사용자');
        await docRef.set({
          'uid': user.uid,
          'email': email,
          'displayName': displayName,
          'photoURL': user.photoURL ?? '',
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('[AuthService] Successfully created users/${user.uid} document on client');
      }
    } catch (e) {
      debugPrint('[AuthService] ensureUserDocument error: $e');
    }
  }

  /// Google 계정으로 로그인 (Web 및 모바일 팝업 대응)
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      final credential = kIsWeb
          ? await _auth.signInWithPopup(googleProvider)
          : await _auth.signInWithProvider(googleProvider);

      if (credential.user != null) {
        await ensureUserDocument(credential.user!);
      }
      return credential;
    } catch (e) {
      debugPrint('[AuthService] Google Sign-In error: $e');
      rethrow;
    }
  }

  /// 로그아웃
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('[AuthService] Sign out error: $e');
    }
  }
}
