import 'package:flutter/material.dart';
import 'package:news_app/services/utils.dart';

class emptyNewsWidget extends StatelessWidget {
  const emptyNewsWidget(this.text, this.imagePath, {Key? key})
      : super(key: key);
  final String text, imagePath;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context: context).getThemeTextColor;
    return Padding(
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(18),
              child: Image.asset(imagePath),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
