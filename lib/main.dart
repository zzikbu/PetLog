import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:pet_log/firebase_options.dart';
import 'package:pet_log/key.dart';
import 'package:pet_log/providers/auth/auth_state.dart';
import 'package:pet_log/providers/auth/my_auth_provider.dart';
import 'package:pet_log/providers/diary/diary_provider.dart';
import 'package:pet_log/providers/diary/diary_state.dart';
import 'package:pet_log/providers/like/like_provider.dart';
import 'package:pet_log/providers/like/like_state.dart';
import 'package:pet_log/providers/medical/medical_provider.dart';
import 'package:pet_log/providers/medical/medical_state.dart';
import 'package:pet_log/providers/pet/pet_provider.dart';
import 'package:pet_log/providers/pet/pet_state.dart';
import 'package:pet_log/providers/profile/profile_provider.dart';
import 'package:pet_log/providers/profile/profile_state.dart';
import 'package:pet_log/providers/user/user_provider.dart';
import 'package:pet_log/providers/user/user_state.dart';
import 'package:pet_log/repositories/auth_repository.dart';
import 'package:pet_log/repositories/diary_repository.dart';
import 'package:pet_log/repositories/like_repository.dart';
import 'package:pet_log/repositories/medical_repository.dart';
import 'package:pet_log/repositories/pet_repository.dart';
import 'package:pet_log/repositories/profile_repository.dart';
import 'package:pet_log/screens/spalash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NaverMapSdk.instance.initialize(clientId: NAVERMAPCLIENTID);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut(); // 로그아웃 테스트 할 때
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseAuth: FirebaseAuth.instance,
              firebaseFirestore: FirebaseFirestore.instance),
        ),
        Provider<PetRepository>(
          create: (context) => PetRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<DiaryRepository>(
          create: (context) => DiaryRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<MedicalRepository>(
          create: (context) => MedicalRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<LikeRepository>(
          create: (context) => LikeRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StreamProvider<User?>(
          // ‼️앱 자체에서 인증상태를 변경하는게 아닌,
          // 파이어베이스 인증상태의 변화에 따라 앱의 인증상태를 변경하게 하기 위함‼️
          // 로그인 한 유저의 (인증)상태를 실시간으로 모니터링 (Stream)
          // 로그인 했으면 User 데이터를 로그아웃이면 null 반환
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          // Stream은 비동기로 동작하기 때문에
          // authStateChanges 함수를 최초로 호출해서 데이터를 가져오기 까지 시간이 걸림
          // 그 시간 동안에 미리 전달해 줄 데이터 지정
          initialData: null,
        ),
        StateNotifierProvider<MyAuthProvider, AuthState>(
          create: (context) => MyAuthProvider(),
        ),
        StateNotifierProvider<UserProvider, UserState>(
          create: (context) => UserProvider(),
        ),
        StateNotifierProvider<PetProvider, PetState>(
          create: (context) => PetProvider(),
        ),
        StateNotifierProvider<DiaryProvider, DiaryState>(
          create: (context) => DiaryProvider(),
        ),
        StateNotifierProvider<MedicalProvider, MedicalState>(
          create: (context) => MedicalProvider(),
        ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(),
        ),
        StateNotifierProvider<LikeProvider, LikeState>(
          create: (context) => LikeProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: SplashScreen(),
      ),
    );
  }
}
