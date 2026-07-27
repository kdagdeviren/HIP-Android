import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/pathology.dart';

void main() {
  test('toMap/fromMap round-trip aynı değerleri korur', () {
    final original = Pathology(
      histologicalType: HistologicalType.invasiveDuctalCarcinoma,
      er: ERStatus.positive,
      pr: PRStatus.weakPositive,
      her2: HER2Status.her2Low,
      molecularType: MolecularType.luminalA,
      ki67: Ki67Level.high,
      tubuleGrade: TubuleGrade.grade2,
      nuclearGrade: NuclearGrade.grade3,
      mitoticGrade: MitoticGrade.grade1,
      histologicalGrade: HistologicalGrade.g2,
      eCadherin: ECadherinStatus.positive,
      til: TILLevel.between10and50,
    );

    final restored = Pathology.fromMap(original.toMap());

    expect(restored.histologicalType, original.histologicalType);
    expect(restored.er, original.er);
    expect(restored.pr, original.pr);
    expect(restored.her2, original.her2);
    expect(restored.molecularType, original.molecularType);
    expect(restored.ki67, original.ki67);
    expect(restored.tubuleGrade, original.tubuleGrade);
    expect(restored.nuclearGrade, original.nuclearGrade);
    expect(restored.mitoticGrade, original.mitoticGrade);
    expect(restored.histologicalGrade, original.histologicalGrade);
    expect(restored.eCadherin, original.eCadherin);
    expect(restored.til, original.til);
  });

  test('boş map için tüm alanlar null döner', () {
    final restored = Pathology.fromMap(<String, dynamic>{});

    expect(restored.histologicalType, isNull);
    expect(restored.er, isNull);
    expect(restored.til, isNull);
  });

  test('geçersiz enum ismi için ilgili alan null olur, hata fırlatmaz', () {
    final restored = Pathology.fromMap({'er': 'gecersiz_deger'});

    expect(restored.er, isNull);
  });
}
