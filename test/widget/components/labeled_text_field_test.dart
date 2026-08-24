import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/labeled_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildSubject({required Widget field, GlobalKey<FormState>? formKey}) {
    return MaterialApp(
      theme: buildDarkTheme(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: Form(key: formKey, child: field),
      ),
    );
  }

  testWidgets(
    'shows the required message when an empty required field is validated',
    (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildSubject(
          formKey: formKey,
          field: LabeledTextField(label: 'Title', isRequired: true),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text(S.current.please_enter_value), findsOneWidget);
    },
  );

  testWidgets('calls onClicked when a read-only field is tapped', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      buildSubject(
        field: LabeledTextField(
          label: 'From',
          readOnly: true,
          onClicked: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));

    expect(tapped, isTrue);
  });

  testWidgets('shows the character count once when a maximum length is set', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(field: LabeledTextField(label: 'Title', maxLength: 30)),
    );

    expect(find.text('0/30'), findsOneWidget);
  });
}
