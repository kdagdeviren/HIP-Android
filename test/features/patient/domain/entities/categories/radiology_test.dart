import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/radiology.dart';

void main() {
  test('toMap/fromMap round-trip aynı değerleri korur', () {
    final original = Radiology(
      biradsValue: BiradsValue.five,
      breastDensity: BreastDensity.c,
      localization: Localization.upperOuterQuadrant,
      lesionType: LesionType.solidMass,
      architecturalStructure: ArchitecturalStructure.accompanyingMass,
      massShape: MassShape.irregular,
      massContour: MassContour.spiculated,
      massDensity: MassDensity.highDensity,
      calcificationMorphology: CalcificationMorphology.pleomorphic,
      calcificationDistribution: CalcificationDistribution.segmental,
      asymmetry: Asymmetry.focal,
      multifocalityStatus: MultifocalityStatus.multifocal,
      stableMassFor2Years: StableMassFor2Years.no,
      skinRetraction: SkinRetraction.yes,
      nippleRetraction: NippleRetraction.no,
      surgeryHistory: SurgeryHistory.yes,
      cosmeticImplant: CosmeticImplant.no,
    );

    final restored = Radiology.fromMap(original.toMap());

    expect(restored.biradsValue, original.biradsValue);
    expect(restored.breastDensity, original.breastDensity);
    expect(restored.localization, original.localization);
    expect(restored.lesionType, original.lesionType);
    expect(
      restored.architecturalStructure,
      original.architecturalStructure,
    );
    expect(restored.massShape, original.massShape);
    expect(restored.massContour, original.massContour);
    expect(restored.massDensity, original.massDensity);
    expect(
      restored.calcificationMorphology,
      original.calcificationMorphology,
    );
    expect(
      restored.calcificationDistribution,
      original.calcificationDistribution,
    );
    expect(restored.asymmetry, original.asymmetry);
    expect(restored.multifocalityStatus, original.multifocalityStatus);
    expect(restored.stableMassFor2Years, original.stableMassFor2Years);
    expect(restored.skinRetraction, original.skinRetraction);
    expect(restored.nippleRetraction, original.nippleRetraction);
    expect(restored.surgeryHistory, original.surgeryHistory);
    expect(restored.cosmeticImplant, original.cosmeticImplant);
  });

  test('boş map için tüm alanlar null döner', () {
    final restored = Radiology.fromMap(<String, dynamic>{});

    expect(restored.biradsValue, isNull);
    expect(restored.cosmeticImplant, isNull);
  });
}
