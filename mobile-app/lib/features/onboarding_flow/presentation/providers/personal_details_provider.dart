import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Gender { male, female }
enum HeightUnit { cm, ft }
enum WeightUnit { kg, lbs }

class PersonalDetails {
  const PersonalDetails({
    this.age = 25,
    this.gender = Gender.male,
    this.height = 175,
    this.heightUnit = HeightUnit.cm,
    this.weight = 70,
    this.weightUnit = WeightUnit.kg,
  });

  final int age;
  final Gender gender;
  final int height;
  final HeightUnit heightUnit;
  final int weight;
  final WeightUnit weightUnit;

  PersonalDetails copyWith({
    int? age,
    Gender? gender,
    int? height,
    HeightUnit? heightUnit,
    int? weight,
    WeightUnit? weightUnit,
  }) {
    return PersonalDetails(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
    );
  }
}

class PersonalDetailsNotifier extends StateNotifier<PersonalDetails> {
  PersonalDetailsNotifier() : super(const PersonalDetails());

  void setAge(int age) => state = state.copyWith(age: age);
  void setGender(Gender gender) => state = state.copyWith(gender: gender);
  void setHeight(int height) => state = state.copyWith(height: height);
  void setHeightUnit(HeightUnit unit) => state = state.copyWith(heightUnit: unit);
  void setWeight(int weight) => state = state.copyWith(weight: weight);
  void setWeightUnit(WeightUnit unit) => state = state.copyWith(weightUnit: unit);
}

final personalDetailsProvider =
    StateNotifierProvider<PersonalDetailsNotifier, PersonalDetails>(
  (ref) => PersonalDetailsNotifier(),
);
