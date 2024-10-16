import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_log/exceptions/custom_exception.dart';
import 'package:pet_log/models/medical_model.dart';
import 'package:pet_log/models/pet_model.dart';
import 'package:pet_log/models/user_model.dart';
import 'package:uuid/uuid.dart';

class MedicalRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const MedicalRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  // 진료기록 가져오기
  Future<List<MedicalModel>> getMedicalList({
    required String uid,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
          .collection('medicals')
          .where('uid', isEqualTo: uid)
          .orderBy('visitDate', descending: true) // 최신순 정렬
          .get();

      return await Future.wait(snapshot.docs.map(
        (e) async {
          Map<String, dynamic> data = e.data();

          // pet 필드 처리
          DocumentReference<Map<String, dynamic>> petDocRef = data["pet"];
          DocumentSnapshot<Map<String, dynamic>> petSnapshot =
              await petDocRef.get();
          PetModel petModel = PetModel.fromMap(petSnapshot.data()!);
          data["pet"] = petModel;

          // writer 필드 처리
          DocumentReference<Map<String, dynamic>> writerDocRef = data["writer"];
          DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
              await writerDocRef.get();
          UserModel userModel = UserModel.fromMap(writerSnapshot.data()!);
          data["writer"] = userModel;
          return MedicalModel.fromMap(data);
        },
      ).toList());
    } on FirebaseException catch (e) {
      // 호출한 곳에서 처리하게 throw
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      // 호출한 곳에서 처리하게 throw
      throw CustomException(
        code: "Exception",
        message: e.toString(),
      );
    }
  }

  // 진료기록 업로드
  Future<MedicalModel> uploadMedical({
    required String uid, // 작성자
    required String petId,
    required List<String> files, // 이미지들
    required String visitDate,
    required String reason,
    required String hospital,
    required String doctor,
    required String note,
  }) async {
    List<String> imageUrls = [];

    try {
      // 이 배치에 추가된 Firestore 작업들은 commit()을 호출하기 전까지
      // 실행되지 않고, 큐에 대기 상태로 존재
      WriteBatch batch = firebaseFirestore.batch();

      String medicalId = Uuid().v1(); // Generate a v1 (time-based) id

      // firestore 문서 참조
      DocumentReference<Map<String, dynamic>> medicalDocRef =
          firebaseFirestore.collection("medicals").doc(medicalId);

      DocumentReference<Map<String, dynamic>> userDocRef =
          firebaseFirestore.collection("users").doc(uid);

      DocumentReference<Map<String, dynamic>> petDocRef =
          firebaseFirestore.collection("pets").doc(petId);

      // firestorage 참조
      Reference ref = firebaseStorage.ref().child("medicals").child(medicalId);

      imageUrls = await Future.wait(files.map((e) async {
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot =
            await ref.child(imageId).putFile(File(e)); // stoage에 저장
        return await taskSnapshot.ref
            .getDownloadURL(); // 이미지에 접근할 수 있는 경로를 문자열로 반환
      }).toList());

      // 유저 모델 생성
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      // 펫 모델 생성
      DocumentSnapshot<Map<String, dynamic>> petSnapshot =
          await petDocRef.get();
      PetModel petModel = PetModel.fromMap(petSnapshot.data()!);

      MedicalModel medicalModel = MedicalModel.fromMap({
        "uid": uid,
        "pet": petModel,
        "medicalId": medicalId,
        "imageUrls": imageUrls,
        "visitDate": visitDate,
        "reason": reason,
        "hospital": hospital,
        "doctor": doctor,
        "note": note,
        "writer": userModel,
        "createAt": Timestamp.now(), // 현재 시간
      });

      batch.set(
        medicalDocRef,
        medicalModel.toMap(
          userDocRef: userDocRef,
          petDocRef: petDocRef,
        ),
      );

      batch.update(userDocRef, {
        "medicalCount": FieldValue.increment(1), // 기존값에서 1 증가
      });

      // 모든 작업이 큐에 추가된 후, commit()을 호출하면 Firestore에 모든 작업이 한 번에 적용
      // 만약 작업 중 하나라도 실패하면 전체 작업이 취소되며, 이로 인해 데이터의 일관성이 유지
      batch.commit();
      return medicalModel;
    } on FirebaseException catch (e) {
      // 에러 발생시 store에 등록된 이미지 삭제
      _deleteImage(imageUrls);

      // 호출한 곳에서 처리하게 throw
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      // 에러 발생시 store에 등록된 이미지 삭제
      _deleteImage(imageUrls);

      // 호출한 곳에서 처리하게 throw
      throw CustomException(
        code: "Exception",
        message: e.toString(),
      );
    }
  }

  // 이미지 삭제 함수
  void _deleteImage(List<String> imageUrls) {
    imageUrls.forEach(
      (element) async {
        await firebaseStorage.refFromURL(element).delete();
      },
    );
  }
}
