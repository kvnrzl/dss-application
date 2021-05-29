import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChildFormWidget extends StatefulWidget {
  String title;
  String keyItems;
  int bobot;
  Map mapItems;

  ChildFormWidget(
      {@required this.title,
      @required this.keyItems,
      @required this.bobot,
      @required this.mapItems});
  @override
  _ChildFormWidgetState createState() => _ChildFormWidgetState();
}

class _ChildFormWidgetState extends State<ChildFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(widget.title),
      Expanded(
        child: DropdownButton(
            isExpanded: true,
            value: widget.keyItems,
            onChanged: (newValue) {
              setState(() {
                widget.keyItems = newValue;
                widget.bobot = widget.mapItems[newValue];
              });
            },
            items: widget.mapItems.entries.map((entry) {
              return DropdownMenuItem(
                child: Center(child: Text(entry.key)),
                value: entry.key,
              );
            }).toList()),
      )
    ]);
  }
}
