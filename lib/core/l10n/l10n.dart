import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';

/// BuildContext'i olmayan katmanlar (ViewModel, util) için lokalizasyon erişimi.
///
/// Widget içindeysen bunu KULLANMA — doğrudan `AppLocalizations.of(context)`
/// çağır. Bu yardımcı yalnızca context'in bulunmadığı yerler için bir kaçış
/// kapısı; navigator henüz bağlanmamışsa hata fırlatır.
class L10n {
  const L10n._();

  static AppLocalizations get current {
    final context = NavigationService.instance.navigatorKey.currentContext;
    if (context == null) {
      throw StateError(
        'L10n.current navigator bağlanmadan çağrıldı. '
        'Widget ağacı içindeysen AppLocalizations.of(context) kullan.',
      );
    }
    return AppLocalizations.of(context)!;
  }
}
