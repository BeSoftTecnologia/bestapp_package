import 'package:flutter/material.dart';

class BebuttonIcon extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final double buttonwidth;
  final double? buttonheight;
  final Function onPressed;
  final bool large;
  final Color? overlayColor;
  final Color? bgColor;
  final bool showOverlayColor;
  final Color? shadowColor;
  final Color? iconColor;
  final bool showShadowColor;
  final double? elevation;
  final double borderRadius;
  final IconData icon;
  final IconData? iconRight;
  final double iconSize;

  BebuttonIcon({
    this.text,
    this.textStyle, 
    this.buttonwidth = 300,
    this.iconColor,
    this.buttonheight,
    this.iconRight,
    required this.onPressed, 
    this.large=true,
    this.overlayColor,
    this.showOverlayColor=false,
    this.shadowColor,
    this.showShadowColor=false,
    this.elevation,
    this.borderRadius = 10,
    this.bgColor,
    this.iconSize=22,
    required this.icon,
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
          overlayColor: overlayColor != null && showOverlayColor ? MaterialStateProperty.all(overlayColor) : showOverlayColor ? MaterialStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.1)) : null,
          backgroundColor: bgColor != null ? MaterialStateProperty.all(bgColor) : MaterialStateProperty.all(Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(borderRadius),
            )
          ),
          shadowColor: shadowColor != null && showShadowColor ? MaterialStateProperty.all(shadowColor) : showShadowColor ? MaterialStateProperty.all(Theme.of(context).primaryColor) : null,
          elevation: elevation != null ? MaterialStateProperty.all(elevation) : MaterialStateProperty.all(0.0)
        ),
        onPressed: onPressed as void Function()?, 
        child: iconRight != null ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Icon(icon, color: iconColor, size: iconSize),
                SizedBox(width: 5),
                textLabel(),
                SizedBox(width: 5),
                Icon(iconRight, color: iconColor, size: iconSize)
            ]
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: iconSize),
              SizedBox(width: 5),
              textLabel()
            ]
          )
        // icon: Icon(icon),
        // icon: iconRight != null ? Icon(null) : Icon(icon),
        // label: iconRight != null ?
        // Expanded(
        //   flex: 1,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       // Icon(icon),
        //       // SizedBox(width: 5),
        //       textLabel(),
        //       SizedBox(width: 5),
        //       Icon(iconRight)
        //     ],
        //   ),
        // ) : textLabel()
      )
    );
  }
  Widget textLabel(){
    return Text(text != null ? text! : '',
      textScaleFactor: 1.0,
      style: textStyle != null ? textStyle : TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold
      )
    );
  }
}