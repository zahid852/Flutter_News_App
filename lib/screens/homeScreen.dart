import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/consts/var.dart';
import 'package:news_app/inner_screens/search_screen.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/services/news_api.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/articles_widget.dart';
import 'package:news_app/widgets/drawer.dart';
import 'package:news_app/widgets/empty_news_widget.dart';
import 'package:news_app/widgets/loading_widget.dart';
import 'package:news_app/widgets/tabs.dart';
import 'package:news_app/widgets/top_trending_widget.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<List<NewsModel>> getNews() async {
  //   List<NewsModel> newsList = await NewsApiServices.getAllNews();
  //   return newsList;
  // }

  var News = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.relevancy.name;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).getThemeTextColor;
    Size size = Utils(context: context).getScreenSize;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: color),
            elevation: 0,
            centerTitle: true,
            title: Text(
              'News App',
              style: GoogleFonts.lobster(
                  textStyle: TextStyle(
                      color: color, fontSize: 18, letterSpacing: 0.8)),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(PageTransition(
                        child: searchScreen(),
                        type: PageTransitionType.rightToLeft));
                  },
                  icon: Icon(IconlyLight.search))
            ],
          ),
          drawer: drawerWidget(),
          body: Container(
            height: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(9),
                  child: Row(
                    children: [
                      tabs(
                          text: 'All News',
                          color: News == NewsType.allNews
                              ? Theme.of(context).cardColor
                              : Colors.transparent,
                          function: () {
                            if (News == NewsType.allNews) {
                              return;
                            }
                            setState(() {
                              News = NewsType.allNews;
                            });
                          },
                          fontSize: News == NewsType.allNews ? 17 : 14),
                      tabs(
                          text: 'Trending News',
                          color: News == NewsType.topTrending
                              ? Theme.of(context).cardColor
                              : Colors.transparent,
                          function: () {
                            if (News == NewsType.topTrending) {
                              return;
                            }
                            setState(() {
                              News = NewsType.topTrending;
                            });
                          },
                          fontSize: News == NewsType.topTrending ? 16 : 14)
                    ],
                  ),
                ),
                News == NewsType.topTrending
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: kBottomNavigationBarHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              paginationButtons(
                                  text: 'Prev',
                                  function: () {
                                    if (currentPageIndex == 0) {
                                      return;
                                    }
                                    setState(() {
                                      currentPageIndex -= 1;
                                    });
                                  }),
                              Flexible(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                currentPageIndex = index;
                                              });
                                            },
                                            child: Container(
                                              color: currentPageIndex == index
                                                  ? Colors.blue
                                                  : Theme.of(context).cardColor,
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: Text(
                                                  "${index + 1}",
                                                  style: TextStyle(
                                                      color: currentPageIndex ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              paginationButtons(
                                  text: 'Next',
                                  function: () {
                                    if (currentPageIndex == 4) {
                                      return;
                                    }
                                    setState(() {
                                      currentPageIndex += 1;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                verticalSpacing(10),
                News == NewsType.topTrending
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Material(
                            borderRadius: BorderRadius.circular(2),
                            color: Theme.of(context).cardColor,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton(
                                  value: sortBy,
                                  items: dropDownButtonItemsList,
                                  onChanged: (value) {
                                    setState(() {
                                      sortBy = value ?? 'relevancy';
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                verticalSpacing(10),
                FutureBuilder<List<NewsModel>>(
                    future: News == NewsType.topTrending
                        ? newsProvider.fetchTopHeadlines()
                        : newsProvider.fetchAllNews(
                            page: currentPageIndex + 1, sortBy: sortBy),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget(newsType: News);
                      } else if (snapshot.hasError) {
                        return Expanded(
                          child: emptyNewsWidget(
                              'An error occured, ${snapshot.error}',
                              'assets/images/no_news.png'),
                        );
                      } else if (snapshot.data == null) {
                        return emptyNewsWidget(
                            'No news found', 'assets/images/no_news.png');
                      } else {
                        return News == NewsType.allNews
                            ? Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return ChangeNotifierProvider.value(
                                          value: snapshot.data![index],
                                          child: articlesWidget());
                                    }))
                            : Swiper(
                                viewportFraction: 0.9,
                                itemCount: 5,
                                itemWidth: size.width * 0.9,
                                itemHeight: size.height * 0.6,
                                autoplay: false,
                                // autoplayDelay: 9000,
                                layout: SwiperLayout.STACK,
                                itemBuilder: ((context, index) {
                                  return ChangeNotifierProvider.value(
                                      value: snapshot.data![index],
                                      child: topTrending());
                                }));
                      }
                    })
              ],
            ),
          )),
    );
  }

  List<DropdownMenuItem<String>> get dropDownButtonItemsList {
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
          value: SortByEnum.relevancy.name,
          child: Text(SortByEnum.relevancy.name)),
      DropdownMenuItem(
          value: SortByEnum.popularity.name,
          child: Text(SortByEnum.popularity.name)),
      DropdownMenuItem(
          value: SortByEnum.publishedAt.name,
          child: Text(SortByEnum.publishedAt.name)),
    ];
    return items;
  }

  Widget paginationButtons({required String text, required Function function}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(),
        onPressed: () {
          function();
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }
}
