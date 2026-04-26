import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class DefaultFilterListAppBar<T> extends StatefulWidget {
  final List<(T, String, IconData?)> filterList;
  final Function(T) selected;

  const DefaultFilterListAppBar({
    required this.filterList,
    required this.selected,
    super.key,
  });

  @override
  State<DefaultFilterListAppBar<T>> createState() =>
      _DefaultFilterListAppBarState<T>();
}

class _DefaultFilterListAppBarState<T>
    extends State<DefaultFilterListAppBar<T>> {
  late T? _selectedTag;

  @override
  void initState() {
    _selectedTag = widget.filterList[0].$1;

    super.initState();
  }

  void _onItemClicked(int index) {
    setState(() => _selectedTag = widget.filterList[index].$1);
    widget.selected(widget.filterList[index].$1);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.themeData.scaffoldBackgroundColor,
      pinned: true,
      surfaceTintColor: context.themeData.scaffoldBackgroundColor,
      expandedHeight: kToolbarHeight,
      flexibleSpace: DefaultTabController(
        length: widget.filterList.length,
        child: TabBar(
          onTap: (index) => _onItemClicked(index),
          tabAlignment: TabAlignment.center,
          padding: const EdgeInsets.only(left: 12),
          labelPadding: const EdgeInsets.only(right: 8),
          indicatorColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          isScrollable: true,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            return states.contains(WidgetState.focused)
                ? null
                : Colors.transparent;
          }),
          tabs: widget.filterList
              .map(
                (filter) => _SelectionChip(
                  filter: filter,
                  isSelected: filter.$1 == _selectedTag,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SelectionChip<T> extends StatelessWidget {
  final (T, String, IconData?) filter;
  final bool isSelected;

  const _SelectionChip({
    required this.filter,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = isSelected
        ? context.themeData.scaffoldBackgroundColor
        : context.themeData.colorScheme.primary;

    final backgroundcolor = isSelected
        ? context.themeData.colorScheme.primary
        : context.themeData.colorScheme.secondaryContainer;

    final selectedFontWeight = isSelected ? FontWeight.bold : FontWeight.normal;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          children: [
            Text(
              filter.$2,
              style: context.themeData.textTheme.bodySmall!.copyWith(
                color: selectedColor,
                fontWeight: selectedFontWeight,
              ),
            ),
            if (filter.$3 != null) const SizedBox(width: 8),
            if (filter.$3 != null)
              Icon(
                filter.$3,
                size: 14,
                color: selectedColor,
              ),
          ],
        ),
      ),
    );
  }
}
