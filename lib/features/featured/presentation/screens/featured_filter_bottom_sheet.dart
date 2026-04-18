import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubits/featured_filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/multi_type_values_selection.dart';

import '../../../../generated/l10n.dart';

class FeaturedFilterBottomSheet extends StatelessWidget {
  final Function(Set<GamePlatform>) onSaveClick;
  final Set<GamePlatform> initialPlatforms;

  const FeaturedFilterBottomSheet({
    super.key,
    required this.onSaveClick,
    required this.initialPlatforms,
  });

  void saveButtonClick(
    BuildContext context, {
    required Set<GamePlatform> platformsSelected,
  }) {
    context.read<FeaturedFilterCubit>().setPlatforms();
    onSaveClick(platformsSelected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.7,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (context) =>
              FeaturedFilterCubit(initialPlatforms: initialPlatforms),
          child: BlocBuilder<FeaturedFilterCubit, FeaturedFilterState>(
            builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //** Save button */
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => saveButtonClick(
                      context,
                      platformsSelected: state.tempPlatformsSelected,
                    ),
                    style: TextButton.styleFrom(
                      textStyle: context.themeData.textTheme.titleMedium,
                    ),
                    child: Text(S.current.save),
                  ),
                ),
                const SizedBox(height: 20),

                //** Game platform selection */
                MultiTypeValuesSelection<GamePlatform>(
                  selectedItems: state.tempPlatformsSelected,
                  title: S.current.platforms,
                  onSelect: (platform) => context
                      .read<FeaturedFilterCubit>()
                      .selectPlatform(platform),
                  selections: GamePlatform.values.toSet(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
