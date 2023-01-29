import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/providers/theme_provider.dart';
import 'package:news_app/services/dark_theme_preferences.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;
  Utils({required this.context});
  Size get getScreenSize => MediaQuery.of(context).size;
  bool get getTheme => Provider.of<ThemeProvider>(context).getDarkTheme;
  Color get getThemeTextColor => getTheme ? Colors.white : Colors.black;

  Color get baseShimmerColor =>
      getTheme ? Colors.grey.shade500 : Colors.grey.shade200;

  Color get highlightShimmerColor =>
      getTheme ? Colors.grey.shade700 : Colors.grey.shade400;

  Color get WidgetShimmerColor =>
      getTheme ? Colors.grey.shade600 : Colors.grey.shade100;
}
