import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/player_select_card.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/tour_match_data.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/home/tour_match_home_bench.dart';
import 'package:get/get.dart';

class SelecTourtHomeTeamPage extends StatefulWidget {
  final String tournamentKey;
  final int roundIndex;
  final List<String> teamKeys;
  final int maxLinup;
  final DateTime date;
  final DateTime time;

  const SelecTourtHomeTeamPage({
    super.key,
    required this.tournamentKey,
    required this.roundIndex,
    required this.teamKeys,
    required this.maxLinup,
    required this.date,
    required this.time,
  });

  @override
  State<SelecTourtHomeTeamPage> createState() => _SelecTourtHomeTeamPageState();
}

class _SelecTourtHomeTeamPageState extends State<SelecTourtHomeTeamPage> {
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  String? homeTeamKey;
  final ValueNotifier<List<String>> homeLineupNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _playerRepo.init();
    print(
      'SelecTourtHomeTeamPage init: maxLinup=${widget.maxLinup}, teamKeys=${widget.teamKeys}',
    );
  }

  @override
  void dispose() {
    _playerRepo.close();
    homeLineupNotifier.dispose();
    super.dispose();
  }

  Future<List<Widget>> _buildPlayerCheckboxes(String teamKey) async {
    final team = await _teamService.getTeam(teamKey);
    final playerKeys = team?.teamPlayer?.keys.toList() ?? [];
    final players = await Future.wait(
      playerKeys.map((key) => _playerRepo.getPlayer(key)),
    );
    return players.asMap().entries.map((entry) {
      final player = entry.value;
      if (player == null) return Container();
      return ValueListenableBuilder<List<String>>(
        valueListenable: homeLineupNotifier,
        builder: (context, homeLineup, _) {
          final isSelected = homeLineup.contains(player.key);
          final isMaxReached = homeLineup.length >= widget.maxLinup;
          return PlayerSelectCard(
            name: player.name,
            isSelected: isSelected,
            enabled: !(isMaxReached && !isSelected),
            onChanged: (value) {
              if (value == true && isMaxReached) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Cannot select more than ${widget.maxLinup} players for the lineup',
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
              final newLineup = List<String>.from(homeLineup);
              if (value == true) {
                newLineup.add(player.key!);
              } else {
                newLineup.remove(player.key);
              }
              homeLineupNotifier.value = newLineup;
              print('Lineup updated: $newLineup');
            },
            subTitele:
                isMaxReached && !isSelected
                    ? const Text(
                      'Maximum lineup size reached',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )
                    : Text(player.position),
            imageData: player.imageData,
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(
      'Building SelecTourtHomeTeamPage: homeTeamKey=$homeTeamKey, maxLinup=${widget.maxLinup}',
    );
    return Scaffold(
      appBar: const CustomAppbar(title: "Select Home Team"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Home Team",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: const Text("Select home team"),
                value: homeTeamKey,
                isExpanded: true,
                items:
                    widget.teamKeys.map((key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: FutureBuilder<TeamModel?>(
                          future: _teamService.getTeam(key),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data?.name ?? "Loading...",
                              style: Fontstyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != homeTeamKey) {
                    setState(() {
                      homeTeamKey = value;
                      homeLineupNotifier.value = [];
                      print('Home team changed: $value, reset lineup');
                    });
                  }
                },
              ),
              if (homeTeamKey != null) ...[
                const SizedBox(height: 10),
                const Text(
                  "Home Lineup",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<Widget>>(
                  future: _buildPlayerCheckboxes(homeTeamKey!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return ValueListenableBuilder<List<String>>(
                      valueListenable: homeLineupNotifier,
                      builder: (context, homeLineup, _) {
                        print(
                          'Lineup selector build: homeLineup=$homeLineup, maxLinup=${widget.maxLinup}',
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...snapshot.data ?? [],
                            const SizedBox(height: 8),
                            Text(
                              "Selected: ${homeLineup.length}/${widget.maxLinup}",
                              style: TextStyle(
                                color:
                                    homeLineup.length != widget.maxLinup
                                        ? Colors.red
                                        : Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            if (homeLineup.length != widget.maxLinup)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please select exactly ${widget.maxLinup} players',
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
                valueListenable: homeLineupNotifier,
                builder: (context, homeLineup, _) {
                  final isValid =
                      homeTeamKey != null &&
                      homeLineup.length == widget.maxLinup;
                  print(
                    'Next button build: isValid=$isValid, homeLineup.length=${homeLineup.length}, maxLinup=${widget.maxLinup}',
                  );
                  return ArrowButton(
                    label: "Next",
                    // isDisabled: !isValid,
                    onClick: () {
                      if (!isValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              homeTeamKey == null
                                  ? 'Please select a home team'
                                  : 'Please select exactly ${widget.maxLinup} players for the lineup',
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
                      final matchData = TournamentMatchData(
                        tournamentKey: widget.tournamentKey,
                        roundIndex: widget.roundIndex,
                        teamKeys: widget.teamKeys,
                        homeTeamKey: homeTeamKey,
                        homeLineup: homeLineup,
                        maxLinup: widget.maxLinup,
                        date: widget.date,
                        time: widget.time,
                      );
                      print(
                        'Navigating to SelectTourHomeBenchPage: maxLinup=${matchData.maxLinup}, homeLineup=${matchData.homeLineup}',
                      );
                      Get.to(
                        () => SelectTourHomeBenchPage(
                          maxLinup: widget.maxLinup,
                          data: matchData,
                        ),
                      );
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
