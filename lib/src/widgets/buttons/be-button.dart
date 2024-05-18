import 'package:flutter/material.dart';

class Bebutton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double buttonwidth;
  final double? buttonheight;
  final Function onPressed;
  final bool large;
  final Color? overlayColor;
  final bool showOverlayColor;
  final Color? shadowColor;
  final bool showShadowColor;
  final double? elevation;
  final double borderRadius;
  final Color? bgColor;

  Bebutton({
    required this.text,
    this.textStyle, 
    this.buttonwidth = 300,
    this.buttonheight,
    required this.onPressed, 
    this.large=true,
    this.overlayColor,
    this.showOverlayColor=false,
    this.shadowColor,
    this.showShadowColor=false,
    this.elevation,
    this.bgColor,
    this.borderRadius = 10
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: large ? size.width : buttonwidth, 
        height: buttonheight != null ? buttonheight : 50
      ),
      child: ElevatedButton(                        
        style: ButtonStyle(
          overlayColor: overlayColor != null && showOverlayColor ? WidgetStateProperty.all(overlayColor) : showOverlayColor ? WidgetStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.1)) : null,
          backgroundColor: bgColor != null ? WidgetStateProperty.all(bgColor) : WidgetStateProperty.all(Theme.of(context).primaryColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(borderRadius),
            )
          ),
          shadowColor: shadowColor != null && showShadowColor ? WidgetStateProperty.all(shadowColor) : showShadowColor ? WidgetStateProperty.all(Theme.of(context).primaryColor) : null,
          elevation: elevation != null ? WidgetStateProperty.all(elevation) : WidgetStateProperty.all(0.0)
        ),
        onPressed: onPressed as void Function()?, 
        child: Text(text,
          textScaleFactor: 1.0,
          style: textStyle != null ? textStyle
          : Theme.of(context).textTheme.bodyMedium
          // TextStyle(
          //   fontSize: 14,
          // ),
        )
      )
    );
  }
}