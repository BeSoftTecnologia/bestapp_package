import 'package:flutter/material.dart';

class BebuttonOutlineIcon extends StatelessWidget {
  final String? text;
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
  final double? borderSide;
  final double? iconSize;
  final IconData icon;
  final Color? buttomColor;
  final Color? iconColor;

  BebuttonOutlineIcon({
    this.text,
    this.textStyle, 
    this.buttonwidth = 300,
    this.iconSize,
    this.buttonheight,
    required this.onPressed, 
    required this.icon,
    this.large=true,
    this.overlayColor,
    this.showOverlayColor=false,
    this.shadowColor,
    this.showShadowColor=false,
    this.elevation,
    this.borderRadius = 10,
    this.borderSide,
    this.buttomColor,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: large ? size.width : buttonwidth, 
        height: buttonheight != null ? buttonheight : 50
      ),
      child: OutlinedButton.icon(                          
        style: ButtonStyle(
          overlayColor: overlayColor != null && showOverlayColor ? WidgetStateProperty.all(overlayColor) : showOverlayColor ? WidgetStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.1)) : null,
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
        icon: text != null ? Icon(icon, size: iconSize, color: iconColor) : null,
        label: text == null ? Icon(icon, size: iconSize, color: iconColor) :
          Text(text != null ? text! : '',
            style: textStyle != null ? textStyle
            : TextStyle(
              fontSize: 0,
              fontWeight: FontWeight.bold
            ),
          )
      )
    );
  }
}