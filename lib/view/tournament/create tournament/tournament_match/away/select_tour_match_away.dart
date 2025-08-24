import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/player_select_card.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/away/select_tour_away_bench.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/tour_match_data.dart';
import 'package:get/get.dart';

class SelectTourAwayTeamPage extends StatefulWidget {
  final TournamentMatchData data;
  final int maxLinup;

  const SelectTourAwayTeamPage({
    super.key,
    required this.data,
    required this.maxLinup,
  });

  @override
  State<SelectTourAwayTeamPage> createState() => _SelectTourAwayTeamPageState();
}

class _SelectTourAwayTeamPageState extends State<SelectTourAwayTeamPage> {
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  String? awayTeamKey;
  final ValueNotifier<List<String>> awayLineupNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _playerRepo.init();
    awayLineupNotifier.value = List.from(widget.data.awayLineup);
    print(
      'SelectTourAwayTeamPage init: maxLinup=${widget.data.maxLinup}, awayLineup=${widget.data.awayLineup}, homeTeamKey=${widget.data.homeTeamKey}',
    );
  }

  @override
  void dispose() {
    _playerRepo.close();
    awayLineupNotifier.dispose();
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
        valueListenable: awayLineupNotifier,
        builder: (context, awayLineup, _) {
          final isInOtherLineup = widget.data.homeLineup.contains(player.key);
          final maxLinup = widget.maxLinup; // Fallback to 11 if null
          final isMaxReached = awayLineup.length >= maxLinup;
          return PlayerSelectCard(
            imageData: player.imageData,
            name: player.name,
            isSelected: awayLineup.contains(player.key),
            enabled:
                !isInOtherLineup &&
                !(isMaxReached && !awayLineup.contains(player.key)),
            subTitele:
                isInOtherLineup
                    ? const Text(
                      'Player already in home lineup',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                    : isMaxReached && !awayLineup.contains(player.key)
                    ? const Text(
                      'Maximum lineup size reached',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                    : Text(
                      player.position,
                      style: Fontstyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
            onChanged:
                isInOtherLineup ||
                        (isMaxReached && !awayLineup.contains(player.key))
                    ? null
                    : (value) {
                      if (value == true && isMaxReached) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Cannot select more than $maxLinup players for the lineup',
                            ),
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
                        return;
                      }
                      final newLineup = List<String>.from(awayLineup);
                      if (value == true) {
                        newLineup.add(player.key!);
                      } else {
                        newLineup.remove(player.key);
                      }
                      awayLineupNotifier.value = newLineup;
                      print('Lineup updated: $newLineup');
                    },
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(
      'Building SelectTourAwayTeamPage: awayTeamKey=$awayTeamKey, maxLinup=${widget.data.maxLinup}',
    );
    return Scaffold(
      appBar: const CustomAppbar(title: "Select Away Team"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Away Team",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: const Text("Select away team"),
                value: awayTeamKey,
                isExpanded: true,
                items:
                    widget.data.teamKeys
                        .where((key) => key != widget.data.homeTeamKey)
                        .map((key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: FutureBuilder<TeamModel?>(
                              future: _teamService.getTeam(key),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data?.name ?? "Loading...",
                                  style: Fontstyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                );
                              },
                            ),
                          );
                        })
                        .toList(),
                onChanged: (value) {
                  if (value != awayTeamKey) {
                    setState(() {
                      awayTeamKey = value;
                      awayLineupNotifier.value = [];
                      print('Away team changed: $value, reset lineup');
                    });
                  }
                },
              ),
              if (awayTeamKey != null) ...[
                const SizedBox(height: 10),
                const Text(
                  "Away Lineup",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<Widget>>(
                  future: _buildPlayerCheckboxes(awayTeamKey!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return ValueListenableBuilder<List<String>>(
                      valueListenable: awayLineupNotifier,
                      builder: (context, awayLineup, _) {
                        final maxLinup =
                            widget.maxLinup; // Fallback to 11 if null
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...snapshot.data ?? [],
                            const SizedBox(height: 8),
                            Text(
                              "Selected: ${awayLineup.length}/$maxLinup",
                              style: TextStyle(
                                color:
                                    awayLineup.length != maxLinup
                                        ? Colors.red
                                        : Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            if (awayLineup.length != maxLinup)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please select exactly $maxLinup players',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
              ValueListenableBuilder<List<String>>(
                valueListenable: awayLineupNotifier,
                builder: (context, awayLineup, _) {
                  final maxLinup =
                      widget.maxLinup; // Fallback to 11 if null
                  final isValid =
                      awayTeamKey != null &&
                      awayLineup.length == maxLinup;
                  print(
                    'Next button build: isValid=$isValid, awayLineup.length=${awayLineup.length}, maxLinup=$maxLinup',
                  );
                  return ArrowButton(
                    label: "Next",
                    onClick: () {
                      if (!isValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              awayTeamKey == null
                                  ? 'Please select an away team'
                                  : widget.data.maxLinup == null
                                  ? 'Error: Maximum lineup size not set'
                                  : 'Please select exactly $maxLinup players for the lineup',
                            ),
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
                        return;
                      }
                      final matchData = widget.data.copyWith(
                        awayTeamKey: awayTeamKey,
                        awayLineup: awayLineup,
                      );
                      print(
                        'Navigating to SelectTourAwayBenchPage: maxLinup=$maxLinup, awayLineup=$awayLineup',
                      );
                      Get.to(() => SelectTourAwayBenchPage(data: matchData));
                    },
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
