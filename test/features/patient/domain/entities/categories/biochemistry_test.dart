import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/biochemistry.dart';

void main() {
  test('toMap/fromMap round-trip aynı değerleri korur', () {
    final original = Biochemistry(
      alp: BiochemistryLevel.normal,
      alt: BiochemistryLevel.high,
      ast: BiochemistryLevel.low,
      bun: BiochemistryLevel.normal,
      ca153: BiochemistryLevel.high,
      cea: BiochemistryLevel.normal,
      crp: BiochemistryLevel.low,
      ggt: BiochemistryLevel.normal,
      glucose: BiochemistryLevel.high,
      hba1c: BiochemistryLevel.normal,
      creatinine: BiochemistryLevel.low,
      ldh: BiochemistryLevel.normal,
      tsh: BiochemistryLevel.high,
      egfr: BiochemistryLevel.low,
    );

    final restored = Biochemistry.fromMap(original.toMap());

    expect(restored.alp, original.alp);
    expect(restored.alt, original.alt);
    expect(restored.ast, original.ast);
    expect(restored.bun, original.bun);
    expect(restored.ca153, original.ca153);
    expect(restored.cea, original.cea);
    expect(restored.crp, original.crp);
    expect(restored.ggt, original.ggt);
    expect(restored.glucose, original.glucose);
    expect(restored.hba1c, original.hba1c);
    expect(restored.creatinine, original.creatinine);
    expect(restored.ldh, original.ldh);
    expect(restored.tsh, original.tsh);
    expect(restored.egfr, original.egfr);
  });

  test('boş map için tüm alanlar null döner', () {
    final restored = Biochemistry.fromMap(<String, dynamic>{});

    expect(restored.alp, isNull);
    expect(restored.egfr, isNull);
  });
}
