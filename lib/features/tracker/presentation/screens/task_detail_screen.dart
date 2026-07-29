import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/tracker_task_step_entity.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/task_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/presentation/cubits/task_state.dart';
import 'package:gaming_library_assessment_flutter/widgets/add_content_dialog.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_alert_dialog.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_border_text_field.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_outlined_button.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_pop_up_button.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_snackbar.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../generated/l10n.dart';
import 'package:auto_route/annotations.dart';

@RoutePage()
class TaskDetailScreen extends StatelessWidget {
  final int? taskId;
  final TrackerTaskEntity? task;

  const TaskDetailScreen({this.taskId, this.task, super.key});

  void _showAddStepDialog(int? stepNumber, BuildContext context) {
    if (taskId case final id?) {
      showDialog(
        context: context,
        builder: (dialogContext) => AddContentDialog(
          dialogTitleAndSnackBarTitle: (
            S.current.add_step,
            S.current.step_added
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
      body: SafeArea(
        top: false,
        child: BlocProvider(
          create: (context) => getIt<TaskCubit>(),
          child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: BlocConsumer<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is RemoveStepFailed || state is RemoveStepSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  DefaultSnackbar(
                    text: state is RemoveStepSuccess
                        ? S.current.removed_step
                        : S.current.remove_step_failed,
                  ),
                );
              }
            },
            buildWhen: (previous, current) => previous.task != current.task,
            builder: (context, state) {
              final task = state.task!;

              return Column(
                children: [
                  _TaskTitle(task: task),
                  const SizedBox(height: 8),
                  _TaskDescription(task: task),
                  // const SizedBox(height: 16),
                  // _TaskReminder(task: task),
                  const SizedBox(height: 20),
                  if (task.steps.isNotEmpty)
                    _TaskSteps(
                      task: task,
                    ),
                  const SizedBox(height: 20),
                  DefaultOutlinedButton(
                    onPressed: () =>
                        _showAddStepDialog(task.steps.length, context),
                    text: S.current.add_step,
                    icon: Icons.add,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
    );
  }
}

//* Task Title
class _TaskTitle extends StatefulWidget {
  final TrackerTaskEntity? task;

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
                  widget.task?.title ?? '(${S.current.set_title_here})',
                  style: context.themeData.textTheme.displayLarge,
                )
              : DefaultBorderTextField(
                  context: context,
                  title: S.current.title,
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
          color: kColorScheme.onSurface,
        ),
      ],
    );
  }
}

//* Task Description
class _TaskDescription extends StatefulWidget {
  final TrackerTaskEntity? task;

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
                  title: S.current.description,
                  maxLength: 100,
                  maxLines: 5,
                ),
        ),
        IconButton(
          onPressed: () => setState(() => _isEditing = !_isEditing),
          color: kColorScheme.onSurface,
          icon: Icon(
            _isEditing ? Icons.done : Icons.edit,
            color: kColorScheme.primary,
          ),
        ),
      ],
    );
  }
}

//* Reminder
class _TaskReminder extends StatelessWidget {
  final TrackerTaskEntity? task;

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
              S.current.reminder,
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

//* Steps
class _TaskSteps extends StatelessWidget {
  final TrackerTaskEntity task;

  const _TaskSteps({required this.task});

  @override
  Widget build(BuildContext context) {
    final steps = task.steps;

    return Stepper(
      key: Key(steps.length.toString()),
      connectorColor: WidgetStateProperty.all<Color>(
        kColorScheme.primary,
      ),
      currentStep: task.currentStepIndex,
      controlsBuilder: (context, controller) {
        return Container();
      },
      physics: const NeverScrollableScrollPhysics(),
      onStepTapped: (stepIndex) =>
          context.read<TaskCubit>().setCurrentStep(stepIndex: stepIndex),
      steps: steps.map((step) {
        return Step(
          title: _StepTitle(taskId: task.id, step: step),
          content: _StepContent(step),
        );
      }).toList(),
    );
  }
}

class _StepTitle extends StatelessWidget {
  final TrackerTaskStepEntity step;
  final int taskId;

  const _StepTitle({required this.step, required this.taskId});

  void _handleOptions(
    String option,
    TrackerTaskStepEntity step,
    BuildContext context,
  ) {
    if (option == S.current.edit) {
      _showEditStepDialog(step, context);
    } else if (option == S.current.remove) {
      _showRemoveStepDialog(
        step,
        () => context.read<TaskCubit>().removeStep(step: step),
        context,
      );
    }
  }

  void _showRemoveStepDialog(
    TrackerTaskStepEntity step,
    VoidCallback positiveCallback,
    BuildContext context,
  ) =>
      showDialog(
        context: context,
        builder: (context) => DefaultAlertDialog(
          title: '${S.current.remove_step}?',
          description: S.current.remove_step_desc(step.title!),
          onPositivePressed: positiveCallback,
        ),
      );

  void _showEditStepDialog(TrackerTaskStepEntity step, BuildContext context) =>
      showDialog(
        context: context,
        builder: (context) => AddContentDialog(
          dialogTitleAndSnackBarTitle: (
            S.current.add_step,
            S.current.step_added
          ),
          titleDescription: (step.title, step.description),
          onCreatedClicked: (title, description) =>
              context.read<TaskCubit>().editStep(
                    taskId: taskId,
                    stepId: step.id,
                    title: title,
                    description: description,
                    stepNumber: step.number!,
                  ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            step.title ?? '-',
            style: context.themeData.textTheme.titleMedium,
          ),
        ),
        DefaultPopUpButton(
          items: [
            S.current.edit,
            S.current.remove,
          ],
          onItemClicked: (String selection) =>
              _handleOptions(selection, step, context),
        ),
      ],
    );
  }
}

class _StepContent extends StatelessWidget {
  final TrackerTaskStepEntity step;

  const _StepContent(this.step);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            step.description ?? '-',
            style: context.themeData.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 8),
        if (step.image != null && step.image!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/${step.image}'),
          ),
      ],
    );
  }
}
