import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/comorbidity.dart';

void main() {
  test('toMap/fromMap round-trip aynı değerleri korur', () {
    final original = Comorbidity(
      ht: Presence.present,
      dm: Presence.absent,
      copd: Presence.present,
      smoking: Presence.absent,
      familyHistoryOfBreastCa: Presence.present,
      thyroidDisease: Presence.absent,
      retinopathy: Presence.present,
      neuropathy: Presence.absent,
      osteoporosis: Presence.present,
      depression: Presence.absent,
    );

    final restored = Comorbidity.fromMap(original.toMap());

    expect(restored.ht, original.ht);
    expect(restored.dm, original.dm);
    expect(restored.copd, original.copd);
    expect(restored.smoking, original.smoking);
    expect(
      restored.familyHistoryOfBreastCa,
      original.familyHistoryOfBreastCa,
    );
    expect(restored.thyroidDisease, original.thyroidDisease);
    expect(restored.retinopathy, original.retinopathy);
    expect(restored.neuropathy, original.neuropathy);
    expect(restored.osteoporosis, original.osteoporosis);
    expect(restored.depression, original.depression);
  });

  test('boş map için tüm alanlar null döner', () {
    final restored = Comorbidity.fromMap(<String, dynamic>{});

    expect(restored.ht, isNull);
    expect(restored.depression, isNull);
  });
}
