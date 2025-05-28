import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_border_text_field.dart';
import 'package:gaming_library_assessment_flutter/widgets/multi_type_values_selection.dart';
import 'package:gaming_library_assessment_flutter/widgets/type_values_selection.dart';

import '../../../../generated/l10n.dart';

class FilterBottomSheet extends StatefulWidget {
  final VoidCallback onSaveClick;

  const FilterBottomSheet({
    super.key,
    required this.onSaveClick,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final FilterCubit _filterCubit;

  final _searchTextController = TextEditingController();
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();

  @override
  void initState() {
    _filterCubit = context.read<FilterCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }

  Future<DateTime?> _selectDate(
    BuildContext context,
    DateTime? selectedDate, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate ?? DateTime(1990),
      lastDate: lastDate ?? DateTime.now().getDateTimeLater(yearsLater: 30),
    );
    return picked;
  }

  void saveButtonClick(FilterState state) {
    _filterCubit.changeSelectionValue(
      searchTerm: _searchTextController.text,
    );

    widget.onSaveClick();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.7,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) {
            _searchTextController.text = state.searchTerm ?? '';
            _dateFromController.text =
                state.dateFrom.getFormattedStringFromDateTime() ?? '';
            _dateToController.text =
                state.dateTo.getFormattedStringFromDateTime() ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //** Save button */
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => saveButtonClick(state),
                    style: TextButton.styleFrom(
                      textStyle: context.themeData.textTheme.titleMedium,
                    ),
                    child: Text(S.current.save),
                  ),
                ),
                const SizedBox(height: 20),

                //** Search */
                DefaultBorderTextField(
                  context: context,
                  title: S.current.search_games,
                  textEditingController: _searchTextController,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) =>
                      context.read<FilterCubit>().updateSearchTerm(value),
                ),
                const SizedBox(height: 12),

                //** Date range */
                Text(
                  S.current.date_range,
                  style: context.themeData.textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DefaultBorderTextField(
                        context: context,
                        textEditingController: _dateFromController,
                        inputType: TextInputType.number,
                        title: S.current.from,
                        readOnly: true,
                        onClicked: () async {
                          final selectedDate = await _selectDate(
                            context,
                            state.dateFrom,
                            lastDate: state.dateTo,
                          );

                          _filterCubit.changeSelectionValue(
                            dateFrom: selectedDate,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DefaultBorderTextField(
                        context: context,
                        textEditingController: _dateToController,
                        inputType: TextInputType.number,
                        title: S.current.to,
                        readOnly: true,
                        onClicked: () async {
                          final selectedDate = await _selectDate(
                            context,
                            state.dateTo,
                            firstDate: state.dateFrom,
                          );

                          _filterCubit.changeSelectionValue(
                            dateTo: selectedDate,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                //** Ordering */
                TypeValuesSelection(
                  title: S.current.ordering,
                  typeList: GameOrdering.values,
                  typeSelection: state.ordering,
                  onTypeSelected: (orderingSelected) => _filterCubit
                      .changeSelectionValue(ordering: orderingSelected),
                ),

                const SizedBox(height: 12),

                //** Game platform selection */
                MultiTypeValuesSelection<GamePlatform>(
                  selectedItems: state.platforms,
                  title: S.current.platforms,
                  onSelect: (platform) =>
                      context.read<FilterCubit>().selectPlatform(platform),
                  selections: GamePlatform.values.toSet(),
                ),

                const SizedBox(height: 12),

                // ** Genres */
                MultiTypeValuesSelection<GameGenre>(
                  selectedItems: state.genres,
                  title: S.current.genre,
                  onSelect: (genre) =>
                      context.read<FilterCubit>().selectGenre(genre),
                  selections: GameGenre.values.toSet(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
