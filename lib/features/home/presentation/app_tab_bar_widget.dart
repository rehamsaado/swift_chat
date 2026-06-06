import 'package:flutter/material.dart';

class AppTabBarWidget extends StatelessWidget {
  final List<AppTabBarItem> items;
  final int selectedIndex;
  final void Function(int index) onTap;
  final bool isBottomIndicator;

  const AppTabBarWidget({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.isBottomIndicator = false,
  }) : assert(
  items.length >= 2 && items.length <= 5,
  'items.length must be between 2 and 5',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 60,
      child: Row(
        children: [
          ...items
              .asMap()
              .map((int index, AppTabBarItem item) {
            return MapEntry(
              index,
              Expanded(
                child: InkWell(
                  onTap: () {
                    onTap(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: index != selectedIndex
                          ? null
                          : BorderDirectional(
                        top: !isBottomIndicator
                            ? BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.0,
                        )
                            : BorderSide.none,
                        bottom: isBottomIndicator
                            ? BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.0,
                        )
                            : BorderSide.none,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.iconData != null)
                          Icon(
                            item.iconData,
                            color: index == selectedIndex
                                ? theme.colorScheme.primary
                                : theme.hintColor,
                            size: 24.0,
                          ),
                        if (item.text != null)
                          Text(
                            item.text ?? "emptyString",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: index == selectedIndex
                                  ? theme.colorScheme.primary
                                  : theme.hintColor,
                              fontWeight: index == selectedIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
              .values
              ,
        ],
      ),
    );
  }
}

class AppTabBarItem {
  final IconData? iconData;
  final String? text;

  const AppTabBarItem({this.iconData, this.text})
      : assert(iconData != null || text != null);
}