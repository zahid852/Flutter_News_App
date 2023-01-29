import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

enum NewsType {
  topTrending,
  allNews,
}

enum SortByEnum {
  relevancy,
  popularity,
  publishedAt,
}

TextStyle smallTextStyle = GoogleFonts.montserrat(fontSize: 15);

const SearchKeywords = [
  'Flutter',
  'Python',
  'Football',
  'Weather',
  'Crypto',
  'Bitcoin',
  'Youtube',
  'Netflix',
  'Meta'
];
