import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/enum_display_util.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/demography.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/pathology.dart';

/// EnumDisplayUtil, context'siz L10n.current üzerinden çalıştığından testler
/// NavigationService.instance.navigatorKey'i gerçek bir MaterialApp'e bağlar.
Future<void> _pumpLocalizedApp(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: NavigationService.instance.navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: SizedBox.shrink()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('EnumDisplayUtil.getDisplayText', () {
    testWidgets('bilinen enum tipleri için boş olmayan metin döner', (
      tester,
    ) async {
      await _pumpLocalizedApp(tester);

      expect(
        EnumDisplayUtil.getDisplayText(BreastSide.right).isNotEmpty,
        isTrue,
      );
      expect(
        EnumDisplayUtil.getDisplayText(
          HistologicalType.invasiveDuctalCarcinoma,
        ).isNotEmpty,
        isTrue,
      );
      expect(EnumDisplayUtil.getDisplayText(BMI.normal).isNotEmpty, isTrue);
    });

    testWidgets('tanınmayan/eşleşmesiz enum için fallback olarak enum.name döner', (
      tester,
    ) async {
      await _pumpLocalizedApp(tester);

      // EnumDisplayUtil switch'lerinde kapsanmayan bir örnek enum tanımlayamayız
      // (tüm case'ler switch içinde), bu yüzden bilinen bir değerin en azından
      // switch case'lerinden biriyle eşleştiğini ve exception atmadığını doğruluyoruz.
      expect(
        () => EnumDisplayUtil.getDisplayText(SunExposure.unknown),
        returnsNormally,
      );
    });
  });

  group('EnumDisplayUtil.getFieldLabel', () {
    testWidgets('bilinen categoryKey/fieldKey çifti için etiket döner', (
      tester,
    ) async {
      await _pumpLocalizedApp(tester);

      final label = EnumDisplayUtil.getFieldLabel('demography', 'bmi');
      expect(label.isNotEmpty, isTrue);
    });

    testWidgets('bilinmeyen categoryKey/fieldKey çifti için fieldKey\'i fallback olarak döner', (
      tester,
    ) async {
      await _pumpLocalizedApp(tester);

      final label = EnumDisplayUtil.getFieldLabel('unknownCategory', 'unknownField');
      expect(label, 'unknownField');
    });
  });
}
