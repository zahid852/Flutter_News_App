import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/inner_screens/blog_details.dart';
import 'package:news_app/inner_screens/news_details_webview.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../models/news_model.dart';

class topTrending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NewsModelProvider = Provider.of<NewsModel>(context);
    Size size = Utils(context: context).getScreenSize;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(blogDetails.routeName,
                arguments: NewsModelProvider.publishedAt);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  boxFit: BoxFit.fill,
                  width: double.infinity,
                  height: size.height * 0.32,
                  imageUrl: NewsModelProvider.urlToImage,
                  errorWidget: Image.asset('assets/images/empty_image.png'),
                ),
              ),
              verticalSpacing(10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  NewsModelProvider.title,
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(PageTransition(
                                  child: newsDetailsWebView(
                                    url: NewsModelProvider.url,
                                  ),
                                  type: PageTransitionType.rightToLeft));
                            },
                            icon: Icon(Icons.link)),
                        Spacer(),
                        SelectableText(
                          NewsModelProvider.dateToShow,
                          style: GoogleFonts.montserrat(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
