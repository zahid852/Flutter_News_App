import 'package:card_swiper/card_swiper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/consts/var.dart';
import 'package:news_app/models/bookmark_model.dart';
import 'package:news_app/providers/firebase_provider.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatefulWidget {
  final NewsType newsType;

  const LoadingWidget({super.key, required this.newsType});
  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  BorderRadius borderRadius = BorderRadius.circular(18);
  late Color baseShimmerColor, highLightShimmerColor, widgetShimmerColor;
  @override
  void didChangeDependencies() {
    var utils = Utils(context: context);
    highLightShimmerColor = utils.highlightShimmerColor;
    baseShimmerColor = utils.baseShimmerColor;
    widgetShimmerColor = utils.WidgetShimmerColor;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context: context).getScreenSize;
    return widget.newsType == NewsType.topTrending
        ? Swiper(
            viewportFraction: 0.9,
            itemCount: 5,
            itemWidth: size.width * 0.9,
            itemHeight: size.height * 0.5,
            autoplay: true,
            // autoplayDelay: 9000,
            layout: SwiperLayout.STACK,
            itemBuilder: ((context, index) {
              return TopTrendingLoadingWidget(
                  baseShimmerColor: baseShimmerColor,
                  highLightShimmerColor: highLightShimmerColor,
                  size: size,
                  widgetShimmerColor: widgetShimmerColor,
                  borderRadius: borderRadius);
            }))
        : Expanded(
            child: ListView.builder(
                itemCount: 20,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return articlesShimmerEffectWidget(
                      baseShimmerColor: baseShimmerColor,
                      highLightShimmerColor: highLightShimmerColor,
                      borderRadius: borderRadius,
                      widgetShimmerColor: widgetShimmerColor,
                      size: size);
                }),
          );
  }
}

class TopTrendingLoadingWidget extends StatelessWidget {
  const TopTrendingLoadingWidget({
    Key? key,
    required this.baseShimmerColor,
    required this.highLightShimmerColor,
    required this.size,
    required this.widgetShimmerColor,
    required this.borderRadius,
  }) : super(key: key);

  final Color baseShimmerColor;
  final Color highLightShimmerColor;
  final Size size;
  final Color widgetShimmerColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {},
          child: Shimmer.fromColors(
            baseColor: baseShimmerColor,
            highlightColor: highLightShimmerColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.height * 0.33,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: widgetShimmerColor),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.height * 0.03,
                      decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: widgetShimmerColor),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: widgetShimmerColor,
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: size.height * 0.035,
                        width: size.width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: widgetShimmerColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class articlesShimmerEffectWidget extends StatelessWidget {
  const articlesShimmerEffectWidget({
    Key? key,
    required this.baseShimmerColor,
    required this.highLightShimmerColor,
    required this.borderRadius,
    required this.widgetShimmerColor,
    required this.size,
  }) : super(key: key);

  final Color baseShimmerColor;
  final Color highLightShimmerColor;
  final BorderRadius borderRadius;
  final Color widgetShimmerColor;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  child: Shimmer.fromColors(
                    baseColor: baseShimmerColor,
                    highlightColor: highLightShimmerColor,
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: widgetShimmerColor,
                              ),
                              height: size.height * 0.14,
                              width: size.width * 0.26,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: size.height * 0.06,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: widgetShimmerColor,
                              ),
                            ),
                            verticalSpacing(5),
                            Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: size.height * 0.03,
                                  width: size.width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius,
                                    color: widgetShimmerColor,
                                  ),
                                )),
                            verticalSpacing(5),
                            FittedBox(
                              child: Row(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: widgetShimmerColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: size.height * 0.035,
                                    width: size.width * 0.45,
                                    decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: widgetShimmerColor,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
