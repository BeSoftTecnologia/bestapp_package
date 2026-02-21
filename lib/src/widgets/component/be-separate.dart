import 'package:flutter/material.dart';

Widget beSeparate(BuildContext context,{double height=10, EdgeInsets? padding}){
  return Padding(
    padding: padding ?? EdgeInsets.symmetric(horizontal: 0),
    child: Column(
      children: <Widget>[
        SizedBox(height: height),
        Container(
          color: Colors.grey[200],
          width: MediaQuery.of(context).size.width,
          height: 1,
        ),
        SizedBox(height: height)
      ]
    )
  );
}