import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/featured_filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/multi_type_values_selection.dart';

class FeaturedFilterBottomSheet extends StatelessWidget {
  final VoidCallback onSaveClick;

  const FeaturedFilterBottomSheet({
    super.key,
    required this.onSaveClick,
  });

  void saveButtonClick(BuildContext context) {
    onSaveClick();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.7,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //** Save button */
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => saveButtonClick(context),
                style: TextButton.styleFrom(
                  textStyle: context.themeData.textTheme.titleMedium,
                ),
                child: Text(context.localisations.save),
              ),
            ),
            const SizedBox(height: 20),

            //** Game platform selection */
            BlocBuilder<FeaturedFilterCubit, FeaturedFilterState>(
              builder: (context, state) {
                return MultiTypeValuesSelection<GamePlatform>(
                  selectedItems: state.platformsSelected,
                  title: context.localisations.platforms,
                  onSelect: (platform) => context
                      .read<FeaturedFilterCubit>()
                      .selectPlatform(platform),
                  selections: GamePlatform.values.toSet(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
