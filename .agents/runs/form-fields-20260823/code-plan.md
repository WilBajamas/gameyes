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

## Approved feedback delta

Phase 3 gate, 2026-08-24. Authoritative over anything above and over `tdd.md` /
`task-brief.md` where they conflict. One change, the rest confirmations.

### Change — `task_detail_screen.dart`'s two editors pass `enforceMaxLength: true`

- The widget is unchanged from the plan above: `enforceMaxLength: false` still
  emits `MaxLengthEnforcement.none`, so the parameter means what its name says.
  **`[2.5-AC15]` stands unchanged.**
- The **two** `task_detail_screen.dart` sites — the 30-char title editor and the
  100-char description editor — each gain **`enforceMaxLength: true`**. They
  enforce today and they keep enforcing; the run ships no behaviour change on
  that screen. This supersedes the two `task_detail_screen.dart` snippets under
  `## MODIFY EXISTING` above, which show no `enforceMaxLength`.
- Rationale — the **"preserve what ships" precedent from item 1.9**: a promotion
  or rework moves code, it does not silently change a live screen's behaviour.
  The widget-level bug is fixed at the widget; no shipped surface changes
  behaviour as a result.

### The trap this closes, recorded so it survives the run

**`maxLengthEnforcement: null` does NOT mean "no enforcement."** It resolves
per-platform through `LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement`
(SDK `services/text_formatter.dart:517`): Android and Windows → `enforced`;
iOS, macOS, Linux, Fuchsia and web → `truncateAfterCompositionEnds`. **Both of
those enforce the limit** — the user cannot end up over it either way. So
`DefaultBorderTextField`'s `maxLengthEnforce: false` has always been *enforcing*,
and a future reader of the old code would get this backwards. `MaxLengthEnforcement.none`
is the only value that actually lets text past the limit, and after this run it
is the only way to ask for that.

*Residual difference, and it is the whole of it:* on Android, today's `null` and
the new `enforced` are identical. On the `truncateAfterCompositionEnds` platforms
the new `enforced` differs in one narrow case — an in-progress IME composition
(CJK, accent entry) that would cross the limit gets truncated mid-composition
rather than when the composition ends. Accepted: preserving that exactly would
mean re-admitting a tri-state or a `null` passthrough, which is the bug itself.

### Confirmations — the other five call sites, checked against the files

Read from the source files for this delta, not carried over from the earlier review:

| File | Sites | Today | After |
|---|---|---|---|
| `add_content_dialog.dart` | title (`maxLength: 30`), description (`maxLength: 100`) | both already pass `maxLengthEnforce: true` → `MaxLengthEnforcement.enforced` | carry over as `enforceMaxLength: true`. **No behaviour change on any platform** |
| `filter_bottom_sheet.dart` | search, date-from, date-to | **no `maxLength` at all** on any of the three | enforcement is moot — no `maxLength`, no `enforceMaxLength`. Nothing to preserve |
| `task_detail_screen.dart` | title, description | pass no `maxLengthEnforce` → defaults to `false` → `null` → enforced per platform | `enforceMaxLength: true` (the change above) |

The gate's reading of all three files was correct as stated; nothing to correct.

### Confirmations — no change

- **`.claude/skills/flutter-widgets/SKILL.md` stays in the allowlist**, catalogue
  row only. The "one file per widget family" rule sentence stays untouched.
- **Everything else in this plan is approved as written**: the `FormField<String>`
  composition, deleting `default_border_text_field.dart` rather than deprecating
  it, the single-file shape, all 7 sites rewired, the three tests.
- The **file allowlist is unchanged** — same 7 files, same one test file. This is
  a call-site argument change, not an acceptance-criterion change, so `tdd.md`
  and `task-brief.md` are not rewritten.

### Stale text this delta overrides

Read these with the delta, not instead of it:

- `tdd.md` decision **4**, final paragraph ("The two `task_detail_screen.dart`
  editors (30 and 100) are the affected sites: typing past the limit becomes
  possible there and the counter reads over its maximum") — **no longer true**.
  Decision 4's first half, that the widget passes `MaxLengthEnforcement.none`
  explicitly when the flag is false, still holds.
- `tdd.md` `## Call-site review`, both `task_detail_screen.dart` rows —
  "`maxLength: 30`/`100` now un-enforced per decision 4" — **no longer true**;
  both stay enforced.
- `task-brief.md` Step 4 ("both editors with the same renames") — the renames
  still apply, and each editor additionally gains `enforceMaxLength: true`, which
  has no counterpart at those sites to rename.
