import 'package:flutter/material.dart';
import 'package:threebotlogin/core/router/routes/router.routes.dart';

Widget logo = Container(
  width: 200,
  height: 100,
  child: Padding(
      padding: const EdgeInsets.all(20),
      child: DrawerHeader(
        child: Text(''),
        decoration: BoxDecoration(
          image: new DecorationImage(
            alignment: Alignment.center,
            image: AssetImage("assets/logo.png"),
            fit: BoxFit.contain,
          ),
        ),
      )),
);

Widget tabs() {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: routes.length,
    physics: ClampingScrollPhysics(),
    itemBuilder: (context, index) {
      return routes[index].route.canSee
          ? ListTile(
              minLeadingWidth: 10,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(left: 30)),
                  Icon(routes[index].route.icon, color: Colors.black, size: 18)
                ],
              ),
              title: Text(routes[index].route.name, style: TextStyle(fontWeight: FontWeight.w400)),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => routes[index].route.view));
              },
            )
          : Container();
    },
  );
}
