import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/tournament/round_model.dart';
import 'package:foot_track/model/tournament/tournament_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PlayerModelAdapter());
  Hive.registerAdapter(TeamModelAdapter());
  Hive.registerAdapter(MatchModelAdapter());
  Hive.registerAdapter(TournamentModelAdapter());
  Hive.registerAdapter(RoundModelAdapter());
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
    return ScreenUtilInit(
      designSize: const Size(393, 808), //pixel 3a
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'FootTrack',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const NavController(),
        );
      },
    );
  }
}
