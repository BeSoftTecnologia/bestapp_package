import 'package:flutter/material.dart';

class BeDialogContent extends StatelessWidget {
  final String title;
  final String message;
  final String? okText;
  final Function? okTaped;
  final String? cancelText;
  final Function? cancelTaped;
  final IconData? iconMsg;
  final Color? icColor;
  final Widget? okWidget;
  final Widget? cancelWidget;

  BeDialogContent({
    required this.message,
    this.title='',
    this.okTaped,
    this.cancelTaped,
    this.okText,
    this.cancelText,
    this.iconMsg,
    this.okWidget,
    this.cancelWidget,
    this.icColor
  });
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: iconMsg != null ? Icon(iconMsg, size: 100, color: icColor) : Icon(Icons.check_circle, size: 100, color: icColor)
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  '$title',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
              Container(
                padding: EdgeInsets.only(left:20, right: 20),
                child: Text(
                  '$message',
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cancelTaped != null && cancelWidget == null ?
                  GestureDetector(
                    onTap: cancelTaped as void Function()?,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('$cancelText',
                      textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                    ),
                  ) : Container(),
                  cancelWidget != null ?
                  cancelWidget! : Container(),

                  cancelTaped != null || okWidget != null || cancelWidget != null  ?
                  SizedBox(width: 20) : Container(),

                  okWidget != null ?
                  okWidget! :
                  GestureDetector(
                    onTap: okTaped as void Function()?,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('$okText',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      )
                    )
                  )
                ],
              ),
              // InkWell(
              //   onTap: okTaped, 
              //   child: Container(
              //     // width: 150,
              //     padding: EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColor,
              //       borderRadius: BorderRadius.circular(10)
              //     ),
              //     child: Center(
              //       child: Text('$okText',
              //         style: TextStyle(
              //           color: Theme.of(context).colorScheme.background,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18
              //         ),
              //       ),
              //     ),
              //   )
              // ),
              SizedBox(height: 20),
            ],
          ),
        ),
        // height: height != null ? height : 300,
        // width: 400,
        // child: Column(
        //   children:[
        //     // Container(
        //     //   width: double.infinity,
        //     //   height: 150,
        //     //   decoration: BoxDecoration(
        //     //     borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
        //     //   ),
        //     //   child: Center(
        //     //     child: iconMsg != null ? Icon(iconMsg, size: 100, color: icColor) : Icon(Icons.check_circle, size: 100, color: icColor)
        //     //   ),
        //     // ),
        //     Column(
        //       children: [
        //         // Container(
        //         //   padding: EdgeInsets.all(10),
        //         //   child: Text(
        //         //     '$title',
        //         //     maxLines: 1,
        //         //     style: TextStyle(
        //         //       fontSize: 24,
        //         //       color: Colors.grey[600],
        //         //       fontWeight: FontWeight.bold
        //         //     ),
        //         //   )
        //         // ),
        //         // Expanded(
        //         //   child: Container(
        //         //     padding: EdgeInsets.only(left:20, right: 20),
        //         //     child: Text(
        //         //       '$message',
        //         //       textAlign: TextAlign.center,
        //         //       maxLines: 5,
        //         //       style: TextStyle(
        //         //         fontSize: 17,
        //         //         color: Colors.grey[400],
        //         //       ),
        //         //     ),
        //         //   )
        //         // )
        //       ]
        //     ),
        //     // Container(
        //     //   width: double.infinity,
        //     //   padding: EdgeInsets.only(left:10, right: 10, bottom: 10),
        //     //   decoration: BoxDecoration(
        //     //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
        //     //   ),
        //     //   child: Row(
        //     //     children: [
        //     //       okTaped != null ?
        //     //       Expanded(
        //     //         flex: 1,
        //     //         child: Bebutton(
        //     //           borderRadius: 5,
        //     //           onPressed: okTaped,
        //     //           text: '$okText'
        //     //         )
        //     //       ) : Container(),

        //     //       cancelTaped != null && okTaped != null ?
        //     //       SizedBox(width: 10) : Container(),
                  
        //     //       cancelTaped != null ?
        //     //       Expanded(
        //     //         flex: 1,
        //     //         child: Bebutton(
        //     //           borderRadius: 5,
        //     //           onPressed: cancelTaped,
        //     //           text: '$cancelText'
        //     //         )
        //     //       ) : Container()
        //     //     ],
        //     //   ),
        //     // ),
        //   ]
        // ),
      )
    );
  }
}