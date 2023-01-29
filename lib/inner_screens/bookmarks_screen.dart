import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/consts/var.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/providers/firebase_provider.dart';
import 'package:news_app/widgets/drawer.dart';
import 'package:news_app/widgets/empty_news_widget.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/articles_widget.dart';
import '../widgets/loading_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).getThemeTextColor;
    return Scaffold(
      drawer: drawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Bookmarks',
          style: GoogleFonts.lobster(
              textStyle:
                  TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<BookmarksModel>>(
              future: Provider.of<firebaseProvider>(context, listen: false)
                  .fetchBookmarks(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(
                    newsType: NewsType.allNews,
                  );
                } else if (snapshot.hasError) {
                  return emptyNewsWidget('An error occured, ${snapshot.error}',
                      'assets/images/no_news.png');
                } else if (snapshot.data == null) {
                  return const emptyNewsWidget(
                    'You didn\'t add anything yet to your bookmarks',
                    "assets/images/bookmark.png",
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: snapshot.data![index],
                            child: articlesWidget(
                              isBookMark: true,
                            ));
                      }),
                );
              })),
        ],
      ),
    );
  }
}
