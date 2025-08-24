import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/player_select_card.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/tour_match_data.dart';
import 'package:foot_track/view/tournament/tournament%20manage/tour_manage_page.dart';
import 'package:get/get.dart';

class SelectTourAwayBenchPage extends StatefulWidget {
  final TournamentMatchData data;

  const SelectTourAwayBenchPage({super.key, required this.data});

  @override
  State<SelectTourAwayBenchPage> createState() =>
      _SelectTourAwayBenchPageState();
}

class _SelectTourAwayBenchPageState extends State<SelectTourAwayBenchPage> {
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  final TournamentService _tournamentService = TournamentService();
  final ValueNotifier<List<String>> awayBenchNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _playerRepo.init();
    awayBenchNotifier.value = List.from(widget.data.awayBench);
  }

  @override
  void dispose() {
    _playerRepo.close();
    awayBenchNotifier.dispose();
    super.dispose();
  }

  Future<List<Widget>> _buildPlayerCheckboxes(String teamKey) async {
    final team = await _teamService.getTeam(teamKey);
    final playerKeys = team?.teamPlayer?.keys.toList() ?? [];
    // Filter out players who are in awayLineup, homeLineup, or homeBench
    final availablePlayerKeys =
        playerKeys
            .where(
              (key) =>
                  !widget.data.awayLineup.contains(key) &&
                  !widget.data.homeLineup.contains(key) &&
                  !widget.data.homeBench.contains(key),
            )
            .toList();
    final players = await Future.wait(
      availablePlayerKeys.map((key) => _playerRepo.getPlayer(key)),
    );
    return players.asMap().entries.map((entry) {
      final player = entry.value;
      if (player == null) return Container();
      return ValueListenableBuilder<List<String>>(
        valueListenable: awayBenchNotifier,
        builder: (context, awayBench, _) {
          final isSelected = awayBench.contains(player.key);
          return PlayerSelectCard(
            imageData: player.imageData,
            name: player.name,
            isSelected: isSelected,
            enabled: true, // All players here are available
            subTitele: Text(
              player.position,
              style: Fontstyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            onChanged: (value) {
              final newBench = List<String>.from(awayBench);
              if (value == true) {
                newBench.add(player.key!);
              } else {
                newBench.remove(player.key);
              }
              awayBenchNotifier.value = newBench;
            },
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Select Away Bench"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<TeamModel?>(
                future: _teamService.getTeam(widget.data.awayTeamKey!),
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
                future: _buildPlayerCheckboxes(widget.data.awayTeamKey!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ValueListenableBuilder<List<String>>(
                    valueListenable: awayBenchNotifier,
                    builder: (context, awayBench, _) {
                      return Column(
                        children: [
                          ...snapshot.data ?? [],
                          Text("Bench Selected: ${awayBench.length}"),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ArrowButton(
                label: "Create Match",
                onClick: () async {
                  if (widget.data.homeTeamKey == null ||
                      widget.data.awayTeamKey == null ||
                      widget.data.homeTeamKey == widget.data.awayTeamKey) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select two different teams'),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 200,
                          left: 20,
                          right: 20,
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  final overlappingPlayers = widget.data.homeLineup
                      .toSet()
                      .intersection(widget.data.awayLineup.toSet());
                  final overlappingHome = widget.data.homeLineup
                      .toSet()
                      .intersection(widget.data.homeBench.toSet());
                  final overlappingAway = widget.data.awayLineup
                      .toSet()
                      .intersection(awayBenchNotifier.value.toSet());
                  if (overlappingPlayers.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Players cannot be in both home and away lineups',
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 200,
                          left: 20,
                          right: 20,
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  if (overlappingHome.isNotEmpty ||
                      overlappingAway.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Players cannot be in both lineup and bench for the same team',
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 200,
                          left: 20,
                          right: 20,
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  try {
                    await _tournamentService.createMatchInRound(
                      tournamentKey: widget.data.tournamentKey,
                      roundIndex: widget.data.roundIndex,
                      homeTeamKey: widget.data.homeTeamKey!,
                      awayTeamKey: widget.data.awayTeamKey!,
                      homeLineup: widget.data.homeLineup,
                      awayLineup: widget.data.awayLineup,
                      homeBench: widget.data.homeBench,
                      awayBench: awayBenchNotifier.value,
                      date: widget.data.date,
                      startTime: widget.data.time,
                    );
                    Get.offAll(
                      TourManagePage(tournamentKey: widget.data.tournamentKey),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Match created'),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 200,
                          left: 20,
                          right: 20,
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error creating match: $e'),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          bottom: 200,
                          left: 20,
                          right: 20,
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
