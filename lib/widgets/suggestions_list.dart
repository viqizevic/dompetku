import 'package:flutter/material.dart';

class SuggestionsList extends StatelessWidget {
  final Set<String> suggestions;
  final Function applySuggestionCallback;

  SuggestionsList({
    this.suggestions,
    this.applySuggestionCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: suggestions.isNotEmpty,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((s) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: FlatButton(
                child: Text(
                  s,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                color: Colors.blueAccent,
                onPressed: () {
                  applySuggestionCallback(s);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
