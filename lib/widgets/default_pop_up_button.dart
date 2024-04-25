import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class DefaultPopUpButton<T> extends StatelessWidget {
  final List<T> items;
  final Function(T) onItemClicked;

  const DefaultPopUpButton({
    required this.items,
    required this.onItemClicked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onItemClicked,
      icon: Icon(
        Icons.more_vert,
        color: context.themeData.colorScheme.primary,
      ),
      itemBuilder: (BuildContext context) =>
          // <PopupMenuEntry<T>>(),
          items
              .map(
                (e) => PopupMenuItem<T>(
                  child: Text(
                    e.toString(),
                  ),
                ),
              )
              .toList(),
      // <PopupMenuEntry<T>>[
      //   const PopupMenuItem<T>(
      //     value: T,
      //     child: Text('Item 1'),
      //   ),
      //   const PopupMenuItem<T>(
      //     value: SampleItem.itemTwo,
      //     child: Text('Item 2'),
      //   ),
      //   const PopupMenuItem<SampleItem>(
      //     value: SampleItem.itemThree,
      //     child: Text('Item 3'),
      //   ),
      // ],
    );
  }
}
