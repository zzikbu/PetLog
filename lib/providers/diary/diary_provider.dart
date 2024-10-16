import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_log/exceptions/custom_exception.dart';
import 'package:pet_log/models/diary_model.dart';
import 'package:pet_log/models/user_model.dart';
import 'package:pet_log/providers/diary/diary_state.dart';
import 'package:pet_log/providers/user/user_state.dart';
import 'package:pet_log/repositories/diary_repository.dart';
import 'package:state_notifier/state_notifier.dart';

class DiaryProvider extends StateNotifier<DiaryState> with LocatorMixin {
  // DiaryProvider 만들어질 때 DiaryState도 같이 만들기
  DiaryProvider() : super(DiaryState.init());

  // 성장일기 좋아요
  Future<void> likeDiary({
    required String diaryId,
    required List<String> diaryLikes,
  }) async {
    state = state.copyWith(diaryStatus: DiaryStatus.submitting);

    try {
      UserModel userModel = read<UserState>().userModel;

      // 좋아요가 눌려서 내용물이 수정된 성장일기
      DiaryModel diaryModel = await read<DiaryRepository>().likeDiary(
        diaryId: diaryId,
        diaryLikes: diaryLikes,
        uid: userModel.uid,
        userLikes: userModel.likes,
      );

      List<DiaryModel> newDiaryList = state.diaryList.map(
        (diary) {
          return diary.diaryId == diaryId ? diaryModel : diary;
        },
      ).toList();

      state = state.copyWith(
        diaryStatus: DiaryStatus.success,
        diaryList: newDiaryList,
      );
    } on CustomException catch (_) {
      state = state.copyWith(
          diaryStatus: DiaryStatus.error); // 문제가 생기면 error로 상태 변경
      rethrow; // 호출한 곳에다가 다시 rethrow
    }
  }

  // 성장일기 가져오기
  Future<void> getDiaryList({
    String? uid,
  }) async {
    try {
      state = state.copyWith(diaryStatus: DiaryStatus.fetching); // 상태 변경

      List<DiaryModel> diaryList;

      if (uid != null) {
        diaryList = await read<DiaryRepository>()
            .getDiaryList(uid: uid); // 접속 중인 사용자 필터해서 가져오기
      } else {
        diaryList = await read<DiaryRepository>().getDiaryList(); // 전체 가져오기
      }

      state = state.copyWith(
        diaryList: diaryList,
        diaryStatus: DiaryStatus.success,
      ); // 상태 변경
    } on CustomException catch (_) {
      state = state.copyWith(
          diaryStatus: DiaryStatus.error); // 문제가 생기면 error로 상태 변경
      rethrow; // 호출한 곳에다가 다시 rethrow
    }
  }

  // 성장일기 업로드
  Future<void> uploadDiary({
    required List<String> files, // 이미지들
    required String title, // 제목
    required String desc, // 내용
    required bool isLock, // 공개여부
  }) async {
    try {
      state = state.copyWith(
          diaryStatus: DiaryStatus.submitting); // 게시글을 등록하는 중인 상태로 변경

      String uid = read<User>().uid; // 작성자

      // 새로 등록한 성장일기를 리스트 맨앞에 추가 해주기 위해 변수에 저장
      DiaryModel diaryModel = await read<DiaryRepository>().uploadDiary(
        files: files,
        desc: desc,
        uid: uid,
        title: title,
        isLock: isLock,
      );

      state = state.copyWith(
        diaryStatus: DiaryStatus.success, // 등록 완료 상태로 변경
        diaryList: [
          diaryModel,
          ...state.diaryList, // 새로 등록한 성장일기를 리스트 맨앞에 추가
        ],
      );
    } on CustomException catch (_) {
      state = state.copyWith(
          diaryStatus: DiaryStatus.error); // 문제가 생기면 error로 상태 변경
      rethrow; // 호출한 곳에다가 다시 rethrow
    }
  }
}
