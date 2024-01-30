import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/filter/data/models/games_platform.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_border_text_field.dart';
import 'package:gaming_library_assessment_flutter/widgets/type_values_selection.dart';

class FilterBottomSheet extends StatefulWidget {
  final VoidCallback onSaveClick;

  const FilterBottomSheet({
    Key? key,
    required this.onSaveClick,
  }) : super(key: key);

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
      height: context.screenHeight * 0.8,
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                    child: Text(context.localisations.save),
                  ),
                ),
                const SizedBox(height: 20),

                //** Search */
                DefaultBorderTextField(
                  context: context,
                  title: context.localisations.search_games,
                  textEditingController: _searchTextController,
                  prefixIcon: const Icon(Icons.search),
                ),
                const SizedBox(height: 12),

                //** Date range */
                Text(
                  context.localisations.date_range,
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
                        title: context.localisations.from,
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
                        title: context.localisations.to,
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

                //** Game platform selection */
                TypeValuesSelection<GamesPlatform>(
                  title: context.localisations.platforms,
                  typeList: const <GamesPlatform>[
                    Playstation5(),
                    Playstation4(),
                    Pc(),
                    XboxOne(),
                    XboxSeriesSX(),
                    Wii(),
                    WiiU(),
                  ],
                  typeSelection: state.gamesPlatform,
                  onTypeSelected: (platformSelected) =>
                      _filterCubit.changeSelectionValue(
                    platform: platformSelected,
                  ),
                ),

                const SizedBox(height: 12),

                //** Ordering */
                TypeValuesSelection(
                  title: context.localisations.ordering,
                  typeList: GameOrdering.values,
                  typeSelection: state.ordering,
                  onTypeSelected: (orderingSelected) => _filterCubit
                      .changeSelectionValue(ordering: orderingSelected),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
