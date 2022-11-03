import 'package:flutter/material.dart';
import 'package:threebotlogin/core/router/classes/router.classes.dart';
import 'package:threebotlogin/core/router/tabs/helpers/tabs.helpers.dart';

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
    itemCount: JRouter().routes.length,
    physics: ClampingScrollPhysics(),
    itemBuilder: (context, index) {
      return JRouter().routes[index].route.canSee
          ? ListTile(
              minLeadingWidth: 10,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(left: 30)),
                  Icon(JRouter().routes[index].route.icon, color: Colors.black, size: 18)
                ],
              ),
              title: Text(JRouter().routes[index].route.name, style: TextStyle(fontWeight: FontWeight.w400)),
              onTap: () async {
                bool? pinRequired = JRouter().routes[index].route.pinRequired;
                if (pinRequired == true) {
                    await navigateIfAuthenticated(JRouter().routes[index].route);
                }

                await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => JRouter().routes[index].route.view));
              },
            )
          : Container();
    },
  );
}
