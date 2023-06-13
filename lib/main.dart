import 'package:demeter/providers/user_provider.dart';
import 'package:demeter/responsive/mobile_screen_layout.dart';
import 'package:demeter/responsive/responsive_layout_screen.dart';
import 'package:demeter/responsive/web_screen_layout.dart';
import 'package:demeter/screens/login_screen.dart';
import 'package:demeter/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBIDDqOxsD-Q1byrGwwbi4yMDOsjM5S7D8',
        appId: '1:145167577543:web:a492c1f7ba8b99e9bf29e2',
        messagingSenderId: '145167577543',
        projectId: 'instagram-clone-a9055',
        storageBucket: 'instagram-clone-a9055.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: goldDemeter),
          ),
          scaffoldBackgroundColor: greenDemeter,
        ),
        //home: ResponsiveLayout(
        //  mobileScreenLayout: MobileScreenLayout(),
        //  webScreenLayout: WebScreenLayout(),
        //),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginScreen();
          }),
        ),
      ),
    );
  }
}
