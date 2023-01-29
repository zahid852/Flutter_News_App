import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/consts/var.dart';
import 'package:news_app/inner_screens/blog_details.dart';
import 'package:news_app/inner_screens/news_details_webview.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class articlesWidget extends StatelessWidget {
  final bool isBookMark;
  articlesWidget({this.isBookMark = false});
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context: context).getScreenSize;
    dynamic NewsModelProvider = isBookMark
        ? Provider.of<BookmarksModel>(context)
        : Provider.of<NewsModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(blogDetails.routeName,
                  arguments: NewsModelProvider.publishedAt);
            },
            child: Stack(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 60,
                    width: 60,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Container(
                    color: Theme.of(context).cardColor,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Hero(
                              tag: NewsModelProvider.publishedAt,
                              child: FancyShimmerImage(
                                  height: size.height * 0.14,
                                  width: size.width * 0.26,
                                  boxFit: BoxFit.fill,
                                  errorWidget: Image.asset(
                                      'assets/images/empty_image.png'),
                                  imageUrl: NewsModelProvider.urlToImage),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              NewsModelProvider.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              style: smallTextStyle,
                            ),
                            verticalSpacing(5),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '🕒  ${NewsModelProvider.readingTimeText}',
                                style: smallTextStyle,
                              ),
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(PageTransition(
                                          child: newsDetailsWebView(
                                            url: NewsModelProvider.url,
                                          ),
                                          type:
                                              PageTransitionType.rightToLeft));
                                    },
                                    icon: Icon(Icons.link),
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    NewsModelProvider.dateToShow,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
