import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/inner_screens/bookmarks_screen.dart';
import 'package:news_app/screens/homeScreen.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class drawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Image.asset('assets/images/newspaper.png')),
                    verticalSpacing(20),
                    Flexible(
                        child: Text(
                      'News App',
                      style: GoogleFonts.lobster(
                          textStyle:
                              TextStyle(fontSize: 18, letterSpacing: 0.8)),
                    ))
                  ],
                )),
            verticalSpacing(20),
            listTileWidget(
                label: 'Home',
                icon: IconlyBold.home,
                function: () {
                  Navigator.of(context).pushReplacement(PageTransition(
                      child: const HomeScreen(),
                      type: PageTransitionType.rightToLeft));
                }),
            const Divider(),
            listTileWidget(
                label: 'Bookmark',
                icon: IconlyBold.bookmark,
                function: () {
                  Navigator.of(context).pushReplacement(PageTransition(
                      child: const BookmarkScreen(),
                      type: PageTransitionType.rightToLeft));
                }),
            const Divider(),
            SwitchListTile(
                title: Text(
                  themeProvider.getDarkTheme ? 'Dark' : 'Light',
                  style: TextStyle(fontSize: 18),
                ),
                secondary: Icon(
                  themeProvider.getDarkTheme
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                value: themeProvider.getDarkTheme,
                onChanged: (bool value) {
                  themeProvider.setDarkTheme = value;
                }),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class listTileWidget extends StatelessWidget {
  const listTileWidget({
    Key? key,
    required this.label,
    required this.icon,
    required this.function,
  }) : super(key: key);
  final String label;
  final IconData icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
