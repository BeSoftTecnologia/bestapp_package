import 'package:flutter/material.dart';

PreferredSize bePreferredAppbar(){
  return PreferredSize(
    preferredSize: const Size.fromHeight(0.0),
    child: AppBar(elevation: 0.0),        
  );
}