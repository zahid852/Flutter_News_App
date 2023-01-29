import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/consts/styles.dart';
import 'package:news_app/consts/var.dart';
import 'package:news_app/inner_screens/bookmarks_screen.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/providers/firebase_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class blogDetails extends StatefulWidget {
  static const routeName = '/blogDetails';
  @override
  State<blogDetails> createState() => _blogDetailsState();
}

class _blogDetailsState extends State<blogDetails> {
  bool isInBookmark = false;
  String? publishedAt;
  dynamic currentBookmark;
  @override
  void didChangeDependencies() {
    print('hello');
    print('publish ${publishedAt}');
    publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    final List<BookmarksModel> bookmarksList =
        Provider.of<firebaseProvider>(context).getBookmarkList;
    print('book mark list ${bookmarksList}');
    if (bookmarksList.isEmpty) {
      return;
    }

    currentBookmark = bookmarksList.where((element) {
      print('element ${element.publishedAt}');
      return element.publishedAt == publishedAt;
    }).toList();
    print('current mark list ${currentBookmark}');
    if (currentBookmark.isEmpty) {
      isInBookmark = false;
    } else {
      isInBookmark = true;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).getThemeTextColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    final firebase_Provider = Provider.of<firebaseProvider>(
      context,
    );

    final currentNews = newsProvider.findById(publishedAt: publishedAt);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'By ${currentNews.authorName}',
          style: TextStyle(color: color),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: color,
            )),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                Text(
                  currentNews.title,
                  textAlign: TextAlign.justify,
                  style: titleTextStyle,
                ),
                verticalSpacing(20),
                Row(
                  children: [
                    Text(currentNews.dateToShow, style: SmallTextStyle),
                    Spacer(),
                    Text(
                      currentNews.readingTimeText,
                      style: SmallTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
          verticalSpacing(
            20,
          ),
          Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Hero(
                    tag: currentNews.publishedAt,
                    child: FancyShimmerImage(
                        width: double.infinity,
                        errorWidget:
                            Image.asset('assets/images/empty_image.png'),
                        imageUrl: currentNews.urlToImage),
                  )),
              Positioned(
                bottom: 0,
                right: 30,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          await Share.share(currentNews.url,
                              subject: 'Look what I made!');
                        } catch (error) {
                          GlobalMethods.errorDialog(
                              error: error.toString(), context: context);
                        }
                      },
                      child: Card(
                        elevation: 10,
                        shape: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            IconlyLight.send,
                            color: color,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isInBookmark) {
                          await firebase_Provider.deleteBookmark(
                              key: currentBookmark[0].bookmark_key);
                        } else {
                          await firebase_Provider.addToBookmark(
                              newsModel: currentNews);
                        }
                        await firebase_Provider.fetchBookmarks();
                      },
                      child: Card(
                        elevation: 10,
                        shape: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isInBookmark
                                ? IconlyBold.bookmark
                                : IconlyLight.bookmark,
                            color: isInBookmark ? Colors.green : color,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          verticalSpacing(
            20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextContent(
                  label: 'Description',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                verticalSpacing(10),
                TextContent(
                  label: currentNews.description,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                verticalSpacing(
                  20,
                ),
                TextContent(
                  label: 'Contents',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                verticalSpacing(
                  10,
                ),
                TextContent(
                  label: currentNews.content,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TextContent extends StatelessWidget {
  TextContent({
    Key? key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.justify,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
