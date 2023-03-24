// -----------------------------------------------------------------------------
// Tulakorn Sawangmuang 630510582 (Feature should have: Dark Theme)
// -----------------------------------------------------------------------------
// theme_management.dart
// -----------------------------------------------------------------------------
//
// This file is a file of the ThemeService class in Flutter, which is 
// responsible for managing application color themes. It has a method 
// to change the primary and secondary values and create a new
// MaterialColor from the hexColor and opacity values defined in the method. 
// changeColorCode and changeSubColorCode respectively. 
//
// This file is also ChangeNotifier This is part of the State Management 
// in Flutter that notifies the Widget when a ThemeService value 
// changes, allowing the Widget to display the correct theme colors that the user wants.

import 'package:flutter/material.dart';


// -----------------------------------------------------------------------------
// ThemeService
// -----------------------------------------------------------------------------
//
// The ThemeService class is a class used to manage themes and colors in an application, 
// with the variable color and subColor being initialize the widget before it has to render 
// its source and render the UI through the widget. MaterialColor. used to store color values with function 
// changeColorCode and changeSubColorCode Used to change the color values of the color and subColor variables 
// as specified in the const <int, Color> manifest. Each value in the function converts a value from the 
// hex color code to a MaterialColor.  The setColor and setSubColor functions change the values of color and subColor 
// respectively by setting values in the primarytheme and secondtheme to default values, and swapping them in the list 
// with reversed.toList() . Finally, notifyListeners() is called.  When a theme or color value is changed so that 
// the corresponding widget is rebuilt based on the current color and theme defined in this class.
class ThemeService extends ChangeNotifier {
  late MaterialColor color = changeColorCode(0xffffffff);
  late MaterialColor subColor = changeSubColorCode(0xffffffff);
  List <dynamic> primarytheme = [0xff424242, 0xffffffff];
  List <dynamic> secondtheme = [0xff616161, 0xffffffff];

  // setColor()
  //
  // This function is for changing application window background color.  
  // by calling the function changeSubColorCode to create a new 
  // MaterialColor and change the primarytheme value inverted, then call 
  // notifyListeners() to tell the Flutter framework that the value has changed.
  void setColor() {
    color = changeColorCode(primarytheme[0]);
    //reverse the primarytheme list
    primarytheme = primarytheme.reversed.toList();
    notifyListeners();
  }

  // setSubColor()
  //
  // This function is for changing application window background color.  
  // by calling the function changeColorCode() to create a new 
  // MaterialColor and change the secondtheme value inverted, then call 
  // notifyListeners() to tell the Flutter framework that the value has changed.
  void setSubColor() {
    subColor = changeSubColorCode(secondtheme[0]);
    //reverse the secondtheme list
    secondtheme = secondtheme.reversed.toList();
    notifyListeners();
  }

  // changeColorCode(int hexColor)
  //
  // This function is for changing application window background color. 
  // The parameter is a hexadecimal number (hexColor), which will be 
  // created. MaterialColor and return it to that MaterialColor.
  MaterialColor changeColorCode(int hexColor) {
    color = MaterialColor(hexColor, const <int, Color>{
      50: Color.fromRGBO(238, 129, 48, .1),
      100: Color.fromRGBO(238, 129, 48, .2),
      200: Color.fromRGBO(238, 129, 48, .3),
      300: Color.fromRGBO(238, 129, 48, .4),
      400: Color.fromRGBO(238, 129, 48, .5),
      500: Color.fromRGBO(238, 129, 48, .6),
      600: Color.fromRGBO(238, 129, 48, .7),
      700: Color.fromRGBO(238, 129, 48, .8),
      800: Color.fromRGBO(238, 129, 48, .9),
      900: Color.fromRGBO(238, 129, 48, 1),
    });
    return color;
  }

  // changeSubColorCode(int hexColor)
  //
  // This function is for changing application window border color. 
  // The parameter is a hexadecimal number (hexColor), which will be created.
  // MaterialColor and return it to that MaterialColor. 
  MaterialColor changeSubColorCode(int hexColor) {
    subColor = MaterialColor(hexColor, const <int, Color>{
      50: Color.fromRGBO(238, 129, 48, .1),
      100: Color.fromRGBO(238, 129, 48, .2),
      200: Color.fromRGBO(238, 129, 48, .3),
      300: Color.fromRGBO(238, 129, 48, .4),
      400: Color.fromRGBO(238, 129, 48, .5),
      500: Color.fromRGBO(238, 129, 48, .6),
      600: Color.fromRGBO(238, 129, 48, .7),
      700: Color.fromRGBO(238, 129, 48, .8),
      800: Color.fromRGBO(238, 129, 48, .9),
      900: Color.fromRGBO(238, 129, 48, 1),
    });
    return subColor;
  }
}