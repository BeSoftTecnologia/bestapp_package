import 'package:flutter/material.dart';

class BebuttonOutline extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double buttonWidth;
  final double? buttonHeight;
  final Function onPressed;
  final bool large;
  final Color? overlayColor;
  final bool showOverlayColor;
  final Color? shadowColor;
  final bool showShadowColor;
  final double? elevation;
  final double borderRadius;
  final Color? buttomColor;
  final double? borderSide;
  

  BebuttonOutline({
    required this.text,
    this.textStyle, 
    this.buttonWidth = 300,
    this.buttonHeight,
    required this.onPressed, 
    this.large=true,
    this.overlayColor,
    this.showOverlayColor=false,
    this.shadowColor,
    this.showShadowColor=false,
    this.elevation,
    this.buttomColor,
    this.borderRadius = 10,
    this.borderSide
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: large ? size.width : buttonWidth, 
        height: buttonHeight != null ? buttonHeight : 50
      ),
      child: OutlinedButton(                            
        style: ButtonStyle(
          overlayColor: overlayColor != null && showOverlayColor ? WidgetStateProperty.all(overlayColor) : showOverlayColor ? WidgetStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.1)) : null,
          foregroundColor: buttomColor != null ? WidgetStateProperty.all(buttomColor) : WidgetStateProperty.all(Theme.of(context).primaryColor),
          side: buttomColor != null ? WidgetStateProperty.all(borderSide != null ? BorderSide(width: borderSide!, color: buttomColor!) : BorderSide(width: 1, color: buttomColor!)) : WidgetStateProperty.all(borderSide != null ? BorderSide(width: borderSide!, color: Theme.of(context).primaryColor) : BorderSide(width: 1, color: Theme.of(context).primaryColor)),
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
          : TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        )
      )
    );
  }
}