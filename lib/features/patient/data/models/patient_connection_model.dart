import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';

enum ConnectionRole { owner, editor }

extension ConnectionRoleExtension on ConnectionRole {
  String get displayText {
    switch (this) {
      case ConnectionRole.owner:
        return L10n.current.connectionRole_owner;
      case ConnectionRole.editor:
        return L10n.current.connectionRole_editor;
    }
  }
}

class PatientConnection {
  final String? docId;
  final String patientId;
  final String userId;
  final ConnectionRole role;
  final DateTime? createdAt;

  PatientConnection({
    this.docId,
    required this.patientId,
    required this.userId,
    required this.role,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'userId': userId,
      'role': role.name,
      // createdAt will be handled with FieldValue.serverTimestamp() at datasource level
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory PatientConnection.fromMap(Map<String, dynamic> map) {
    return PatientConnection(
      docId: map['docId'] as String?,
      patientId: map['patientId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      role: map['role'] != null
          ? ConnectionRole.values.byName(map['role'])
          : ConnectionRole.editor,
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  PatientConnection copyWith({
    String? docId,
    String? patientId,
    String? userId,
    ConnectionRole? role,
    DateTime? createdAt,
  }) {
    return PatientConnection(
      docId: docId ?? this.docId,
      patientId: patientId ?? this.patientId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
