import 'container_custom.dart';
import 'package:flutter/material.dart';

class TextCustomWidget extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final Alignment containerAlignment;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double marginLeft;
  final double marginRight;
  final double marginBottom;
  final double marginTop;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextDecoration? textDecoration;
  final TextOverflow? overflow;
  final TextDirection? textDirection;
  final TextStyle? googlefonts;
  final String? fontFamily;

  final int? maxLines;

  const TextCustomWidget({
    super.key,
    required this.text,
    this.height,
    this.width,
    this.containerAlignment = Alignment.centerLeft,
    this.textColor = Colors.white, //add the default text color
    this.textStyle,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    this.marginTop = 0,
    this.textAlign = TextAlign.left,
    this.letterSpacing,
    this.textDecoration,
    this.overflow,
    this.wordSpacing,
    this.textDirection,
    this.maxLines,
    this.googlefonts,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerCustom(
      height: height,
      width: width,
      paddingBottom: marginBottom,
      paddingLeft: marginLeft,
      paddingTop: marginTop,
      paddingRight: marginRight,
      alignment: containerAlignment,
      // child: PlatformText(
      //   text.toLowerCase(),
      //   textAlign: textAlign,
      //   textWidthBasis: TextWidthBasis.parent,
      //   overflow: overflow ?? TextOverflow.visible,
      //   maxLines: maxLines,
      //   textDirection: textDirection,
      //   style: textStyle ??
      //       TextStyle(
      //         color: textColor,
      //         fontSize: fontSize,
      //         fontWeight: fontWeight,
      //         fontStyle: fontStyle,
      //         letterSpacing: letterSpacing,
      //         decoration: textDecoration,
      //         overflow: overflow,
      //         wordSpacing: wordSpacing,
      //       ),
      // ),
      child: Text(
        text,
        textAlign: textAlign,
        textWidthBasis: TextWidthBasis.parent,
        overflow: overflow ?? TextOverflow.visible,
        maxLines: maxLines,
        textDirection: textDirection,
        style: textStyle ??
            TextStyle(
              fontFamily: fontFamily,
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing,
              decoration: textDecoration,
              overflow: overflow,
              wordSpacing: wordSpacing,
            ),
      ),
    );
  }
}
