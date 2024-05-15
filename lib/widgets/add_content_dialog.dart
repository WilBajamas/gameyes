import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_border_text_field.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_filled_button_full_width.dart';
import 'package:go_router/go_router.dart';

class AddContentDialog extends StatefulWidget {
  final (String?, String?)? titleDescription;
  final (String, String) dialogTitleAndSnackBarTitle;
  final Function(String, String) onCreatedClicked;

  const AddContentDialog({
    required this.onCreatedClicked,
    required this.dialogTitleAndSnackBarTitle,
    this.titleDescription,
    super.key,
  });

  @override
  State<AddContentDialog> createState() => _AddContentDialogState();
}

class _AddContentDialogState extends State<AddContentDialog> {
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.titleDescription case final values?) {
      final (title, description) = values;

      if (title != null) _titleTextController.text = title;
      if (description != null) _descriptionTextController.text = description;

      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.dialogTitleAndSnackBarTitle.$1,
                      style: context.themeData.textTheme.displayMedium,
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.cancel_outlined),
                      color: kColorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                DefaultBorderTextField(
                  textEditingController: _titleTextController,
                  context: context,
                  title: context.localisations.title,
                  minLines: 1,
                  isRequired: true,
                  maxLengthEnforce: true,
                  maxLength: 30,
                  hint: context.localisations.keep_it_short,
                ),
                const SizedBox(
                  height: 8,
                ),
                DefaultBorderTextField(
                  textEditingController: _descriptionTextController,
                  context: context,
                  title: context.localisations.description,
                  inputType: TextInputType.multiline,
                  maxLines: null,
                  isRequired: true,
                  minLines: 5,
                  maxLength: 100,
                  maxLengthEnforce: true,
                  hint: context.localisations.a_brief_description,
                ),
                const SizedBox(
                  height: 12,
                ),
                DefaultFilledButtonFullWidth(
                  context.localisations.save,
                  height: 40,
                  () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: kColorScheme.primary,
                          content: Text(
                            widget.dialogTitleAndSnackBarTitle.$2,
                            style: context.themeData.textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      );
                      widget.onCreatedClicked(
                        _titleTextController.text,
                        _descriptionTextController.text,
                      );
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
