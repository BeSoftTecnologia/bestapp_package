import 'dart:ui';
import 'package:bestapp_package/bestapp_package.dart';
import 'package:bestapp_package/src/models/enums.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

void beDialogToast({
  required BuildContext context,  
  required String message,
  String? dismissText,
  bool showTitle = false,
  bool showProgressIndicator = false,
  bool barrierDismissible = false,
  double borderRadius = 50.0,
  int duration = 4,
  int elevation = 4,
  double margin =20,
  DialogPosition dialogPosition = DialogPosition.BOTTOM,
  DialogColorType dialogColorType = DialogColorType.DEFAULT,
}){
  showFlash(
    context: context, 
    duration: Duration(seconds: duration), 
    builder: (context, controller){
      return Flash.bar(
        backgroundColor: DialogColorType.DEFAULT == dialogColorType ? Colors.black54 : 
        DialogColorType.DANGER == dialogColorType ? Colors.red[400] :
        DialogColorType.SUCESS == dialogColorType ? Colors.green[400] : 
        DialogColorType.INFO == dialogColorType ? Colors.blue[400] :
        DialogColorType.WARNING == dialogColorType ? Colors.orange[400] : Colors.black54,
        controller: controller,
        barrierDismissible: barrierDismissible,
        position: dialogPosition == DialogPosition.TOP ? FlashPosition.top : FlashPosition.bottom,
        boxShadows: kElevationToShadow[elevation],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
        margin: EdgeInsets.all(margin),
        borderRadius: BorderRadius.circular(borderRadius),
        child: FlashBar(
        icon: Icon(Icons.info, color: Colors.white),
        title: showTitle ? Text('Alert !') : null,
          showProgressIndicator: showProgressIndicator,
          content: Text(message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          primaryAction: barrierDismissible ? TextButton(
            onPressed: () => controller.dismiss(),
            child: Text(
              '$dismissText', 
              style: TextStyle(
                color: Colors.white
              )
            ),
          ) : null
        ),
      );
    }
  );
}