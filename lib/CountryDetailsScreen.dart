import 'package:flutter/material.dart';
import 'package:grroom/AllCountriesModel.dart';
import 'package:grroom/SearchCountriesCodeModel.dart';

import 'SearchCountriesModel.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class CountryDetails extends StatefulWidget {
  final dynamic model;
  final Box box;
  CountryDetails({Key key, this.model, this.box}) : super(key: key);
  @override
  _CountryDetailsState createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  Future putData(data) async {
    if (!widget.box.containsKey(data.name)) {
      print(data.name);
      Type t = data.runtimeType;
      print(t);
      if (t == AllCountries) {
        widget.box.put(data.name, allCountriesSingleToJson(data));
        print("job done");
      } else if (t == SearchCountries) {
        widget.box.put(data.name, searchCountriesSingleToJson(data));
      } else if (t == SearchCountriesCode) {
        widget.box.put(data.name, searchCountriesCodeToJson(data));
      }

      // box.put(data.name, allCountriesSingleToJson(data));

    } else {
      widget.box.delete(data.name);
      print("Removed from Favourites");
    }
    // for (var d in data) {
    //   box.add(d);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       icon: Icon(
      //         Icons.chevron_left,
      //         size: 40,
      //         color: Colors.black,
      //       ),
      //       onPressed: () => Navigator.pop(context)),
      //   title: Text(
      //     "Country Details",
      //     style: TextStyle(
      //         fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      // ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                height: 250,
                //width: 400,

                child: Stack(
                  children: [
                    SvgPicture.network(
                      widget.model.flag,
                      fit: BoxFit.cover,

                      // placeholderBuilder: (BuildContext context) => Container(
                      //     padding: const EdgeInsets.all(30.0),
                      //     child: const CircularProgressIndicator(
                      //       backgroundColor: Colors.redAccent,
                      //     )),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () => {Navigator.pop(context)}),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.name,
                      style: FlutterFlowTheme.title1.override(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.model.capital,
                      style: FlutterFlowTheme.subtitle1.override(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Domain: " + widget.model.topLevelDomain[0],
                      style: FlutterFlowTheme.subtitle1.override(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Alpha2Code: " + widget.model.alpha2Code,
                      style: FlutterFlowTheme.subtitle1.override(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 320,
                      height: 50,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(45, 45))),
                      child: Row(
                        children: [
                          Text("Population"),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Center(
                                child:
                                    Text(widget.model.population.toString())),
                            // child: DropdownButton<String>(
                            //     value: size,
                            //     isExpanded: true,
                            //     icon: Icon(Icons.keyboard_arrow_down),
                            //     iconSize: 42,
                            //     underline: SizedBox(),
                            //     onChanged: (String newValue) {
                            //       setState(() {
                            //         size = newValue;
                            //       });
                            //     },
                            //     items: <String>[
                            //       '4.4 lbs',
                            //       '2.0 lbs',
                            //       '3.5 lbs',
                            //       '4.3 lbs'
                            //     ].map<DropdownMenuItem<String>>(
                            //         (String value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value,
                            //         child: Center(child: Text(value)),
                            //       );
                            //     }).toList()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Borders",
                      style: FlutterFlowTheme.subtitle1.override(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: Text(
                      widget.model.borders.join(" "),
                      style: FlutterFlowTheme.subtitle1.override(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Native Name",
                      style: FlutterFlowTheme.subtitle1.override(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.model.nativeName),
                    SizedBox(
                      height: 15,
                    ),
                    //Todo :  ADD FAVOURITES FUNCTIONALITY
                    IconButton(
                        icon: Icon(
                          Icons.favorite,
                          size: 45,
                          color: widget.box.containsKey(widget.model.name)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () async {
                          // await openBox();
                          await putData(widget.model);
                          setState(() {});
                        })
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
