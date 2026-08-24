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
                style: tokens.typography.body.style.copyWith(
                  color: tokens.color.ink,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: field.hasError
                      ? tokens.color.errorTint
                      : tokens.color.surfaceRaised,
                  hintText: widget.placeholder,
                  hintStyle: tokens.typography.body.style.copyWith(
                    color: tokens.color.ink55,
                  ),
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
                style: tokens.typography.meta.style.copyWith(
                  color: tokens.color.errorInk,
                ),
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
            style: tokens.typography.meta.style.copyWith(
              color: tokens.color.ink,
            ),
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
