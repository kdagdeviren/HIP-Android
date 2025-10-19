import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/pathology.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/oncology.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/demography.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/comorbidity.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/biochemistry.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/radiology.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/pet.dart';

class EnumDisplayUtil {
  static String getDisplayText(Enum e) {
    if (e is HistologicalType) return e.displayText;
    if (e is ERStatus) return e.displayText;
    if (e is PRStatus) return e.displayText;
    if (e is HER2Status) return e.displayText;
    if (e is MolecularType) return e.displayText;
    if (e is Ki67Level) return e.displayText;
    if (e is TubuleGrade) return e.displayText;
    if (e is NuclearGrade) return e.displayText;
    if (e is MitoticGrade) return e.displayText;
    if (e is HistologicalGrade) return e.displayText;
    if (e is ECadherinStatus) return e.displayText;
    if (e is TILLevel) return e.displayText;

    // Oncology enums
    if (e is MetastasisStatus) return e.displayText;
    if (e is MetastasisLocation) return e.displayText;
    if (e is ClinicalStage) return e.displayText;
    if (e is ChemotherapyRegimen) return e.displayText;
    if (e is ChemotherapyCycleDensity) return e.displayText;

    // Demography enums
    if (e is BreastSide) return e.displayText;
    if (e is BMI) return e.displayText;
    if (e is AgeAtDiagnosis) return e.displayText;
    if (e is BloodType) return e.displayText;
    if (e is Menopause) return e.displayText;
    if (e is SunExposure) return e.displayText;

    // Comorbidity enums
    if (e is Presence) return e.displayText;
    if (e is PresenceNegative) return e.displayText;

    // Biochemistry enums
    if (e is BiochemistryLevel) return e.displayText;

    // Radiology enums
    if (e is BiradsValue) return e.displayText;
    if (e is BreastDensity) return e.displayText;
    if (e is Localization) return e.displayText;
    if (e is LesionType) return e.displayText;
    if (e is ArchitecturalStructure) return e.displayText;
    if (e is MassShape) return e.displayText;
    if (e is MassContour) return e.displayText;
    if (e is MassDensity) return e.displayText;
    if (e is CalcificationMorphology) return e.displayText;
    if (e is CalcificationDistribution) return e.displayText;
    if (e is Asymmetry) return e.displayText;
    if (e is MultifocalityStatus) return e.displayText;
    if (e is StableMassFor2Years) return e.displayText;
    if (e is SkinRetraction) return e.displayText;
    if (e is NippleRetraction) return e.displayText;
    if (e is SurgeryHistory) return e.displayText;
    if (e is CosmeticImplant) return e.displayText;

    // PET enums
    if (e is PETResult) return e.displayText;

    return e.name; // Fallback
  }

  /// Key (alan adı) ve value (enum name) ile displayText döndürür
  ///
  /// Örnek:
  /// getDisplayTextByFieldName('histologicalType', 'idc', 'pathology')
  /// → 'İnvaziv Duktal Karsinom' döner
  static String getDisplayTextByFieldName(
    String fieldName,
    String enumValue,
    String categoryKey,
  ) {
    if (enumValue.isEmpty) return "Belirtilmemiş";

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
        case 'pet':
          configs = PET.getDropdownConfigs();
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
}
