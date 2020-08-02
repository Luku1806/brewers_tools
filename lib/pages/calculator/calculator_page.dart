import 'package:binary_music_tools/blocs/brew_db/bloc.dart';
import 'package:binary_music_tools/blocs/brew_db/brew_db_bloc.dart';
import 'package:binary_music_tools/models/brew.dart';
import 'package:binary_music_tools/pages/calculator/widgets/abv_card.dart';
import 'package:binary_music_tools/pages/calculator/widgets/fermentation_card.dart';
import 'package:binary_music_tools/pages/calculator/widgets/wort_card.dart';
import 'package:binary_music_tools/widgets/brew_detail_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../beer_calculator.dart';

class CalculatorPage extends StatefulWidget {
  final Function onSave;

  CalculatorPage({@required this.onSave});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final GlobalKey<FormState> wordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> restWordFormKey = GlobalKey<FormState>();

  double _word;
  double _restWord;
  double _abv;
  double _apparantFerm;
  double _realFerm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxWidth: 480),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            WortCard(
              "Stammwürze",
              formKey: wordFormKey,
              onPlatoChanged: _onWortChanged,
            ),
            WortCard(
              "Restextrakt",
              formKey: restWordFormKey,
              onPlatoChanged: _onRestWortChanged,
            ),
            AbvCard(
              abv: _abv,
              restWord: _restWord,
            ),
            FermentationCard(
              apparentFermentation: _apparantFerm,
              realFermentation: _realFerm,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 4,
                bottom: 8,
                top: 16,
              ),
              child: MaterialButton(
                child: Text("Speichern"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.white,
                onPressed: () => _showSaveDialog(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onWortChanged(double word) {
    _word = word;
    updateValues();
  }

  void _onRestWortChanged(double word) {
    _restWord = word;
    updateValues();
  }

  void updateValues() {
    setState(() {
      if (_word != null && _restWord != null) {
        _abv = BeerCalculator.calculateABV(_word, _restWord);
        _apparantFerm =
            BeerCalculator.calculateApparantFermentation(_word, _restWord);
        _realFerm = BeerCalculator.calculateRealFermentation(_word, _restWord);
      } else if (_word != null) {
        _abv = BeerCalculator.approximateABV(_word);
        _apparantFerm = null;
        _realFerm = null;
      } else {
        _abv = null;
        _apparantFerm = null;
        _realFerm = null;
      }
    });
  }

  void _showSaveDialog() async {
    var _nameInputController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameInputController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: 'Wie soll das neue Bier heißen?',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: BrewDetailList(
                        brew: Brew(
                          name: "TMP",
                          wort: _word,
                          restWort: _restWord,
                          apparantFerm: _apparantFerm,
                          realFerm: _realFerm,
                          abv: _abv,
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        new FlatButton(
                          child: new Text("Abbrechen"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text("Speichern"),
                          onPressed: () {
                            _saveBrew(_nameInputController.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _saveBrew(String name) {
    if (name == null || name.isEmpty) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("Bitte gib einen Namen für das Bier ein!")),
      );
      return false;
    }

    context.bloc<BrewDbBloc>().add(
          SaveBrew(
            Brew(
              name: name,
              wort: _word,
              restWort: _restWord,
              apparantFerm: _apparantFerm,
              realFerm: _realFerm,
              abv: _abv,
            ),
          ),
        );

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text("${name} wurde gespeichert")),
    );
  }
}
