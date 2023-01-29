import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news_app/consts/var.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/widgets/empty_news_widget.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/articles_widget.dart';

class searchScreen extends StatefulWidget {
  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  late final textEditingController;
  late FocusNode focusNode;
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      textEditingController.dispose();
      focusNode.dispose();
    }
    // TODO: implement dispose
    super.dispose();
  }

  List<NewsModel>? newsList = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).getThemeTextColor;
    Size size = Utils(context: context).getScreenSize;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Flexible(
                    child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: TextStyle(color: color),
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onEditingComplete: () async {
                    newsList = await newsProvider.fetchSearchNews(
                        query: textEditingController.text);
                    isSearching = true;
                    focusNode.unfocus();
                    setState(() {});
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 7),
                      hintText: 'Search',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffix: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            textEditingController.clear();
                            focusNode.unfocus();
                            isSearching = false;
                            newsList = [];
                            setState(() {});
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      )),
                ))
              ],
            ),
            if (!isSearching && newsList!.isEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 14),
                  child: MasonryGridView.count(
                    itemCount: SearchKeywords.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          textEditingController.text = SearchKeywords[index];
                          focusNode.unfocus();
                          newsList = await newsProvider.fetchSearchNews(
                              query: textEditingController.text);
                          isSearching = true;

                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: color),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            child: Center(
                                child: FittedBox(
                                    child: Text(SearchKeywords[index]))),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (isSearching && newsList!.isEmpty)
              Expanded(
                child: emptyNewsWidget(
                    'Oop! No results found', 'assets/images/search.png'),
              ),
            if (newsList != null && newsList!.isNotEmpty)
              Expanded(
                  child: ListView.builder(
                      itemCount: newsList!.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: newsList![index], child: articlesWidget());
                      }))
          ],
        )),
      ),
    );
  }
}
