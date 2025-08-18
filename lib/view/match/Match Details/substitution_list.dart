import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:intl/intl.dart';

class SubstitutionList extends StatelessWidget {
  final List<Map<String, dynamic>> substitutions;
  final TeamModel? homeTeam;
  final TeamModel? awayTeam;

  const SubstitutionList({
    super.key,
    required this.substitutions,
    this.homeTeam,
    this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    final playerRepo = PlayerRepo();
    if (substitutions.isEmpty) {
      return const Text("No substitutions recorded");
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: substitutions.length,
      itemBuilder: (context, index) {
        final sub = substitutions[index];
        final outPlayerKey = sub['outPlayerKey'] as String;
        final inPlayerKey = sub['inPlayerKey'] as String;
        final time = sub['time'] as DateTime;
        final isHome = sub['isHome'] as bool;
        return FutureBuilder(
          future: Future.wait([
            playerRepo.getPlayer(outPlayerKey),
            playerRepo.getPlayer(inPlayerKey),
          ]),
          builder: (context, AsyncSnapshot<List<PlayerModel?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(title: CircularProgressIndicator());
            }
            final outPlayer = snapshot.data![0];
            final inPlayer = snapshot.data![1];
            final team = isHome ? homeTeam : awayTeam;
            return ListTile(
              title: Text(
                '${outPlayer?.name ?? "Unknown"} → ${inPlayer?.name ?? "Unknown"}',
                style: Fontstyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                DateFormat('HH:mm').format(time),
                style: Fontstyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Text(
                  team?.teamPlayer?[inPlayerKey]?.toString() ?? 'N/A',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
