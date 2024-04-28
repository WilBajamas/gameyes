import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_border_text_field.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          children: [
            _TaskTitle(),
            SizedBox(height: 8),
            _TaskDescription(),
            SizedBox(height: 16),
            _TaskReminder(),
            SizedBox(height: 20),
            _TaskSteps(
              stepsList: [
                ('Test', 'Test', 'featured_title_img.jpeg'),
                ('Test', 'Test', 'featured_title_img.jpeg'),
                ('Test', 'Test', 'featured_title_img.jpeg'),
                ('Test', 'Test', 'featured_title_img.jpeg'),
                ('Test', 'Test', 'featured_title_img.jpeg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTitle extends StatefulWidget {
  const _TaskTitle();

  @override
  State<_TaskTitle> createState() => _TaskTitleState();
}

class _TaskTitleState extends State<_TaskTitle> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: !_isEditing
              ? Text(
                  'Title here',
                  style: context.themeData.textTheme.displayLarge,
                )
              : DefaultBorderTextField(
                  context: context,
                  title: context.localisations.title,
                  maxLength: 30,
                ),
        ),
        const SizedBox(
          width: 8,
        ),
        IconButton(
          onPressed: () => setState(() => _isEditing = !_isEditing),
          icon: Icon(
            _isEditing ? Icons.done : Icons.edit,
            color: kColorScheme.primary,
          ),
          color: kColorScheme.onBackground,
        ),
      ],
    );
  }
}

class _TaskDescription extends StatefulWidget {
  const _TaskDescription();

  @override
  State<_TaskDescription> createState() => _TaskDescriptionState();
}

class _TaskDescriptionState extends State<_TaskDescription> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: !_isEditing
              ? Text(
                  'Description here',
                  style: context.themeData.textTheme.bodySmall,
                )
              : DefaultBorderTextField(
                  context: context,
                  title: context.localisations.description,
                  maxLength: 100,
                  maxLines: 5,
                ),
        ),
        IconButton(
          onPressed: () => setState(() => _isEditing = !_isEditing),
          color: kColorScheme.onBackground,
          icon: Icon(
            _isEditing ? Icons.done : Icons.edit,
            color: kColorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _TaskReminder extends StatelessWidget {
  const _TaskReminder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reminder',
              style: context.themeData.textTheme.headlineMedium,
            ),
            Switch(value: true, onChanged: (isChanged) {}),
          ],
        ),
        InkWell(
          onTap: () =>
              showTimePicker(context: context, initialTime: TimeOfDay.now()),
          child: Ink(
            decoration: BoxDecoration(
              color: kColorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '00:00:00',
                    style: context.themeData.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Daily',
                    style: context.themeData.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskSteps extends StatefulWidget {
  final List<(String title, String description, String? image)> stepsList;

  const _TaskSteps({required this.stepsList});

  @override
  State<_TaskSteps> createState() => _TaskStepsState();
}

class _TaskStepsState extends State<_TaskSteps> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      connectorColor: MaterialStateProperty.all<Color>(
        kColorScheme.primary,
      ),
      currentStep: _currentStep,
      controlsBuilder: (context, controller) {
        return Container();
      },
      physics: const NeverScrollableScrollPhysics(),
      onStepTapped: (step) => setState(() => _currentStep = step),
      steps: widget.stepsList.map((e) {
        final (title, description, image) = e;
        return Step(
          title: Text(title, style: context.themeData.textTheme.titleMedium),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description, style: context.themeData.textTheme.bodySmall),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/images/$image'),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
