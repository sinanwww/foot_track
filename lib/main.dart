import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:foot_track/model/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(PlayerModelAdapter());
  Hive.registerAdapter(TeamModelAdapter());
  Hive.registerAdapter(MatchModelAdapter());
  // Open boxes
  await Hive.openBox<PlayerModel>('players');
  await Hive.openBox<TeamModel>('teams');
  await Hive.openBox<MatchModel>('matches');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FootTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: AppTheam.scaffoldBg,
      ),
      home: const NavController(),
    );
  }
}
