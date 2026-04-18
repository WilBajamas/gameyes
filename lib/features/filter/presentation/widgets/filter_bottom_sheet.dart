import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_genre.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_ordering.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubits/filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_border_text_field.dart';
import 'package:gaming_library_assessment_flutter/widgets/multi_type_values_selection.dart';
import 'package:gaming_library_assessment_flutter/widgets/type_values_selection.dart';

import '../../../../generated/l10n.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(FilterState) onSaveClick;
  final FilterState filterState;

  const FilterBottomSheet({
    super.key,
    required this.onSaveClick,
    required this.filterState,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    _searchTextController.text = widget.filterState.searchTerm ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterCubit(initialState: widget.filterState),
      child: SizedBox(
        height: context.screenHeight * 0.7,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<FilterCubit, FilterState>(
            builder: (filterContext, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //** Save button */
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        widget.onSaveClick(
                          state.copyWith(
                            searchTerm: _searchTextController.text,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        textStyle:
                            filterContext.themeData.textTheme.titleMedium,
                      ),
                      child: Text(S.current.save),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //** Search */
                  DefaultBorderTextField(
                    context: filterContext,
                    title: S.current.search_games,
                    textEditingController: _searchTextController,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 12),

                  //** Date range */
                  DateSelection(filterState: state),

                  const SizedBox(height: 18),
                  //** Ordering */
                  TypeValuesSelection(
                    title: S.current.ordering,
                    typeList: GameOrdering.values,
                    typeSelection: state.ordering,
                    onTypeSelected: (orderingSelected) => filterContext
                        .read<FilterCubit>()
                        .changeSelectionValue(ordering: orderingSelected),
                  ),

                  const SizedBox(height: 12),

                  //** Game platform selection */
                  MultiTypeValuesSelection<GamePlatform>(
                    selectedItems: state.platforms,
                    title: S.current.platforms,
                    onSelect: (platform) => filterContext
                        .read<FilterCubit>()
                        .selectPlatform(platform),
                    selections: GamePlatform.values.toSet(),
                  ),

                  const SizedBox(height: 12),

                  // ** Genres */
                  MultiTypeValuesSelection<GameGenre>(
                    selectedItems: state.genres,
                    title: S.current.genre,
                    onSelect: (genre) =>
                        filterContext.read<FilterCubit>().selectGenre(genre),
                    selections: GameGenre.values.toSet(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DateSelection extends StatefulWidget {
  final FilterState filterState;

  const DateSelection({super.key, required this.filterState});

  @override
  State<DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();

  @override
  void dispose() {
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

  void changeStartDate(
    BuildContext context,
    DateTime? initialDate,
    DateTime? dateTo,
  ) async {
    final DateTime? picked = await _selectDate(
      context,
      initialDate,
      lastDate: dateTo,
    );
    if (!context.mounted) return;
    context.read<FilterCubit>().changeSelectionValue(dateFrom: picked);
  }

  void changeEndDate(
    BuildContext context,
    DateTime? initialDate,
    DateTime? dateFrom,
  ) async {
    final DateTime? picked = await _selectDate(
      context,
      initialDate,
      firstDate: dateFrom,
    );
    if (!context.mounted) return;
    context.read<FilterCubit>().changeSelectionValue(dateTo: picked);
  }

  @override
  Widget build(BuildContext context) {
    _dateFromController.text =
        widget.filterState.dateFrom.getFormattedStringFromDateTime() ?? '';
    _dateToController.text =
        widget.filterState.dateTo.getFormattedStringFromDateTime() ?? '';

    return Column(
      children: [
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
                onClicked: () => changeStartDate(
                  context,
                  widget.filterState.dateFrom,
                  widget.filterState.dateTo,
                ),
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
                onClicked: () => changeEndDate(
                  context,
                  widget.filterState.dateTo,
                  widget.filterState.dateFrom,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
