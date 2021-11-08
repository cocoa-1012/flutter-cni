// main.dart

import 'package:cni_app/splashScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'Api/helper.dart';
// import 'materialQrCodepage.dart';
import 'provider/project_Provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    showBadge: true,
    playSound: true,
    enableLights: true,
    enableVibration: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> _navigator = new GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
                color: Colors.blue,
                enableLights: true,
                playSound: true,
                sound: RawResourceAndroidNotificationSound('notification'),
                priority: Priority.high,
                importance: Importance.max,
                enableVibration: true,
                fullScreenIntent: true,
              ),
            ),
            payload: notification.title);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _navigator.currentState!.pushNamed('/betPage');
      }
    });
    FirebaseMessaging.instance.getToken().then((String? deviceToken) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('deviceToken', deviceToken.toString());
      // saveToken(deviceToken.toString());
      print('this is firebase toke $deviceToken');
    });
  }

// Api api = Api();
// Future<void> saveToken(String deviceToken) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   String authToken = prefs.getString("token").toString();
//   var response = await api.notificationToken(authToken, deviceToken);
//   if (response.statusCode == 204 || response.statusCode == 200) {
//     if (response.body.isNotEmpty) {
//       final responseJson = json.decode(response.body);
//       print('this is response from backend $responseJson');
//     }
//   }
// }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'CNI App',
        home:
            // MatarialInvQrcodepage()
            //  HomePage()
            SplashScreen(),
      ),
    );
  }
}
