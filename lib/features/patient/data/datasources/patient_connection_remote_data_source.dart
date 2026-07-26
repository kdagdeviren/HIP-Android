import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_connection_model.dart';

class PatientConnectionRemoteDataSource {
  final CollectionReference _connectionsCollection = FirebaseFirestore.instance
      .collection('patient_connections');

  /// Needed because every connection change must also update the patient's
  /// `authorizedUserIds` index that security rules read.
  final CollectionReference _patientsCollection = FirebaseFirestore.instance
      .collection('patients');

  /// Yeni bir hasta-kullanıcı bağlantısı oluşturur
  /// Aynı kullanıcı zaten bağlıysa hata döner
  Future<ResponseMessage> createConnection(PatientConnection connection) async {
    try {
      // Önce bu kullanıcı-hasta kombinasyonu var mı kontrol et
      final existingQuery = await _connectionsCollection
          .where('patientId', isEqualTo: connection.patientId)
          .where('userId', isEqualTo: connection.userId)
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        return ResponseMessage(status: false, message: 'Bu hasta zaten mevcut');
      }

      // Yeni bağlantı oluştur
      final docRef = _connectionsCollection.doc();
      final connectionData = connection.toMap();
      connectionData['createdAt'] = FieldValue.serverTimestamp();

      // Bağlantı ile yetki dizisi tek batch'te yazılır; ikisi birlikte başarılı
      // olur ya da birlikte başarısız olur, arada tutarsız durum oluşamaz.
      final batch = FirebaseFirestore.instance.batch();
      batch.set(docRef, connectionData);
      batch.update(_patientsCollection.doc(connection.patientId), {
        'authorizedUserIds': FieldValue.arrayUnion([connection.userId]),
      });
      await batch.commit();

      return ResponseMessage(
        status: true,
        message: 'Hasta başarıyla bağlandı',
        docId: docRef.id,
      );
    } catch (e) {
      LoggerUtil.e('Bağlantı oluşturulurken hata: $e');
      return ResponseMessage(
        status: false,
        message: 'Bağlantı oluşturulamadı: $e',
      );
    }
  }

  /// Belirli bir kullanıcının tüm hasta bağlantılarını getirir
  Future<List<String>> getPatientIdsByUserId(String userId) async {
    try {
      final querySnapshot = await _connectionsCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .map((data) => data['patientId'] as String)
          .toList();
    } catch (e) {
      LoggerUtil.e('Hasta ID\'leri getirilirken hata: $e');
      return [];
    }
  }

  /// Belirli bir kullanıcının bağlı olduğu hasta sayısını döner
  Future<int> getConnectionCountByUserId(String userId) async {
    try {
      final querySnapshot = await _connectionsCollection
          .where('userId', isEqualTo: userId)
          .count()
          .get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      LoggerUtil.e('Bağlantı sayısı alınırken hata: $e');
      return 0;
    }
  }

  /// Bir bağlantıyı siler ve hastanın yetki dizisinden kullanıcıyı çıkarır
  Future<ResponseMessage> deleteConnection(String connectionId) async {
    try {
      // patientId/userId yalnızca bağlantı dokümanında; diziyi güncelleyebilmek
      // için önce okunması gerekiyor.
      final connectionRef = _connectionsCollection.doc(connectionId);
      final snapshot = await connectionRef.get();

      if (!snapshot.exists) {
        return ResponseMessage(status: false, message: 'Bağlantı bulunamadı');
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final connection = PatientConnection.fromMap(data);

      final batch = FirebaseFirestore.instance.batch();
      batch.delete(connectionRef);
      batch.update(_patientsCollection.doc(connection.patientId), {
        'authorizedUserIds': FieldValue.arrayRemove([connection.userId]),
      });
      await batch.commit();

      return ResponseMessage(
        status: true,
        message: 'Bağlantı başarıyla silindi',
      );
    } catch (e) {
      LoggerUtil.e('Bağlantı silinirken hata: $e');
      return ResponseMessage(status: false, message: 'Bağlantı silinemedi: $e');
    }
  }

  /// Kullanıcının bir hastaya olan rolünü günceller
  Future<ResponseMessage> updateConnectionRole(
    String connectionId,
    ConnectionRole newRole,
  ) async {
    try {
      await _connectionsCollection.doc(connectionId).update({
        'role': newRole.name,
      });
      return ResponseMessage(
        status: true,
        message: 'Rol başarıyla güncellendi',
      );
    } catch (e) {
      LoggerUtil.e('Rol güncellenirken hata: $e');
      return ResponseMessage(status: false, message: 'Rol güncellenemedi: $e');
    }
  }

  /// Belirli bir hasta-kullanıcı bağlantısını getirir
  Future<PatientConnection?> getConnection(
    String patientId,
    String userId,
  ) async {
    try {
      final querySnapshot = await _connectionsCollection
          .where('patientId', isEqualTo: patientId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return PatientConnection.fromMap(data).copyWith(docId: doc.id);
    } catch (e) {
      LoggerUtil.e('Bağlantı getirilirken hata: $e');
      return null;
    }
  }

  /// Bir hastanın tüm bağlantılarını getirir (örn: paylaşılan kullanıcılar)
  Future<List<PatientConnection>> getConnectionsByPatientId(
    String patientId,
  ) async {
    try {
      final querySnapshot = await _connectionsCollection
          .where('patientId', isEqualTo: patientId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PatientConnection.fromMap(data).copyWith(docId: doc.id);
      }).toList();
    } catch (e) {
      LoggerUtil.e('Hasta bağlantıları getirilirken hata: $e');
      return [];
    }
  }
}
