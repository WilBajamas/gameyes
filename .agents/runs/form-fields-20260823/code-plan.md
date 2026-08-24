# Code Plan
Source: `tech-ac.md` — week 2 Stage 2 item 2.5 Form fields (`system-foundation-specs.md` §3.2)
Date: 2026-08-24

## CREATE NEW

### lib/widgets/labeled_text_field.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

import '../generated/l10n.dart';

class LabeledTextField extends StatefulWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.placeholder,
    this.helper,
    this.prefixIcon,
    this.inputType = TextInputType.text,
    this.isRequired = false,
    this.readOnly = false,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.enforceMaxLength = false,
    this.onChanged,
    this.onClicked,
  });

  final String label;
  final TextEditingController? controller;
  final String? placeholder;
  final String? helper;
  final Widget? prefixIcon;
  final TextInputType? inputType;
  final bool isRequired;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool enforceMaxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClicked;

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() => setState(() {});

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.please_enter_value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return FormField<String>(
      initialValue: widget.controller?.text ?? '',
      validator: widget.isRequired ? _validateRequired : null,
      builder: (field) {
        final trailing = widget.maxLength != null
            ? '${field.value?.length ?? 0}/${widget.maxLength}'
            : widget.helper;

        final box = OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.lg),
          borderSide: field.hasError
              ? BorderSide(color: tokens.color.errorLine)
              : BorderSide.none,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            if (widget.label.isNotEmpty || trailing != null)
              _FieldLabelRow(label: widget.label, trailing: trailing),
            _FieldFocusRing(
              focused: _focusNode.hasFocus,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.inputType,
                readOnly: widget.readOnly,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                maxLengthEnforcement: widget.enforceMaxLength
                    ? MaxLengthEnforcement.enforced
                    : MaxLengthEnforcement.none,
                style: tokens.typography.body.style
                    .copyWith(color: tokens.color.ink),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: field.hasError
                      ? tokens.color.errorTint
                      : tokens.color.surfaceRaised,
                  hintText: widget.placeholder,
                  hintStyle: tokens.typography.body.style
                      .copyWith(color: tokens.color.ink55),
                  prefixIcon: widget.prefixIcon,
                  prefixIconColor: tokens.color.ink55,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: box,
                  enabledBorder: box,
                  focusedBorder: box,
                ),
                onChanged: (value) {
                  field.didChange(value);
                  widget.onChanged?.call(value);
                },
                onTap: widget.onClicked,
              ),
            ),
            if (field.hasError)
              Text(
                field.errorText!,
                style: tokens.typography.meta.style
                    .copyWith(color: tokens.color.errorInk),
              ),
          ],
        );
      },
    );
  }
}

class _FieldLabelRow extends StatelessWidget {
  const _FieldLabelRow({required this.label, required this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Text(
            label,
            style: tokens.typography.meta.style
                .copyWith(color: tokens.color.ink),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null)
          Text(trailing!, style: tokens.typography.caption.style),
      ],
    );
  }
}

class _FieldFocusRing extends StatelessWidget {
  const _FieldFocusRing({required this.focused, required this.child});

  final bool focused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: focused ? tokens.color.green : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(tokens.radius.lg + 4),
      ),
      child: child,
    );
  }
}
```

## MODIFY EXISTING

### lib/widgets/default_border_text_field.dart

Deleted in full.

### lib/widgets/add_content_dialog.dart

```dart
import 'package:gaming_library_assessment_flutter/widgets/labeled_text_field.dart';

// ...
                LabeledTextField(
                  controller: _titleTextController,
                  label: S.current.title,
                  isRequired: true,
                  enforceMaxLength: true,
                  maxLength: 30,
                  placeholder: S.current.keep_it_short,
                ),
                const SizedBox(height: 8),
                LabeledTextField(
                  controller: _descriptionTextController,
                  label: S.current.description,
                  inputType: TextInputType.multiline,
                  maxLines: null,
                  isRequired: true,
                  minLines: 5,
                  maxLength: 100,
                  enforceMaxLength: true,
                  placeholder: S.current.a_brief_description,
                ),
```

### lib/features/filter/presentation/widgets/filter_bottom_sheet.dart

```dart
import 'package:gaming_library_assessment_flutter/widgets/labeled_text_field.dart';

// ... search
                  LabeledTextField(
                    label: S.current.search_games,
                    controller: _searchTextController,
                    prefixIcon: const Icon(Icons.search),
                  ),

// ... date range, both fields
            Expanded(
              child: LabeledTextField(
                controller: _dateFromController,
                label: S.current.from,
                readOnly: true,
                onClicked: () => changeStartDate(
                  context,
                  widget.filterState.dateFrom,
                  widget.filterState.dateTo,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: LabeledTextField(
                controller: _dateToController,
                label: S.current.to,
                readOnly: true,
                onClicked: () => changeEndDate(
                  context,
                  widget.filterState.dateTo,
                  widget.filterState.dateFrom,
                ),
              ),
            ),
```

### lib/features/tracker/presentation/screens/task_detail_screen.dart

```dart
import 'package:gaming_library_assessment_flutter/widgets/labeled_text_field.dart';

// ... _TaskTitleState
              : LabeledTextField(
                  label: S.current.title,
                  maxLength: 30,
                ),

// ... _TaskDescriptionState
              : LabeledTextField(
                  label: S.current.description,
                  maxLength: 100,
                  maxLines: 5,
                ),
```

### .claude/skills/flutter-widgets/SKILL.md

```markdown
| `LabeledTextField` | `labeled_text_field.dart` | Text input with the label always above the box and the helper or character counter on that same label row: raised fill at r16 with no stroke at rest, 2px green focus ring drawn outside the box, error tint plus a 1px error hairline when invalid and the message below in error ink. Optional placeholder, prefix icon, multi-line and required validation; `readOnly` + `onClicked` makes it a tap target. Adds no spacing of its own |
```

(replacing the `DefaultBorderTextField` row; the "one file per widget family"
rule sentence is deliberately left untouched.)

## TEST FILES

### test/widget/components/labeled_text_field_test.dart

- `'shows the required message when an empty required field is validated'` —
  pumps the field inside a `Form` with a `GlobalKey<FormState>`, calls
  `validate()`, and expects `S.current.please_enter_value` on screen. Covers
  AC12 and the presence half of AC9.
- `'calls onClicked when a read-only field is tapped'` — taps the field and
  expects the callback fired; covers AC14's tap-target half.
- `'shows the character count once when a maximum length is set'` —
  `findsOneWidget` for the count text. The single match is the point: if
  Material's own below-field counter were not suppressed, the same string would
  render twice. Covers AC4.

No colour, dimension, radius or offset assertion; the fill swap, hairline, ring
and 44px floor are manual checks. Harness matches `context_chip_test.dart` /
`stat_pill_test.dart` — real `buildDarkTheme()`, `S.delegate`,
`GoogleFonts.config.allowRuntimeFetching = false`, no `setUpAll` token
resolution.
