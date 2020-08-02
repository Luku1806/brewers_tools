import 'package:binary_music_tools/models/brew.dart';
import 'package:flutter/material.dart';

class BrewDetailList extends StatelessWidget {
  final Brew brew;

  BrewDetailList({@required this.brew});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "ABV: ${brew.abv != null ? "${brew.abv.toStringAsFixed(2)}%" : "--"}",
        ),
        Text(
          "Stammwürze: ${brew.wort != null ? "${brew.wort.toStringAsFixed(1)} °Plato" : "--"}",
        ),
        Text(
          "Restextrakt: ${brew.restWort != null ? "${brew.restWort.toStringAsFixed(1)} °Plato" : "--"}",
        ),
        Text(
          "Scheinbarer Endvergärungsgrad: ${brew.apparantFerm != null ? "${brew.apparantFerm.toStringAsFixed(2)}%" : "--"}",
        ),
        Text(
          "Tatsächlicher Endvergärungsgrad: ${brew.realFerm != null ? "${brew.realFerm.toStringAsFixed(2)}%" : "--"}",
        ),
      ],
    );
  }
}
