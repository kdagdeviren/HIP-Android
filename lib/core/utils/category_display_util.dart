import 'package:flutter_medical_data_app/core/l10n/l10n.dart';

/// Kategori kimliği (örn. 'pathology') için kullanıcıya gösterilecek adı döner.
///
/// Domain katmanı (categories_card_data.dart) saf Dart kalması gerektiğinden
/// kategori adı orada literal olarak tutulmuyor; bu yardımcı id'yi l10n
/// anahtarına çevirir.
class CategoryDisplayUtil {
  const CategoryDisplayUtil._();

  static String getName(String categoryId) {
    final l10n = L10n.current;
    switch (categoryId) {
      case 'pathology':
        return l10n.category_pathology_name;
      case 'oncology':
        return l10n.category_oncology_name;
      case 'demography':
        return l10n.category_demography_name;
      case 'comorbidity':
        return l10n.category_comorbidity_name;
      case 'biochemistry':
        return l10n.category_biochemistry_name;
      case 'radiology':
        return l10n.category_radiology_name;
      default:
        return categoryId; // Anahtar bulunamazsa id fallback
    }
  }
}
