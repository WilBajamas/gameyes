import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

import '../generated/l10n.dart';

class DefaultBorderTextField extends StatelessWidget {
  final BuildContext context;
  final TextInputType? inputType;
  final TextEditingController? textEditingController;
  final bool isRequired;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String title;
  final int? minLines;
  final int? maxLines;
  final String? hint;
  final bool readOnly;
  final VoidCallback? onClicked;
  final Function(String)? onChanged;
  final int? maxLength;
  final bool maxLengthEnforce;

  const DefaultBorderTextField({
    required this.context,
    required this.title,
    this.inputType = TextInputType.text,
    this.textEditingController,
    this.isRequired = false,
    this.prefixIcon,
    this.suffixIcon,
    this.minLines,
    this.maxLines = 1,
    this.hint,
    this.readOnly = false,
    this.onClicked,
    this.onChanged,
    this.maxLength,
    this.maxLengthEnforce = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: inputType,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      maxLengthEnforcement:
          maxLengthEnforce ? MaxLengthEnforcement.enforced : null,
      readOnly: readOnly,
      style: const TextStyle().copyWith(
        color: context.themeData.colorScheme.onSurface,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        hintText: hint ?? '',
        alignLabelWithHint: true,
        hintStyle:
            context.themeData.textTheme.bodySmall!.copyWith(color: Colors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        labelText: title,
      ),
      onChanged: onChanged,
      onTap: onClicked,
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return S.current.please_enter_value;
              }
              return null;
            }
          : null,
    );
  }
}
