import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FilterlistAppBar extends StatefulWidget {
  final List<(String, String, IconData?)> filterList;
  final Function(String) selected;

  const FilterlistAppBar({
    Key? key,
    required this.filterList,
    required this.selected,
  }) : super(key: key);

  @override
  State<FilterlistAppBar> createState() => _FilterlistAppBarState();
}

class _FilterlistAppBarState extends State<FilterlistAppBar> {
  String? _selectedTag;
  final _itemScrollController = ItemScrollController();
  final _scrollOffsetController = ScrollOffsetController();

  void _onItemClicked(int index, String tagSelected) {
    setState(() => _selectedTag = tagSelected);
    _itemScrollController.scrollTo(
      alignment: 0.1,
      index: index,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 200),
    );
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
      flexibleSpace: ScrollablePositionedList.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemScrollController: _itemScrollController,
        scrollOffsetController: _scrollOffsetController,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: widget.filterList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _SelectionChip(
              onSelect: (tagSelected) => _onItemClicked(index, tagSelected),
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

class _SelectionChip extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final String title;
  final IconData? icon;
  final Function(String) onSelect;

  const _SelectionChip({
    Key? key,
    this.icon,
    required this.title,
    required this.tag,
    required this.onSelect,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = isSelected
        ? context.themeData.scaffoldBackgroundColor
        : context.themeData.colorScheme.primary;

    final selectedFontWeight = isSelected ? FontWeight.bold : FontWeight.normal;

    return ChoiceChip.elevated(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.themeData.textTheme.bodySmall!
                .copyWith(color: selectedColor, fontWeight: selectedFontWeight),
          ),
          const SizedBox(width: 8),
          if (icon != null)
            Icon(
              icon,
              size: 14,
              color: selectedColor,
            ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelect(tag),
      shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
      backgroundColor: context.themeData.colorScheme.secondaryContainer,
      selectedColor: context.themeData.colorScheme.primary,
      showCheckmark: false,
    );
  }
}
