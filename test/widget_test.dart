// Bu app'te sayaç (counter) yok; `flutter create` şablonunun varsayılan testi
// doğrudan Firebase/Provider'a bağımlı MyApp'i pump ediyordu ve o bağımlılıklar
// olmadan çöküyordu. Onun yerine l10n kablolamasının çalıştığını doğrulayan
// hafif bir smoke test kullanılıyor.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';

void main() {
  testWidgets('AppLocalizations MaterialApp içinde doğru şekilde çözülür', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context)!.app_title);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(
      tester.element(find.byType(Text)),
    )!;
    expect(find.text(l10n.app_title), findsOneWidget);
  });
}
