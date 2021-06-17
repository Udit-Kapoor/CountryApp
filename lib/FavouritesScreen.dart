import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'CountryDetailsScreen.dart';
import 'SearchCountriesCodeModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'flutter_flow/flutter_flow_theme.dart';

class FavouritesScreen extends StatelessWidget {
  final Box box;
  const FavouritesScreen({this.box});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text("Favourites"),
      //     centerTitle: true,
      //     leading: IconButton(
      //         icon: Icon(
      //           Icons.chevron_left,
      //           size: 30,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {
      //           Navigator.pop(context);
      //         })),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/home_image.png'),
                  fit: BoxFit.cover,
                )),
                child: Center(
                  child: Text(
                    'FAVOURITES',
                    style: FlutterFlowTheme.bodyText1.override(
                      fontFamily: 'Playfair Display',
                      color: FlutterFlowTheme.secondaryColor,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
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
          SizedBox(
            height: 20,
          ),
          ValueListenableBuilder(
              valueListenable: Hive.box('Favourites').listenable(),
              builder: (context, box, child) {
                var l = List.from(box.values);
                var model = new List();
                model.clear();
                for (int i = 0; i < l.length; i++) {
                  model.add(searchCountriesCodeFromJson(l[i]));
                }
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
              }),
        ],
      ),
    );
  }
}
