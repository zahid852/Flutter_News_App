import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/widgets/articles_widget.dart';
import 'package:news_app/widgets/empty_news_widget.dart';

import '../services/utils.dart';

class bookMarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).getThemeTextColor;
    Size size = Utils(context: context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Bookmarks',
            style: GoogleFonts.lobster(
                textStyle:
                    TextStyle(color: color, fontSize: 18, letterSpacing: 0.8)),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios))),
      body: emptyNewsWidget('You didn\'t add anything yet to your bookmarks',
          'assets/images/bookmark.png'),
      //  ListView.builder(
      //     itemCount: 20,
      //     itemBuilder: (context, index) {
      //       return articlesWidget();
      //     }),
    );
  }
}
