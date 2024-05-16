import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/task_step.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubit/task_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/add_content_dialog.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_border_text_field.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_outlined_button.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_pop_up_button.dart';

class TaskDetailScreen extends StatefulWidget {
  final int? taskId;
  final Task? task;

  const TaskDetailScreen({this.taskId, this.task, super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  void initState() {
    context.read<TaskCubit>().setTask(task: widget.task!);
    if (widget.taskId case final id?) {
      context.read<TaskCubit>().listenToTask(taskId: id);
    }
    super.initState();
  }

  void showAddStepDialog(int? stepNumber) {
    if (widget.taskId case final id?) {
      showDialog(
        context: context,
        builder: (context) => AddContentDialog(
          dialogTitleAndSnackBarTitle: (
            context.localisations.add_step,
            context.localisations.step_added
          ),
          onCreatedClicked: (title, description) =>
              context.read<TaskCubit>().addStep(
                    taskId: id,
                    title: title,
                    description: description,
                    stepNumber: stepNumber ?? 1,
                  ),
        ),
      );
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            final task = state.task!;

            return Column(
              children: [
                _TaskTitle(task: task),
                const SizedBox(height: 8),
                _TaskDescription(task: task),
                const SizedBox(height: 16),
                _TaskReminder(task: task),
                const SizedBox(height: 20),
                if (task.steps != null && task.steps!.isNotEmpty)
                  _TaskSteps(
                    task: task,
                  ),
                const SizedBox(height: 20),
                DefaultOutlinedButton(
                  onPressed: () => showAddStepDialog(task.steps?.length),
                  text: context.localisations.add_step,
                  icon: Icons.add,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TaskTitle extends StatefulWidget {
  final Task? task;
  const _TaskTitle({this.task});

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
                  widget.task?.title ??
                      '(${context.localisations.set_title_here})',
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
  final Task? task;
  const _TaskDescription({this.task});

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
                  widget.task?.description ?? '-',
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
  final Task? task;
  const _TaskReminder({this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.localisations.reminder,
              style: context.themeData.textTheme.headlineMedium,
            ),
            Switch(
              value: task?.setReminder ?? false,
              onChanged: (isChanged) {},
            ),
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
  final Task task;

  const _TaskSteps({required this.task});

  @override
  State<_TaskSteps> createState() => _TaskStepsState();
}

class _TaskStepsState extends State<_TaskSteps> {
  int _currentStep = 0;

  void _handleOptions(String option, TaskStep step) {
    if (option == context.localisations.edit) {}

    if (option == context.localisations.remove) {
      context.read<TaskCubit>().removeStep(taskId: widget.task.id, step: step);
    }
  }

  int _setCurrentStep() =>
      (widget.task.steps != null && _currentStep < widget.task.steps!.length)
          ? _currentStep
          : (_currentStep = 0);

  @override
  Widget build(BuildContext context) {
    final steps = widget.task.steps!;

    return Stepper(
      key: Key(steps.length.toString()),
      connectorColor: MaterialStateProperty.all<Color>(
        kColorScheme.primary,
      ),
      currentStep: _setCurrentStep(),
      controlsBuilder: (context, controller) {
        return Container();
      },
      physics: const NeverScrollableScrollPhysics(),
      onStepTapped: (step) => setState(() => _currentStep = step),
      steps: steps.map((e) {
        return Step(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  e.title ?? '-',
                  style: context.themeData.textTheme.titleMedium,
                ),
              ),
              DefaultPopUpButton(
                items: [
                  context.localisations.edit,
                  context.localisations.remove,
                ],
                onItemClicked: (String selection) =>
                    _handleOptions(selection, e),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  e.description ?? '-',
                  style: context.themeData.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 8),
              if (e.image != null && e.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset('assets/images/${e.image}'),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
