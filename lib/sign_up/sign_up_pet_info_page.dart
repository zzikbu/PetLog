import 'package:flutter/material.dart';
import 'package:pet_log/components/custom_bottom_navigation_bar.dart';
import 'package:pet_log/components/next_button.dart';
import 'package:pet_log/components/step_progress_indicator.dart';
import 'package:pet_log/components/textfield_with_title.dart';
import 'package:pet_log/palette.dart';
import 'package:provider/provider.dart';

class SignUpPetInfoPage extends StatefulWidget {
  const SignUpPetInfoPage({super.key});

  @override
  _SignUpPetInfoPageState createState() => _SignUpPetInfoPageState();
}

class _SignUpPetInfoPageState extends State<SignUpPetInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _meetingDateController = TextEditingController();
  String? selectedGender;
  String? selectedNeutering;

  final List<String> genderTypes = ['수컷', '암컷'];
  final List<String> NeuteringTypes = ['했어요', '안했어요'];

  bool _isNextButtonActive = false;

  void _updateButtonState() {
    setState(() {
      _isNextButtonActive = _nameController.text.isNotEmpty &&
          _breedController.text.isNotEmpty &&
          _birthdayController.text.isNotEmpty &&
          _meetingDateController.text.isNotEmpty &&
          (selectedGender?.isNotEmpty ?? false) &&
          (selectedNeutering?.isNotEmpty ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _breedController.addListener(_updateButtonState);
    _birthdayController.addListener(_updateButtonState);
    _meetingDateController.addListener(_updateButtonState);

    // _nameController.text = context.read<AuthService>().name;
    // _breedController.text = context.read<AuthService>().breed;
    // _birthdayController.text = context.read<AuthService>().birthday;
    // _meetingDateController.text = context.read<AuthService>().meetingDate;
    // selectedGender = context.read<AuthService>().selectedGender;
    // selectedNeutering = context.read<AuthService>().selectedNeutering;

    _updateButtonState();
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _breedController.removeListener(_updateButtonState);
    _birthdayController.removeListener(_updateButtonState);
    _meetingDateController.removeListener(_updateButtonState);

    _nameController.dispose();
    _breedController.dispose();
    _birthdayController.dispose();
    _meetingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: NextButton(
        isActive: _isNextButtonActive,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomBottomNavigationBar()),
          );
        },
        buttonText: "시작하기",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StepProgressIndicator(
              totalSteps: 3,
              currentStep: 3,
              selectedColor: Palette.black,
              unselectedColor: Palette.lightGray,
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        '반려동물의 상세정보를\n입력해주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Palette.black,
                          letterSpacing: -0.6,
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Palette.lightGray,
                                  width: 2.0,
                                ),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.pets,
                                color: Colors.black,
                                size: 40.0,
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              right: -5,
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Palette.black,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  print('카메라 아이콘 눌림');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          TextFieldWithTitle(
                            labelText: '이름',
                            maxLength: 5,
                            hintText: '이름을 입력해주세요',
                            controller: _nameController,
                          ),
                          SizedBox(height: 40),
                          TextFieldWithTitle(
                            labelText: '품종',
                            maxLength: 8,
                            hintText: '품종을 입력해주세요',
                            controller: _breedController,
                          ),
                          SizedBox(height: 40),
                          TextFieldWithTitle(
                            labelText: '생년월일',
                            hintText: '2000-08-07 형식으로 입력해주세요',
                            keyboardType: TextInputType.datetime,
                            controller: _birthdayController,
                          ),
                          SizedBox(height: 40),
                          TextFieldWithTitle(
                            labelText: '만날 날',
                            hintText: '2000-08-07 형식으로 입력해주세요',
                            keyboardType: TextInputType.datetime,
                            controller: _meetingDateController,
                          ),
                          SizedBox(height: 40),
                          Text(
                            '성별',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Palette.black,
                              letterSpacing: -0.45,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            runSpacing: 8.0, // 상하
                            spacing: 8.0, // 좌우
                            children: genderTypes.map((pet) {
                              return ChoiceChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: selectedGender == pet
                                        ? Palette.subGreen
                                        : Palette.lightGray,
                                    width: 1.0,
                                  ),
                                ),
                                label: Text(pet),
                                backgroundColor: Palette.white,
                                selected: selectedGender == pet,
                                selectedColor: Palette.mainGreen,
                                showCheckmark: false,
                                labelStyle: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: selectedGender == pet
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                  color: selectedGender == pet
                                      ? Palette.white
                                      : Palette.lightGray,
                                ),
                                onSelected: (bool isSelected) {
                                  setState(() {
                                    selectedGender = isSelected ? pet : null;
                                    _updateButtonState();
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 30),
                          Text(
                            '중성화',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Palette.black,
                              letterSpacing: -0.45,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            runSpacing: 8.0, // 상하
                            spacing: 8.0, // 좌우
                            children: NeuteringTypes.map((pet) {
                              return ChoiceChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: selectedNeutering == pet
                                        ? Palette.subGreen
                                        : Palette.lightGray,
                                    width: 1.0,
                                  ),
                                ),
                                label: Text(pet),
                                backgroundColor: Palette.white,
                                selected: selectedNeutering == pet,
                                selectedColor: Palette.mainGreen,
                                showCheckmark: false,
                                labelStyle: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: selectedNeutering == pet
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 16,
                                  color: selectedNeutering == pet
                                      ? Palette.white
                                      : Palette.lightGray,
                                ),
                                onSelected: (bool isSelected) {
                                  setState(() {
                                    selectedNeutering = isSelected ? pet : null;
                                    _updateButtonState();
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
