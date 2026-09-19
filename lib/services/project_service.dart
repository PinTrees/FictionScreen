import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../pages/console/workspace/models/project_model.dart';
import 'auth_service.dart';

class ProjectService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // In-memory fallback if Firestore is not reachable or user is guest
  static final List<ProjectModel> _guestProjects = [];

  /// Get project collection reference for a user
  static CollectionReference<Map<String, dynamic>> _userProjectsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('projects');
  }

  /// Stream real projects from Firestore for the current user
  static Stream<List<ProjectModel>> streamProjects() {
    final user = AuthService.currentUser;
    if (user == null) {
      // Guest: returns in-memory session stream (starts empty)
      return Stream.value(List.unmodifiable(_guestProjects));
    }

    return _userProjectsRef(user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        DateTime updated;
        if (data['updatedAt'] is Timestamp) {
          updated = (data['updatedAt'] as Timestamp).toDate();
        } else if (data['updatedAt'] is String) {
          updated = DateTime.tryParse(data['updatedAt']) ?? DateTime.now();
        } else {
          updated = DateTime.now();
        }

        return ProjectModel(
          id: doc.id,
          title: data['title'] ?? '새 프로젝트',
          appTemplateId: data['appTemplateId'] ?? 'kakaotalk',
          description: data['description'] ?? '',
          updatedAt: updated,
          isStarred: data['isStarred'] ?? false,
          contentData: data['contentData'] is Map ? Map<String, dynamic>.from(data['contentData'] as Map) : null,
        );
      }).toList();
    }).handleError((err) {
      debugPrint('[ProjectService] Stream error: $err');
      return <ProjectModel>[];
    });
  }

  /// Get single project by ID
  static Future<ProjectModel?> getProject(String projectId) async {
    final user = AuthService.currentUser;
    if (user == null) {
      return _guestProjects.where((p) => p.id == projectId).firstOrNull;
    }

    try {
      final doc = await _userProjectsRef(user.uid).doc(projectId).get();
      if (!doc.exists || doc.data() == null) {
        return _guestProjects.where((p) => p.id == projectId).firstOrNull;
      }
      final data = doc.data()!;
      DateTime updated = DateTime.now();
      if (data['updatedAt'] is Timestamp) {
        updated = (data['updatedAt'] as Timestamp).toDate();
      } else if (data['updatedAt'] is String) {
        updated = DateTime.tryParse(data['updatedAt']) ?? DateTime.now();
      }

      return ProjectModel(
        id: doc.id,
        title: data['title'] ?? '새 프로젝트',
        appTemplateId: data['appTemplateId'] ?? 'kakaotalk',
        description: data['description'] ?? '',
        updatedAt: updated,
        isStarred: data['isStarred'] ?? false,
        contentData: data['contentData'] is Map ? Map<String, dynamic>.from(data['contentData'] as Map) : null,
      );
    } catch (e) {
      debugPrint('[ProjectService] getProject error: $e');
      return _guestProjects.where((p) => p.id == projectId).firstOrNull;
    }
  }

  /// Create a new project document in Firestore
  static Future<void> createProject(ProjectModel project) async {
    final user = AuthService.currentUser;
    if (user == null) {
      _guestProjects.removeWhere((p) => p.id == project.id);
      _guestProjects.insert(0, project);
      return;
    }

    try {
      await _userProjectsRef(user.uid).doc(project.id).set({
        'title': project.title,
        'appTemplateId': project.appTemplateId,
        'description': project.description,
        'updatedAt': FieldValue.serverTimestamp(),
        'isStarred': project.isStarred,
        'contentData': project.contentData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('[ProjectService] Create project error: $e');
      _guestProjects.removeWhere((p) => p.id == project.id);
      _guestProjects.insert(0, project);
    }
  }

  /// Update project data/content in Firestore
  static Future<void> updateProjectData(
    String projectId,
    Map<String, dynamic> contentData, {
    String? title,
  }) async {
    final user = AuthService.currentUser;
    if (user == null) {
      final p = _guestProjects.where((item) => item.id == projectId).firstOrNull;
      if (p != null) {
        p.contentData = contentData;
        if (title != null) p.title = title;
        p.updatedAt = DateTime.now();
      }
      return;
    }

    try {
      final Map<String, dynamic> updatePayload = {
        'contentData': contentData,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (title != null) {
        updatePayload['title'] = title;
      }
      await _userProjectsRef(user.uid).doc(projectId).set(
        updatePayload,
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('[ProjectService] updateProjectData error: $e');
    }
  }

  /// Delete a project from Firestore
  static Future<void> deleteProject(String projectId) async {
    final user = AuthService.currentUser;
    if (user == null) {
      _guestProjects.removeWhere((p) => p.id == projectId);
      return;
    }

    try {
      await _userProjectsRef(user.uid).doc(projectId).delete();
    } catch (e) {
      debugPrint('[ProjectService] Delete project error: $e');
      _guestProjects.removeWhere((p) => p.id == projectId);
    }
  }

  /// Toggle star status of a project in Firestore
  static Future<void> toggleStar(String projectId, bool isStarred) async {
    final user = AuthService.currentUser;
    if (user == null) {
      final p = _guestProjects.where((item) => item.id == projectId).firstOrNull;
      if (p != null) p.isStarred = isStarred;
      return;
    }

    try {
      await _userProjectsRef(user.uid).doc(projectId).update({
        'isStarred': isStarred,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('[ProjectService] Toggle star error: $e');
    }
  }
}
