import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/demography.dart';

void main() {
  test('toMap/fromMap round-trip aynı değerleri korur', () {
    final original = Demography(
      breastSide: BreastSide.left,
      bmi: BMI.overweight,
      ageAtDiagnosis: AgeAtDiagnosis.middleAge,
      bloodType: BloodType.oPositive,
      menopause: Menopause.present,
      sunExposure: SunExposure.medium,
    );

    final restored = Demography.fromMap(original.toMap());

    expect(restored.breastSide, original.breastSide);
    expect(restored.bmi, original.bmi);
    expect(restored.ageAtDiagnosis, original.ageAtDiagnosis);
    expect(restored.bloodType, original.bloodType);
    expect(restored.menopause, original.menopause);
    expect(restored.sunExposure, original.sunExposure);
  });

  test('boş map için tüm alanlar null döner', () {
    final restored = Demography.fromMap(<String, dynamic>{});

    expect(restored.breastSide, isNull);
    expect(restored.bloodType, isNull);
  });
}
