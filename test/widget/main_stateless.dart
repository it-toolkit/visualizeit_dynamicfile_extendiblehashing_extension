import 'package:flutter/material.dart';

void main() {
 runApp(new MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'My Dog App',
     home: Scaffold(
        /* appBar: AppBar(
         title: Text('Yellow Lab'),
       ),*/
       body: Center(
         child: InteractiveViewer(
          clipBehavior: Clip.none,
           child: Container( 
            height: 700,  
            width: 500, 
            // Using image from local storage 
            child: Image.asset( 
              "assets/avengers.jpg", 
            ), 
         ),
       ),
     ),
    ),
   );
 }
}