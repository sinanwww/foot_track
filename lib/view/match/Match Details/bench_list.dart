import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view%20model/player.dart';

class BenchList extends StatelessWidget {
  final List<String> bench;
  final TeamModel? team;

  const BenchList({
    super.key,
    required this.bench,
    this.team,
  });

  @override
  Widget build(BuildContext context) {
    final playerRepo = PlayerRepo();
    return bench.isEmpty
        ? const Text("No bench players selected")
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bench.length,
            itemBuilder: (context, index) {
              final playerKey = bench[index];
              return FutureBuilder<PlayerModel?>(
                future: playerRepo.getPlayer(playerKey),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const ListTile(title: Text('Player not found'));
                  }
                  final player = snapshot.data!;
                  final jerseyNumber = team?.teamPlayer?[playerKey]?.toString() ?? 'N/A';
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue[400],
                            child: Text(
                              jerseyNumber,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.name,
                                  style: Fontstyle(
                                    color: AppTheam.primaryBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  player.position,
                                  style: Fontstyle(
                                    color: AppTheam.secondoryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            },
          );
  }
}