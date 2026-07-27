import 'package:flutter_medical_data_app/core/l10n/l10n.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/pathology.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/oncology.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/demography.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/comorbidity.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/biochemistry.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/radiology.dart';

class EnumDisplayUtil {
  static String getDisplayText(Enum e) {
    final l10n = L10n.current;

    // Pathology enums
    if (e is HistologicalType) return _histologicalType(e, l10n);
    if (e is ERStatus) return _erStatus(e, l10n);
    if (e is PRStatus) return _prStatus(e, l10n);
    if (e is HER2Status) return _her2Status(e, l10n);
    if (e is MolecularType) return _molecularType(e, l10n);
    if (e is Ki67Level) return _ki67Level(e, l10n);
    if (e is TubuleGrade) return _tubuleGrade(e, l10n);
    if (e is NuclearGrade) return _nuclearGrade(e, l10n);
    if (e is MitoticGrade) return _mitoticGrade(e, l10n);
    if (e is HistologicalGrade) return _histologicalGrade(e, l10n);
    if (e is ECadherinStatus) return _eCadherinStatus(e, l10n);
    if (e is TILLevel) return _tilLevel(e, l10n);

    // Oncology enums
    if (e is MetastasisStatus) return _metastasisStatus(e, l10n);
    if (e is MetastasisLocation) return _metastasisLocation(e, l10n);
    if (e is ClinicalStage) return _clinicalStage(e, l10n);
    if (e is ChemotherapyRegimen) return _chemotherapyRegimen(e, l10n);
    if (e is ChemotherapyCycleDensity) {
      return _chemotherapyCycleDensity(e, l10n);
    }

    // Demography enums
    if (e is BreastSide) return _breastSide(e, l10n);
    if (e is BMI) return _bmi(e, l10n);
    if (e is AgeAtDiagnosis) return _ageAtDiagnosis(e, l10n);
    if (e is BloodType) return _bloodType(e, l10n);
    if (e is Menopause) return _menopause(e, l10n);
    if (e is SunExposure) return _sunExposure(e, l10n);

    // Comorbidity enums
    if (e is Presence) return _presence(e, l10n);
    if (e is PresenceNegative) return _presenceNegative(e, l10n);

    // Biochemistry enums
    if (e is BiochemistryLevel) return _biochemistryLevel(e, l10n);

    // Radiology enums
    if (e is BiradsValue) return _biradsValue(e, l10n);
    if (e is BreastDensity) return _breastDensity(e, l10n);
    if (e is Localization) return _localization(e, l10n);
    if (e is LesionType) return _lesionType(e, l10n);
    if (e is ArchitecturalStructure) return _architecturalStructure(e, l10n);
    if (e is MassShape) return _massShape(e, l10n);
    if (e is MassContour) return _massContour(e, l10n);
    if (e is MassDensity) return _massDensity(e, l10n);
    if (e is CalcificationMorphology) {
      return _calcificationMorphology(e, l10n);
    }
    if (e is CalcificationDistribution) {
      return _calcificationDistribution(e, l10n);
    }
    if (e is Asymmetry) return _asymmetry(e, l10n);
    if (e is MultifocalityStatus) return _multifocalityStatus(e, l10n);
    if (e is StableMassFor2Years) return _stableMassFor2Years(e, l10n);
    if (e is SkinRetraction) return _skinRetraction(e, l10n);
    if (e is NippleRetraction) return _nippleRetraction(e, l10n);
    if (e is SurgeryHistory) return _surgeryHistory(e, l10n);
    if (e is CosmeticImplant) return _cosmeticImplant(e, l10n);

    return e.name; // Fallback
  }

  // --- Pathology ---

  static String _histologicalType(HistologicalType e, AppLocalizations l10n) {
    switch (e) {
      case HistologicalType.mikstDuctalLobular:
        return l10n.pathology_histologicalType_mikstDuctalLobular;
      case HistologicalType.invasiveLobularCarcinoma:
        return l10n.pathology_histologicalType_invasiveLobularCarcinoma;
      case HistologicalType.invasiveDuctalCarcinoma:
        return l10n.pathology_histologicalType_invasiveDuctalCarcinoma;
      case HistologicalType.otherRareTypes:
        return l10n.pathology_histologicalType_otherRareTypes;
      case HistologicalType.dcis:
        return l10n.pathology_histologicalType_dcis;
      case HistologicalType.unknown:
        return l10n.pathology_histologicalType_unknown;
    }
  }

  static String _erStatus(ERStatus e, AppLocalizations l10n) {
    switch (e) {
      case ERStatus.negative:
        return l10n.pathology_erStatus_negative;
      case ERStatus.strongPositive:
        return l10n.pathology_erStatus_strongPositive;
      case ERStatus.weakPositive:
        return l10n.pathology_erStatus_weakPositive;
      case ERStatus.positive:
        return l10n.pathology_erStatus_positive;
      case ERStatus.unknown:
        return l10n.pathology_erStatus_unknown;
    }
  }

  static String _prStatus(PRStatus e, AppLocalizations l10n) {
    switch (e) {
      case PRStatus.negative:
        return l10n.pathology_prStatus_negative;
      case PRStatus.strongPositive:
        return l10n.pathology_prStatus_strongPositive;
      case PRStatus.weakPositive:
        return l10n.pathology_prStatus_weakPositive;
      case PRStatus.positive:
        return l10n.pathology_prStatus_positive;
      case PRStatus.unknown:
        return l10n.pathology_prStatus_unknown;
    }
  }

  static String _her2Status(HER2Status e, AppLocalizations l10n) {
    switch (e) {
      case HER2Status.negative:
        return l10n.pathology_her2Status_negative;
      case HER2Status.positive:
        return l10n.pathology_her2Status_positive;
      case HER2Status.her2Low:
        return l10n.pathology_her2Status_her2Low;
      case HER2Status.equivocal:
        return l10n.pathology_her2Status_equivocal;
      case HER2Status.unknown:
        return l10n.pathology_her2Status_unknown;
    }
  }

  static String _molecularType(MolecularType e, AppLocalizations l10n) {
    switch (e) {
      case MolecularType.tripleNegative:
        return l10n.pathology_molecularType_tripleNegative;
      case MolecularType.luminalA:
        return l10n.pathology_molecularType_luminalA;
      case MolecularType.luminalBHer2Positive:
        return l10n.pathology_molecularType_luminalBHer2Positive;
      case MolecularType.luminalBHer2Negative:
        return l10n.pathology_molecularType_luminalBHer2Negative;
      case MolecularType.her2Low:
        return l10n.pathology_molecularType_her2Low;
      case MolecularType.her2Enriched:
        return l10n.pathology_molecularType_her2Enriched;
      case MolecularType.unknown:
        return l10n.pathology_molecularType_unknown;
    }
  }

  static String _ki67Level(Ki67Level e, AppLocalizations l10n) {
    switch (e) {
      case Ki67Level.low:
        return l10n.pathology_ki67Level_low;
      case Ki67Level.medium:
        return l10n.pathology_ki67Level_medium;
      case Ki67Level.high:
        return l10n.pathology_ki67Level_high;
      case Ki67Level.unknown:
        return l10n.pathology_ki67Level_unknown;
    }
  }

  static String _tubuleGrade(TubuleGrade e, AppLocalizations l10n) {
    switch (e) {
      case TubuleGrade.grade1:
        return l10n.pathology_tubuleGrade_grade1;
      case TubuleGrade.grade2:
        return l10n.pathology_tubuleGrade_grade2;
      case TubuleGrade.grade3:
        return l10n.pathology_tubuleGrade_grade3;
      case TubuleGrade.unknown:
        return l10n.pathology_tubuleGrade_unknown;
    }
  }

  static String _nuclearGrade(NuclearGrade e, AppLocalizations l10n) {
    switch (e) {
      case NuclearGrade.grade1:
        return l10n.pathology_nuclearGrade_grade1;
      case NuclearGrade.grade2:
        return l10n.pathology_nuclearGrade_grade2;
      case NuclearGrade.grade3:
        return l10n.pathology_nuclearGrade_grade3;
      case NuclearGrade.unknown:
        return l10n.pathology_nuclearGrade_unknown;
    }
  }

  static String _mitoticGrade(MitoticGrade e, AppLocalizations l10n) {
    switch (e) {
      case MitoticGrade.grade1:
        return l10n.pathology_mitoticGrade_grade1;
      case MitoticGrade.grade2:
        return l10n.pathology_mitoticGrade_grade2;
      case MitoticGrade.grade3:
        return l10n.pathology_mitoticGrade_grade3;
      case MitoticGrade.unknown:
        return l10n.pathology_mitoticGrade_unknown;
    }
  }

  static String _histologicalGrade(
    HistologicalGrade e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case HistologicalGrade.g1:
        return l10n.pathology_histologicalGrade_g1;
      case HistologicalGrade.g2:
        return l10n.pathology_histologicalGrade_g2;
      case HistologicalGrade.g3:
        return l10n.pathology_histologicalGrade_g3;
      case HistologicalGrade.unknown:
        return l10n.pathology_histologicalGrade_unknown;
    }
  }

  static String _eCadherinStatus(ECadherinStatus e, AppLocalizations l10n) {
    switch (e) {
      case ECadherinStatus.negative:
        return l10n.pathology_eCadherinStatus_negative;
      case ECadherinStatus.positive:
        return l10n.pathology_eCadherinStatus_positive;
      case ECadherinStatus.unknown:
        return l10n.pathology_eCadherinStatus_unknown;
    }
  }

  static String _tilLevel(TILLevel e, AppLocalizations l10n) {
    switch (e) {
      case TILLevel.lessThan10:
        return l10n.pathology_tilLevel_lessThan10;
      case TILLevel.between10and50:
        return l10n.pathology_tilLevel_between10and50;
      case TILLevel.moreThan50:
        return l10n.pathology_tilLevel_moreThan50;
      case TILLevel.unknown:
        return l10n.pathology_tilLevel_unknown;
    }
  }

  // --- Oncology ---

  static String _metastasisStatus(MetastasisStatus e, AppLocalizations l10n) {
    switch (e) {
      case MetastasisStatus.present:
        return l10n.oncology_metastasisStatus_present;
      case MetastasisStatus.absent:
        return l10n.oncology_metastasisStatus_absent;
      case MetastasisStatus.unknown:
        return l10n.oncology_metastasisStatus_unknown;
    }
  }

  static String _metastasisLocation(
    MetastasisLocation e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case MetastasisLocation.none:
        return l10n.oncology_metastasisLocation_none;
      case MetastasisLocation.lymphNode:
        return l10n.oncology_metastasisLocation_lymphNode;
      case MetastasisLocation.dermalLymphatic:
        return l10n.oncology_metastasisLocation_dermalLymphatic;
      case MetastasisLocation.distant:
        return l10n.oncology_metastasisLocation_distant;
      case MetastasisLocation.unknown:
        return l10n.oncology_metastasisLocation_unknown;
    }
  }

  static String _clinicalStage(ClinicalStage e, AppLocalizations l10n) {
    switch (e) {
      case ClinicalStage.iib:
        return l10n.oncology_clinicalStage_iib;
      case ClinicalStage.iia:
        return l10n.oncology_clinicalStage_iia;
      case ClinicalStage.ia:
        return l10n.oncology_clinicalStage_ia;
      case ClinicalStage.iiib:
        return l10n.oncology_clinicalStage_iiib;
      case ClinicalStage.ib:
        return l10n.oncology_clinicalStage_ib;
      case ClinicalStage.iiia:
        return l10n.oncology_clinicalStage_iiia;
      case ClinicalStage.iv:
        return l10n.oncology_clinicalStage_iv;
      case ClinicalStage.iiic:
        return l10n.oncology_clinicalStage_iiic;
      case ClinicalStage.unknown:
        return l10n.oncology_clinicalStage_unknown;
    }
  }

  static String _chemotherapyRegimen(
    ChemotherapyRegimen e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case ChemotherapyRegimen.anthracyclinePlusTaxane:
        return l10n.oncology_chemotherapyRegimen_anthracyclinePlusTaxane;
      case ChemotherapyRegimen.taxaneOnly:
        return l10n.oncology_chemotherapyRegimen_taxaneOnly;
      case ChemotherapyRegimen.anthracyclineOnly:
        return l10n.oncology_chemotherapyRegimen_anthracyclineOnly;
      case ChemotherapyRegimen.platinumAdded:
        return l10n.oncology_chemotherapyRegimen_platinumAdded;
      case ChemotherapyRegimen.unknown:
        return l10n.oncology_chemotherapyRegimen_unknown;
    }
  }

  static String _chemotherapyCycleDensity(
    ChemotherapyCycleDensity e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case ChemotherapyCycleDensity.incomplete:
        return l10n.oncology_chemotherapyCycleDensity_incomplete;
      case ChemotherapyCycleDensity.full:
        return l10n.oncology_chemotherapyCycleDensity_full;
      case ChemotherapyCycleDensity.intensive:
        return l10n.oncology_chemotherapyCycleDensity_intensive;
      case ChemotherapyCycleDensity.unknown:
        return l10n.oncology_chemotherapyCycleDensity_unknown;
    }
  }

  // --- Demography ---

  static String _breastSide(BreastSide e, AppLocalizations l10n) {
    switch (e) {
      case BreastSide.right:
        return l10n.demography_breastSide_right;
      case BreastSide.left:
        return l10n.demography_breastSide_left;
      case BreastSide.unknown:
        return l10n.demography_breastSide_unknown;
    }
  }

  static String _bmi(BMI e, AppLocalizations l10n) {
    switch (e) {
      case BMI.grade2Obese:
        return l10n.demography_bmi_grade2Obese;
      case BMI.overweight:
        return l10n.demography_bmi_overweight;
      case BMI.normal:
        return l10n.demography_bmi_normal;
      case BMI.grade1Obese:
        return l10n.demography_bmi_grade1Obese;
      case BMI.underweight:
        return l10n.demography_bmi_underweight;
      case BMI.grade3Obese:
        return l10n.demography_bmi_grade3Obese;
      case BMI.unknown:
        return l10n.demography_bmi_unknown;
    }
  }

  static String _ageAtDiagnosis(AgeAtDiagnosis e, AppLocalizations l10n) {
    switch (e) {
      case AgeAtDiagnosis.lateMiddleAge:
        return l10n.demography_ageAtDiagnosis_lateMiddleAge;
      case AgeAtDiagnosis.earlyMiddleAge:
        return l10n.demography_ageAtDiagnosis_earlyMiddleAge;
      case AgeAtDiagnosis.middleAge:
        return l10n.demography_ageAtDiagnosis_middleAge;
      case AgeAtDiagnosis.youngAdult:
        return l10n.demography_ageAtDiagnosis_youngAdult;
      case AgeAtDiagnosis.elderly:
        return l10n.demography_ageAtDiagnosis_elderly;
      case AgeAtDiagnosis.veryElderly:
        return l10n.demography_ageAtDiagnosis_veryElderly;
      case AgeAtDiagnosis.unknown:
        return l10n.demography_ageAtDiagnosis_unknown;
    }
  }

  static String _bloodType(BloodType e, AppLocalizations l10n) {
    switch (e) {
      case BloodType.aPositive:
        return l10n.demography_bloodType_aPositive;
      case BloodType.bPositive:
        return l10n.demography_bloodType_bPositive;
      case BloodType.oPositive:
        return l10n.demography_bloodType_oPositive;
      case BloodType.abNegative:
        return l10n.demography_bloodType_abNegative;
      case BloodType.oNegative:
        return l10n.demography_bloodType_oNegative;
      case BloodType.aNegative:
        return l10n.demography_bloodType_aNegative;
      case BloodType.abPositive:
        return l10n.demography_bloodType_abPositive;
      case BloodType.bNegative:
        return l10n.demography_bloodType_bNegative;
      case BloodType.unknown:
        return l10n.demography_bloodType_unknown;
    }
  }

  static String _menopause(Menopause e, AppLocalizations l10n) {
    switch (e) {
      case Menopause.present:
        return l10n.demography_menopause_present;
      case Menopause.absent:
        return l10n.demography_menopause_absent;
      case Menopause.unknown:
        return l10n.demography_menopause_unknown;
    }
  }

  static String _sunExposure(SunExposure e, AppLocalizations l10n) {
    switch (e) {
      case SunExposure.high:
        return l10n.demography_sunExposure_high;
      case SunExposure.medium:
        return l10n.demography_sunExposure_medium;
      case SunExposure.low:
        return l10n.demography_sunExposure_low;
      case SunExposure.unknown:
        return l10n.demography_sunExposure_unknown;
    }
  }

  // --- Comorbidity ---

  static String _presence(Presence e, AppLocalizations l10n) {
    switch (e) {
      case Presence.present:
        return l10n.comorbidity_presence_present;
      case Presence.absent:
        return l10n.comorbidity_presence_absent;
      case Presence.unknown:
        return l10n.comorbidity_presence_unknown;
    }
  }

  static String _presenceNegative(PresenceNegative e, AppLocalizations l10n) {
    switch (e) {
      case PresenceNegative.present:
        return l10n.comorbidity_presenceNegative_present;
      case PresenceNegative.absent:
        return l10n.comorbidity_presenceNegative_absent;
      case PresenceNegative.unk:
        return l10n.comorbidity_presenceNegative_unk;
    }
  }

  // --- Biochemistry ---

  static String _biochemistryLevel(BiochemistryLevel e, AppLocalizations l10n) {
    switch (e) {
      case BiochemistryLevel.normal:
        return l10n.biochemistry_biochemistryLevel_normal;
      case BiochemistryLevel.high:
        return l10n.biochemistry_biochemistryLevel_high;
      case BiochemistryLevel.low:
        return l10n.biochemistry_biochemistryLevel_low;
      case BiochemistryLevel.unknown:
        return l10n.biochemistry_biochemistryLevel_unknown;
    }
  }

  // --- Radiology ---

  static String _biradsValue(BiradsValue e, AppLocalizations l10n) {
    switch (e) {
      case BiradsValue.c4c:
        return l10n.radiology_biradsValue_c4c;
      case BiradsValue.zero:
        return l10n.radiology_biradsValue_zero;
      case BiradsValue.five:
        return l10n.radiology_biradsValue_five;
      case BiradsValue.b4b:
        return l10n.radiology_biradsValue_b4b;
      case BiradsValue.a4a:
        return l10n.radiology_biradsValue_a4a;
      case BiradsValue.two:
        return l10n.radiology_biradsValue_two;
      case BiradsValue.one:
        return l10n.radiology_biradsValue_one;
      case BiradsValue.unknown:
        return l10n.radiology_biradsValue_unknown;
    }
  }

  static String _breastDensity(BreastDensity e, AppLocalizations l10n) {
    switch (e) {
      case BreastDensity.b:
        return l10n.radiology_breastDensity_b;
      case BreastDensity.d:
        return l10n.radiology_breastDensity_d;
      case BreastDensity.c:
        return l10n.radiology_breastDensity_c;
      case BreastDensity.a:
        return l10n.radiology_breastDensity_a;
      case BreastDensity.unknown:
        return l10n.radiology_breastDensity_unknown;
    }
  }

  static String _localization(Localization e, AppLocalizations l10n) {
    switch (e) {
      case Localization.lowerOuterQuadrant:
        return l10n.radiology_localization_lowerOuterQuadrant;
      case Localization.otherDirections:
        return l10n.radiology_localization_otherDirections;
      case Localization.retroareolarCentral:
        return l10n.radiology_localization_retroareolarCentral;
      case Localization.upperOuterQuadrant:
        return l10n.radiology_localization_upperOuterQuadrant;
      case Localization.upperInnerQuadrant:
        return l10n.radiology_localization_upperInnerQuadrant;
      case Localization.lowerInnerQuadrant:
        return l10n.radiology_localization_lowerInnerQuadrant;
      case Localization.unknown:
        return l10n.radiology_localization_unknown;
    }
  }

  static String _lesionType(LesionType e, AppLocalizations l10n) {
    switch (e) {
      case LesionType.solidMass:
        return l10n.radiology_lesionType_solidMass;
      case LesionType.asymmetry:
        return l10n.radiology_lesionType_asymmetry;
      case LesionType.calcification:
        return l10n.radiology_lesionType_calcification;
      case LesionType.architecturalDistortion:
        return l10n.radiology_lesionType_architecturalDistortion;
      case LesionType.unknown:
        return l10n.radiology_lesionType_unknown;
    }
  }

  static String _architecturalStructure(
    ArchitecturalStructure e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case ArchitecturalStructure.accompanyingMass:
        return l10n.radiology_architecturalStructure_accompanyingMass;
      case ArchitecturalStructure.alone:
        return l10n.radiology_architecturalStructure_alone;
      case ArchitecturalStructure.accompanyingCalcification:
        return l10n.radiology_architecturalStructure_accompanyingCalcification;
      case ArchitecturalStructure.unknown:
        return l10n.radiology_architecturalStructure_unknown;
    }
  }

  static String _massShape(MassShape e, AppLocalizations l10n) {
    switch (e) {
      case MassShape.irregular:
        return l10n.radiology_massShape_irregular;
      case MassShape.oval:
        return l10n.radiology_massShape_oval;
      case MassShape.round:
        return l10n.radiology_massShape_round;
      case MassShape.unknown:
        return l10n.radiology_massShape_unknown;
    }
  }

  static String _massContour(MassContour e, AppLocalizations l10n) {
    switch (e) {
      case MassContour.spiculated:
        return l10n.radiology_massContour_spiculated;
      case MassContour.smooth:
        return l10n.radiology_massContour_smooth;
      case MassContour.microlobulated:
        return l10n.radiology_massContour_microlobulated;
      case MassContour.irregular:
        return l10n.radiology_massContour_irregular;
      case MassContour.indistinct:
        return l10n.radiology_massContour_indistinct;
      case MassContour.unknown:
        return l10n.radiology_massContour_unknown;
    }
  }

  static String _massDensity(MassDensity e, AppLocalizations l10n) {
    switch (e) {
      case MassDensity.highDensity:
        return l10n.radiology_massDensity_highDensity;
      case MassDensity.equalDensity:
        return l10n.radiology_massDensity_equalDensity;
      case MassDensity.lowDensity:
        return l10n.radiology_massDensity_lowDensity;
      case MassDensity.unknown:
        return l10n.radiology_massDensity_unknown;
    }
  }

  static String _calcificationMorphology(
    CalcificationMorphology e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case CalcificationMorphology.amorphous:
        return l10n.radiology_calcificationMorphology_amorphous;
      case CalcificationMorphology.noCalcification:
        return l10n.radiology_calcificationMorphology_noCalcification;
      case CalcificationMorphology.pleomorphic:
        return l10n.radiology_calcificationMorphology_pleomorphic;
      case CalcificationMorphology.definitelyBenign:
        return l10n.radiology_calcificationMorphology_definitelyBenign;
      case CalcificationMorphology.coarsePopcorn:
        return l10n.radiology_calcificationMorphology_coarsePopcorn;
      case CalcificationMorphology.fineLinear:
        return l10n.radiology_calcificationMorphology_fineLinear;
      case CalcificationMorphology.roundPunctate:
        return l10n.radiology_calcificationMorphology_roundPunctate;
      case CalcificationMorphology.unknown:
        return l10n.radiology_calcificationMorphology_unknown;
    }
  }

  static String _calcificationDistribution(
    CalcificationDistribution e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case CalcificationDistribution.linear:
        return l10n.radiology_calcificationDistribution_linear;
      case CalcificationDistribution.noCalcification:
        return l10n.radiology_calcificationDistribution_noCalcification;
      case CalcificationDistribution.grouped:
        return l10n.radiology_calcificationDistribution_grouped;
      case CalcificationDistribution.segmental:
        return l10n.radiology_calcificationDistribution_segmental;
      case CalcificationDistribution.diffuse:
        return l10n.radiology_calcificationDistribution_diffuse;
      case CalcificationDistribution.regional:
        return l10n.radiology_calcificationDistribution_regional;
      case CalcificationDistribution.unknown:
        return l10n.radiology_calcificationDistribution_unknown;
    }
  }

  static String _asymmetry(Asymmetry e, AppLocalizations l10n) {
    switch (e) {
      case Asymmetry.noAsymmetry:
        return l10n.radiology_asymmetry_noAsymmetry;
      case Asymmetry.global:
        return l10n.radiology_asymmetry_global;
      case Asymmetry.focal:
        return l10n.radiology_asymmetry_focal;
      case Asymmetry.singleProjection:
        return l10n.radiology_asymmetry_singleProjection;
      case Asymmetry.developing:
        return l10n.radiology_asymmetry_developing;
      case Asymmetry.unknown:
        return l10n.radiology_asymmetry_unknown;
    }
  }

  static String _multifocalityStatus(
    MultifocalityStatus e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case MultifocalityStatus.noSingleFocus:
        return l10n.radiology_multifocalityStatus_noSingleFocus;
      case MultifocalityStatus.multifocal:
        return l10n.radiology_multifocalityStatus_multifocal;
      case MultifocalityStatus.notEvaluable:
        return l10n.radiology_multifocalityStatus_notEvaluable;
      case MultifocalityStatus.multicentric:
        return l10n.radiology_multifocalityStatus_multicentric;
      case MultifocalityStatus.unknown:
        return l10n.radiology_multifocalityStatus_unknown;
    }
  }

  static String _stableMassFor2Years(
    StableMassFor2Years e,
    AppLocalizations l10n,
  ) {
    switch (e) {
      case StableMassFor2Years.unknown:
        return l10n.radiology_stableMassFor2Years_unknown;
      case StableMassFor2Years.no:
        return l10n.radiology_stableMassFor2Years_no;
      case StableMassFor2Years.yes:
        return l10n.radiology_stableMassFor2Years_yes;
      case StableMassFor2Years.dataUnknown:
        return l10n.radiology_stableMassFor2Years_dataUnknown;
    }
  }

  static String _skinRetraction(SkinRetraction e, AppLocalizations l10n) {
    switch (e) {
      case SkinRetraction.no:
        return l10n.radiology_skinRetraction_no;
      case SkinRetraction.yes:
        return l10n.radiology_skinRetraction_yes;
      case SkinRetraction.singleProjectionSuspicious:
        return l10n.radiology_skinRetraction_singleProjectionSuspicious;
      case SkinRetraction.unknown:
        return l10n.radiology_skinRetraction_unknown;
    }
  }

  static String _nippleRetraction(NippleRetraction e, AppLocalizations l10n) {
    switch (e) {
      case NippleRetraction.no:
        return l10n.radiology_nippleRetraction_no;
      case NippleRetraction.yes:
        return l10n.radiology_nippleRetraction_yes;
      case NippleRetraction.singleProjectionSuspicious:
        return l10n.radiology_nippleRetraction_singleProjectionSuspicious;
      case NippleRetraction.unknown:
        return l10n.radiology_nippleRetraction_unknown;
    }
  }

  static String _surgeryHistory(SurgeryHistory e, AppLocalizations l10n) {
    switch (e) {
      case SurgeryHistory.no:
        return l10n.radiology_surgeryHistory_no;
      case SurgeryHistory.yes:
        return l10n.radiology_surgeryHistory_yes;
      case SurgeryHistory.unknown:
        return l10n.radiology_surgeryHistory_unknown;
    }
  }

  static String _cosmeticImplant(CosmeticImplant e, AppLocalizations l10n) {
    switch (e) {
      case CosmeticImplant.no:
        return l10n.radiology_cosmeticImplant_no;
      case CosmeticImplant.yes:
        return l10n.radiology_cosmeticImplant_yes;
      case CosmeticImplant.unknown:
        return l10n.radiology_cosmeticImplant_unknown;
    }
  }

  /// Key (alan adı) ve value (enum name) ile displayText döndürür
  ///
  /// Örnek:
  /// getDisplayTextByFieldName('histologicalType', 'idc', 'pathology')
  /// → 'İnvaziv Duktal Karsinom-1' döner
  static String getDisplayTextByFieldName(
    String fieldName,
    String enumValue,
    String categoryKey,
  ) {
    if (enumValue.isEmpty) return L10n.current.common_unspecified;

    try {
      // İlgili kategorinin dropdown config'ini al
      List<Map<String, dynamic>> configs;

      switch (categoryKey) {
        case 'pathology':
          configs = Pathology.getDropdownConfigs();
          break;
        case 'oncology':
          configs = Oncology.getDropdownConfigs();
          break;
        case 'demography':
          configs = Demography.getDropdownConfigs();
          break;
        case 'comorbidity':
          configs = Comorbidity.getDropdownConfigs();
          break;
        case 'biochemistry':
          configs = Biochemistry.getDropdownConfigs();
          break;
        case 'radiology':
          configs = Radiology.getDropdownConfigs();
          break;
        default:
          return enumValue;
      }

      // Field name'e karşılık gelen enum listesini bul
      for (var config in configs) {
        if (config['key'] == fieldName) {
          List<Enum> enumValues = config['values'] as List<Enum>;

          // Enum value'yu name ile bul
          try {
            Enum foundEnum = enumValues.firstWhere((e) => e.name == enumValue);
            return getDisplayText(foundEnum);
          } catch (e) {
            return enumValue; // Bulunamazsa value'yu döndür
          }
        }
      }

      return enumValue; // Config bulunamazsa value'yu döndür
    } catch (e) {
      return enumValue; // Hata olursa value'yu döndür
    }
  }

  /// Bir kategori + alan anahtarı için kullanıcıya gösterilecek etiketi döner.
  ///
  /// Domain katmanı (categories/*.dart) saf Dart kalması gerektiğinden alan
  /// etiketleri orada literal olarak tutulmuyor; bu metot categoryKey +
  /// fieldKey çiftini l10n anahtarına çevirir.
  static String getFieldLabel(String categoryKey, String fieldKey) {
    final l10n = L10n.current;
    switch ('${categoryKey}_$fieldKey') {
      case 'pathology_histologicalType':
        return l10n.pathology_histologicalType_label;
      case 'pathology_er':
        return l10n.pathology_er_label;
      case 'pathology_pr':
        return l10n.pathology_pr_label;
      case 'pathology_her2':
        return l10n.pathology_her2_label;
      case 'pathology_molecularType':
        return l10n.pathology_molecularType_label;
      case 'pathology_ki67':
        return l10n.pathology_ki67_label;
      case 'pathology_tubuleGrade':
        return l10n.pathology_tubuleGrade_label;
      case 'pathology_nuclearGrade':
        return l10n.pathology_nuclearGrade_label;
      case 'pathology_mitoticGrade':
        return l10n.pathology_mitoticGrade_label;
      case 'pathology_histologicalGrade':
        return l10n.pathology_histologicalGrade_label;
      case 'pathology_eCadherin':
        return l10n.pathology_eCadherin_label;
      case 'pathology_til':
        return l10n.pathology_til_label;

      case 'oncology_metastasisStatus':
        return l10n.oncology_metastasisStatus_label;
      case 'oncology_metastasisLocation':
        return l10n.oncology_metastasisLocation_label;
      case 'oncology_clinicalStage':
        return l10n.oncology_clinicalStage_label;
      case 'oncology_chemotherapyRegimen':
        return l10n.oncology_chemotherapyRegimen_label;
      case 'oncology_chemotherapyCycleDensity':
        return l10n.oncology_chemotherapyCycleDensity_label;

      case 'demography_breastSide':
        return l10n.demography_breastSide_label;
      case 'demography_bmi':
        return l10n.demography_bmi_label;
      case 'demography_ageAtDiagnosis':
        return l10n.demography_ageAtDiagnosis_label;
      case 'demography_bloodType':
        return l10n.demography_bloodType_label;
      case 'demography_menopause':
        return l10n.demography_menopause_label;
      case 'demography_sunExposure':
        return l10n.demography_sunExposure_label;

      case 'comorbidity_ht':
        return l10n.comorbidity_ht_label;
      case 'comorbidity_dm':
        return l10n.comorbidity_dm_label;
      case 'comorbidity_copd':
        return l10n.comorbidity_copd_label;
      case 'comorbidity_smoking':
        return l10n.comorbidity_smoking_label;
      case 'comorbidity_familyHistoryOfBreastCa':
        return l10n.comorbidity_familyHistoryOfBreastCa_label;
      case 'comorbidity_thyroidDisease':
        return l10n.comorbidity_thyroidDisease_label;
      case 'comorbidity_retinopathy':
        return l10n.comorbidity_retinopathy_label;
      case 'comorbidity_neuropathy':
        return l10n.comorbidity_neuropathy_label;
      case 'comorbidity_osteoporosis':
        return l10n.comorbidity_osteoporosis_label;
      case 'comorbidity_depression':
        return l10n.comorbidity_depression_label;

      case 'biochemistry_alp':
        return l10n.biochemistry_alp_label;
      case 'biochemistry_alt':
        return l10n.biochemistry_alt_label;
      case 'biochemistry_ast':
        return l10n.biochemistry_ast_label;
      case 'biochemistry_bun':
        return l10n.biochemistry_bun_label;
      case 'biochemistry_ca153':
        return l10n.biochemistry_ca153_label;
      case 'biochemistry_cea':
        return l10n.biochemistry_cea_label;
      case 'biochemistry_crp':
        return l10n.biochemistry_crp_label;
      case 'biochemistry_ggt':
        return l10n.biochemistry_ggt_label;
      case 'biochemistry_glucose':
        return l10n.biochemistry_glucose_label;
      case 'biochemistry_hba1c':
        return l10n.biochemistry_hba1c_label;
      case 'biochemistry_creatinine':
        return l10n.biochemistry_creatinine_label;
      case 'biochemistry_ldh':
        return l10n.biochemistry_ldh_label;
      case 'biochemistry_tsh':
        return l10n.biochemistry_tsh_label;
      case 'biochemistry_egfr':
        return l10n.biochemistry_egfr_label;

      case 'radiology_biradsValue':
        return l10n.radiology_biradsValue_label;
      case 'radiology_breastDensity':
        return l10n.radiology_breastDensity_label;
      case 'radiology_localization':
        return l10n.radiology_localization_label;
      case 'radiology_lesionType':
        return l10n.radiology_lesionType_label;
      case 'radiology_architecturalStructure':
        return l10n.radiology_architecturalStructure_label;
      case 'radiology_massShape':
        return l10n.radiology_massShape_label;
      case 'radiology_massContour':
        return l10n.radiology_massContour_label;
      case 'radiology_massDensity':
        return l10n.radiology_massDensity_label;
      case 'radiology_calcificationMorphology':
        return l10n.radiology_calcificationMorphology_label;
      case 'radiology_calcificationDistribution':
        return l10n.radiology_calcificationDistribution_label;
      case 'radiology_asymmetry':
        return l10n.radiology_asymmetry_label;
      case 'radiology_multifocalityStatus':
        return l10n.radiology_multifocalityStatus_label;
      case 'radiology_stableMassFor2Years':
        return l10n.radiology_stableMassFor2Years_label;
      case 'radiology_skinRetraction':
        return l10n.radiology_skinRetraction_label;
      case 'radiology_nippleRetraction':
        return l10n.radiology_nippleRetraction_label;
      case 'radiology_surgeryHistory':
        return l10n.radiology_surgeryHistory_label;
      case 'radiology_cosmeticImplant':
        return l10n.radiology_cosmeticImplant_label;

      default:
        return fieldKey; // Anahtar bulunamazsa alan adı fallback
    }
  }
}
