import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/player_select_card.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/away/select_tour_match_away.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/tour_match_data.dart';
import 'package:get/get.dart';

class SelectTourHomeBenchPage extends StatefulWidget {
  final TournamentMatchData data;
  final int maxLinup;
  const SelectTourHomeBenchPage({
    super.key,
    required this.data,
    required this.maxLinup,
  });

  @override
  State<SelectTourHomeBenchPage> createState() =>
      _SelectTourHomeBenchPageState();
}

class _SelectTourHomeBenchPageState extends State<SelectTourHomeBenchPage> {
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  final ValueNotifier<List<String>> homeBenchNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _playerRepo.init();
    homeBenchNotifier.value = List.from(widget.data.homeBench);
  }

  @override
  void dispose() {
    _playerRepo.close();
    homeBenchNotifier.dispose();
    super.dispose();
  }

  Future<List<Widget>> _buildPlayerCheckboxes(String teamKey) async {
    final team = await _teamService.getTeam(teamKey);
    final playerKeys = team?.teamPlayer?.keys.toList() ?? [];
    // Filter out players who are in the homeLineup
    final availablePlayerKeys =
        playerKeys
            .where((key) => !widget.data.homeLineup.contains(key))
            .toList();
    final players = await Future.wait(
      availablePlayerKeys.map((key) => _playerRepo.getPlayer(key)),
    );
    return players.asMap().entries.map((entry) {
      final player = entry.value;
      if (player == null) return Container();
      return ValueListenableBuilder<List<String>>(
        valueListenable: homeBenchNotifier,
        builder: (context, homeBench, _) {
          final isSelected = homeBench.contains(player.key);
          return PlayerSelectCard(
            imageData: player.imageData,
            name: player.name,
            isSelected: isSelected,
            enabled: true, 
            subTitele: Text(
              player.position,
              style: Fontstyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            onChanged: (value) {
              final newBench = List<String>.from(homeBench);
              if (value == true) {
                newBench.add(player.key!);
              } else {
                newBench.remove(player.key);
              }
              homeBenchNotifier.value = newBench;
            },
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Select Home Bench"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<TeamModel?>(
                future: _teamService.getTeam(widget.data.homeTeamKey!),
                builder: (context, snapshot) {
                  return Text(
                    "Select Bench for ${snapshot.data?.name ?? 'Team'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Widget>>(
                future: _buildPlayerCheckboxes(widget.data.homeTeamKey!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ValueListenableBuilder<List<String>>(
                    valueListenable: homeBenchNotifier,
                    builder: (context, homeBench, _) {
                      return Column(
                        children: [
                          ...snapshot.data ?? [],
                          Text("Bench Selected: ${homeBench.length}"),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ArrowButton(
                label: "Next",
                onClick: () {
                  Get.to(
                    () => SelectTourAwayTeamPage(
                      maxLinup: widget.maxLinup,
                      data: widget.data.copyWith(
                        homeBench: homeBenchNotifier.value,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
