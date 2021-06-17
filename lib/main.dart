import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grroom/AllCountriesModel.dart';
import 'package:grroom/SearchCountriesCodeModel.dart';
import 'package:grroom/SearchCountriesModel.dart';
import 'package:grroom/sort.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'package:grroom/CountryDetailsScreen.dart';
import 'FavouritesScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

enum SearchType { name, code }

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  bool check = true;
  bool sortAlpha = false;
  bool sortCode = false;
  SearchType f = SearchType.name;
  Widget showDynamicBody() {
    if (check) {
      return FutureBuilder<dynamic>(
        future: getAllCountries(),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var model = allCountriesFromJson(snapshot.data);
          if (sortAlpha) {
            model.sort((a, b) {
              return b.name
                  .toString()
                  .toLowerCase()
                  .compareTo(a.name.toString().toLowerCase());
            });
          } else if (sortCode) {
            model.sort((a, b) {
              return b.alpha2Code
                  .toString()
                  .toLowerCase()
                  .compareTo(a.alpha2Code.toString().toLowerCase());
            });
          }
          print("recieved data");
          return Builder(
            builder: (context) {
              // final departments = (getJsonField(
              //             gridViewGetDepartmentsResponse,
              //             r'$.departments') ??
              //         [])
              //     .take(30)
              //     .toList();
              return GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.6,
                ),
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: model.length,
                itemBuilder: (context, departmentsIndex) {
                  final departmentsItem = model[departmentsIndex];
                  final Widget networkSvg = Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: SvgPicture.network(
                          departmentsItem.flag,
                          fit: BoxFit.cover,

                          // placeholderBuilder: (BuildContext context) => Container(
                          //     padding: const EdgeInsets.all(30.0),
                          //     child: const CircularProgressIndicator(
                          //       backgroundColor: Colors.redAccent,
                          //     )),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(departmentsItem.name)),
                    ],
                  );
                  return GestureDetector(
                    onTap: () async {
                      print("tap");
                      var dir = await getApplicationDocumentsDirectory();
                      Hive.init(dir.path);
                      box = await Hive.openBox('Favourites');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CountryDetails(
                            model: departmentsItem,
                            box: box,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: networkSvg,
                      // child: CachedNetworkImage(
                      //   imageUrl: departmentsItem.flag,
                      //   imageBuilder: (context, imageProvider) => Container(
                      //     decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: imageProvider,
                      //           fit: BoxFit.cover,
                      //           colorFilter: ColorFilter.mode(
                      //               Colors.red, BlendMode.colorBurn)),
                      //     ),
                      //   ),
                      //   placeholder: (context, url) =>
                      //       CircularProgressIndicator(),
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      // ),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    } else {
      if (f == SearchType.name)
        return FutureBuilder<dynamic>(
          future: getSearchCountries(textController.text),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var model;
            try {
              model = searchCountriesFromJson(snapshot.data.data);
            } catch (e) {
              return Text("No Data Found");
            }
            final gridViewGetDepartmentsResponse = snapshot.data;
            return Builder(
              builder: (context) {
                // final departments = (getJsonField(
                //             gridViewGetDepartmentsResponse,
                //             r'$.departments') ??
                //         [])
                //     .take(30)
                //     .toList();
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: model.length,
                  itemBuilder: (context, departmentsIndex) {
                    final departmentsItem = model[departmentsIndex];
                    final Widget networkSvg = SvgPicture.network(
                      departmentsItem.flag,
                      fit: BoxFit.fill,

                      // placeholderBuilder: (BuildContext context) => Container(
                      //     padding: const EdgeInsets.all(30.0),
                      //     child: const CircularProgressIndicator(
                      //       backgroundColor: Colors.redAccent,
                      //     )),
                    );
                    return InkWell(
                      onTap: () async {
                        print("tap");
                        var dir = await getApplicationDocumentsDirectory();
                        Hive.init(dir.path);
                        box = await Hive.openBox('Favourites');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CountryDetails(
                              model: departmentsItem,
                              box: box,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: networkSvg,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      else if (textController.text.length <= 3 &&
          textController.text.length >= 2) {
        return FutureBuilder<dynamic>(
          future: getCodeCountries(textController.text),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var model = searchCountriesCodeFromJson(snapshot.data.data);
            final gridViewGetDepartmentsResponse = snapshot.data;
            return Builder(
              builder: (context) {
                // final departments = (getJsonField(
                //             gridViewGetDepartmentsResponse,
                //             r'$.departments') ??
                //         [])
                //     .take(30)
                //     .toList();
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 1,
                  itemBuilder: (context, departmentsIndex) {
                    final departmentsItem = model;
                    final Widget networkSvg = SvgPicture.network(
                      departmentsItem.flag,
                      fit: BoxFit.fill,

                      // placeholderBuilder: (BuildContext context) => Container(
                      //     padding: const EdgeInsets.all(30.0),
                      //     child: const CircularProgressIndicator(
                      //       backgroundColor: Colors.redAccent,
                      //     )),
                    );
                    return GestureDetector(
                      onTap: () async {
                        print("tap");
                        var dir = await getApplicationDocumentsDirectory();
                        Hive.init(dir.path);
                        box = await Hive.openBox('Favourites');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CountryDetails(
                              model: departmentsItem,
                              box: box,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: networkSvg,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      } else {
        return Text(
            "To Search With Code limit Search Character Length must be 2 or 3");
      }
    }
  }

  nameSort() {
    setState(() {
      sortAlpha = !sortAlpha;
    });
  }

  codeSort() {
    setState(() {
      sortCode = !sortCode;
    });
  }

  Widget sort() {
    return IconButton(
      icon: Icon(
        Icons.sort,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return ShowSort(
                nameSort: nameSort,
                codeSort: codeSort,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.favorite,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Colors.red,
        onPressed: () async {
          var dir = await getApplicationDocumentsDirectory();
          Hive.init(dir.path);
          box = await Hive.openBox('Favourites');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavouritesScreen(
                box: box,
              ),
            ),
          );
        },
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Image.asset(
                    'assets/images/home_image.png',
                    width: double.infinity,
                    height: 255,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: sort(),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(25, 0, 0, 10),
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.favorite,
                        //       color: Colors.red,
                        //     ),
                        //     onPressed: () async {
                        //       await openBox();
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => FavouritesScreen(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 17),
                          child: Text(
                            'Countries',
                            style: FlutterFlowTheme.title1.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.secondaryColor,
                              fontSize: 23,
                            ),
                          ),
                          // child: Image.asset(
                          //   'assets/images/logo_flutterMet_white.png',
                          //   width: 120,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        Text(
                          'Your place for searching Countries',
                          style: FlutterFlowTheme.bodyText1.override(
                            fontFamily: 'Playfair Display',
                            color: FlutterFlowTheme.secondaryColor,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                value: SearchType.name,
                                groupValue: f,
                                onChanged: (SearchType value) {
                                  setState(() {
                                    f = value;
                                  });
                                }),
                            Text(
                              "Name",
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Playfair Display',
                                color: FlutterFlowTheme.secondaryColor,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Radio(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white),
                                value: SearchType.code,
                                groupValue: f,
                                onChanged: (SearchType value) {
                                  setState(() {
                                    f = value;
                                  });
                                }),
                            Text(
                              "Code",
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Playfair Display',
                                color: FlutterFlowTheme.secondaryColor,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 27, 0, 0),
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    // onTap: () async {
                                    //   await Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           SearchResultsPageWidget(
                                    //         searchTerm: textController.text,
                                    //       ),
                                    //     ),
                                    //   );
                                    // },
                                    child: Icon(
                                      Icons.search,
                                      color: FlutterFlowTheme.tertiaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 0, 2),
                                      child: TextFormField(
                                        onEditingComplete: () {
                                          setState(() {
                                            if (textController.text == "") {
                                              check = true;
                                            } else {
                                              check = false;
                                            }
                                          });
                                        },
                                        // onChanged: (value) {
                                        //   setState(() {
                                        //     print(textController.text);
                                        //   });
                                        // },
                                        controller: textController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search artist, maker, department...',
                                          hintStyle: FlutterFlowTheme.bodyText1
                                              .override(
                                            fontFamily: 'Playfair Display',
                                            fontSize: 16,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                        ),
                                        style:
                                            FlutterFlowTheme.bodyText1.override(
                                          fontFamily: 'Playfair Display',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(-1, 0),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 15, 0, 20),
                            // child: Text(
                            //   'Museum Departments',
                            //   style: FlutterFlowTheme.bodyText1.override(
                            //     fontFamily: 'Playfair Display',
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                          ),
                        ),
                        showDynamicBody(),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
