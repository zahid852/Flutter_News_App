import 'package:flutter/widgets.dart';

class verticalSpacing extends StatelessWidget {
  final double height;
  verticalSpacing(this.height);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
