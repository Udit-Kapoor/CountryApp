import 'package:flutter/material.dart';

class ShowSort extends StatefulWidget {
  const ShowSort({
    this.nameSort,
    this.codeSort,
  });

  final Function nameSort;
  final Function codeSort;

  @override
  _ShowSortState createState() => _ShowSortState();
}

class _ShowSortState extends State<ShowSort> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 140,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                TextButton(
                    child:
                        Text("Sort by Names", style: TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                    onPressed: () {
                      widget.nameSort();
                    }),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    child:
                        Text("Sort By Codes", style: TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                    onPressed: () {
                      widget.codeSort();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
