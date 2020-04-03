import 'package:flutter/material.dart';

class CalculatorFormatting {
  static const double edgeInsetCalcButton = 10;

  static Widget generateCalcButton(String text, MaterialColor color, int colorWeight, bool fade, Function onClick) {
    return Material(
      color: color[colorWeight], // color and opacity of the container
      child: InkWell(
        onTap: () => onClick(text),
        child: Container(
          padding: EdgeInsets.all(edgeInsetCalcButton), // vertical padding
          child: Opacity(
            opacity: fade ? 0.5 : 1,
            child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)), // text styles
          )
        )
      ) 
    ); 
  }

  static ListView getCalcEntries(List<String> entries) {
    return ListView.builder( 
      itemCount: entries.length, // how many items in list 
      primary: false,            // whether to scroll when items fit within given space
      itemBuilder: (BuildContext context, int index) => // generator 
        Container(               // template for list item 
          height: 50, 
          child: Align(          // aligns text to the center right 
            alignment: Alignment.centerRight,
            // text style 
            child: Text(
              entries[index], 
              style: TextStyle(color: Colors.black.withOpacity(0.5))
            )
          )
        )
    );
  }

  static GridView getCalcButtonLayout(MaterialColor themeColor, Function onClick) =>
      (GridView.count(
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 40), // padding around main container (grid)
          crossAxisSpacing: 3, // space between the columns
          mainAxisSpacing: 3, // space between the rows
          crossAxisCount: 4, // number of items per row / num of columns
          children: <Widget>[
            // row 0
            generateCalcButton("^", themeColor, 100, true, onClick),
            generateCalcButton("+/-", themeColor, 100, true, onClick),
            generateCalcButton("√", themeColor, 100, true, onClick),
            generateCalcButton("/", themeColor, 100, true, onClick),
            // row 1
            generateCalcButton("9", themeColor, 300, false, onClick),
            generateCalcButton("8", themeColor, 300, false, onClick),
            generateCalcButton("7", themeColor, 300, false, onClick),
            generateCalcButton("*", themeColor, 100, true, onClick),
            // row 2
            generateCalcButton("6", themeColor, 500, false, onClick),
            generateCalcButton("5", themeColor, 500, false, onClick),
            generateCalcButton("4", themeColor, 500, false, onClick),
            generateCalcButton("+", themeColor, 100, true, onClick),
            // row 3
            generateCalcButton("3", themeColor, 700, false, onClick),
            generateCalcButton("2", themeColor, 700, false, onClick),
            generateCalcButton("1", themeColor, 700, false, onClick),
            generateCalcButton("-", themeColor, 100, true, onClick),
            // row 4
            generateCalcButton("AC", themeColor, 100, false, onClick),
            generateCalcButton("0", themeColor, 900, false, onClick),
            generateCalcButton("π", themeColor, 900, false, onClick),
            generateCalcButton("=", themeColor, 100, true, onClick)
          ]));
}
