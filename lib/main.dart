import 'package:faks_app/providers/notes.dart';
import 'package:faks_app/widgets/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './screens/group_screen.dart';
import './providers/groups.dart';
import './screens/addNoteScreen.dart';
import './screens/addGroupScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Groups()),
        ChangeNotifierProvider(create: (ctx) => Notes())
      ],
      child: MaterialApp(
        title: 'Personal Notes',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          }),
          //  brightness: Brightness.dark,
          primarySwatch: Colors.purple,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontFamily: 'Cute',
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            bodyText1: TextStyle(
              fontFamily: 'Cute2',
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              fontSize: 24,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: GroupScreen(),
        routes: {
          NoteScreen.routeName: (ctx) => NoteScreen(),
          AddGroupScreen.routeName: (ctx) => AddGroupScreen(),
        },
      ),
    );
  }
}
