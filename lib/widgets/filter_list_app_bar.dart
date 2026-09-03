import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

//! Must specify type for [T]
class FilterlistAppBar<T> extends StatefulWidget {
  final List<(T, String, IconData?)> filterList;
  final Function(T) selected;

  const FilterlistAppBar({
    super.key,
    required this.filterList,
    required this.selected,
  });

  @override
  State<FilterlistAppBar<T>> createState() => _FilterlistAppBarState<T>();
}

class _FilterlistAppBarState<T> extends State<FilterlistAppBar<T>> {
  T? _selectedTag;
  final ScrollController _scrollController = ScrollController();

  void _onItemClicked(int index, T tagSelected, BuildContext chipContext) {
    setState(() => _selectedTag = tagSelected);
    widget.selected(tagSelected);
    Scrollable.ensureVisible(
      chipContext,
      alignment: 0.5,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isItemSelected(int index) => switch ((index, _selectedTag)) {
      (0, null) => true,
      (_, _) => widget.filterList[index].$1 == _selectedTag,
    };

    return SliverAppBar(
      backgroundColor: context.themeData.scaffoldBackgroundColor,
      pinned: true,
      surfaceTintColor: context.themeData.scaffoldBackgroundColor,
      expandedHeight: kToolbarHeight,
      flexibleSpace: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: widget.filterList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _SelectionChip<T>(
              onSelect: (tagSelected, chipContext) =>
                  _onItemClicked(index, tagSelected, chipContext),
              isSelected: isItemSelected(index),
              title: widget.filterList[index].$2,
              tag: widget.filterList[index].$1,
              icon: widget.filterList[index].$3,
            ),
          );
        },
      ),
    );
  }
}

class _SelectionChip<T> extends StatelessWidget {
  final T tag;
  final bool isSelected;
  final String title;
  final IconData? icon;
  final Function(T, BuildContext) onSelect;

  const _SelectionChip({
    this.icon,
    required this.title,
    required this.tag,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = isSelected
        ? context.themeData.scaffoldBackgroundColor
        : context.themeData.colorScheme.primary;

    final selectedFontWeight = isSelected ? FontWeight.bold : FontWeight.normal;

    return ChoiceChip.elevated(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.themeData.textTheme.bodySmall!.copyWith(
              color: selectedColor,
              fontWeight: selectedFontWeight,
            ),
          ),
          if (icon != null) const SizedBox(width: 8),
          if (icon != null) Icon(icon, size: 14, color: selectedColor),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelect(tag, context),
      shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
      backgroundColor: context.themeData.colorScheme.secondaryContainer,
      selectedColor: context.themeData.colorScheme.primary,
      showCheckmark: false,
    );
  }
}
