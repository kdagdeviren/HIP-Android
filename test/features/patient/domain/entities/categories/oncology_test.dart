import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/oncology.dart';

void main() {
  test('toMap/fromMap round-trip aynı değerleri korur', () {
    final original = Oncology(
      metastasisStatus: MetastasisStatus.present,
      metastasisLocation: MetastasisLocation.lymphNode,
      clinicalStage: ClinicalStage.iiia,
      chemotherapyRegimen: ChemotherapyRegimen.taxaneOnly,
      chemotherapyCycleDensity: ChemotherapyCycleDensity.full,
    );

    final restored = Oncology.fromMap(original.toMap());

    expect(restored.metastasisStatus, original.metastasisStatus);
    expect(restored.metastasisLocation, original.metastasisLocation);
    expect(restored.clinicalStage, original.clinicalStage);
    expect(restored.chemotherapyRegimen, original.chemotherapyRegimen);
    expect(
      restored.chemotherapyCycleDensity,
      original.chemotherapyCycleDensity,
    );
  });

  test('boş map için tüm alanlar null döner', () {
    final restored = Oncology.fromMap(<String, dynamic>{});

    expect(restored.metastasisStatus, isNull);
    expect(restored.clinicalStage, isNull);
  });
}
