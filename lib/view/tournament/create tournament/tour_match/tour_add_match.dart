import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/match/Match%20Details/match_details_page.dart';
import 'package:get/get.dart';

class AddTournamentMatchPage extends StatefulWidget {
  final String tournamentKey;
  final int roundIndex;
  final int maxLineup;
  final DateTime? date;
  final DateTime? startTime;

  const AddTournamentMatchPage({
    super.key,
    required this.tournamentKey,
    required this.roundIndex,
    required this.maxLineup,
    this.date,
    this.startTime,
  });

  @override
  State<AddTournamentMatchPage> createState() => _AddTournamentMatchPageState();
}

class _AddTournamentMatchPageState extends State<AddTournamentMatchPage> {
  final ValueNotifier<TeamModel?> homeTeam = ValueNotifier<TeamModel?>(null);
  final ValueNotifier<TeamModel?> awayTeam = ValueNotifier<TeamModel?>(null);
  final ValueNotifier<List<String>> homeLineup = ValueNotifier<List<String>>(
    [],
  );
  final ValueNotifier<List<String>> awayLineup = ValueNotifier<List<String>>(
    [],
  );
  final ValueNotifier<List<String>> homeBench = ValueNotifier<List<String>>([]);
  final ValueNotifier<List<String>> awayBench = ValueNotifier<List<String>>([]);
  final TeamService _teamService = TeamService();
  final TournamentService _tournamentService = TournamentService();
  final PlayerRepo _playerRepo = PlayerRepo();
  late int maxLineup;

  @override
  void initState() {
    maxLineup = widget.maxLineup;
    super.initState();
  }

  @override
  void dispose() {
    homeTeam.dispose();
    awayTeam.dispose();
    homeLineup.dispose();
    awayLineup.dispose();
    homeBench.dispose();
    awayBench.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Add Match"),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Text(
            "Select Team 1",
            style: Fontstyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          _buildTeamSelector(isHome: true),
          const SizedBox(height: 20),
          Text(
            "Select Team 2",
            style: Fontstyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          _buildTeamSelector(isHome: false),
          const SizedBox(height: 20),
          ValueListenableBuilder<TeamModel?>(
            valueListenable: homeTeam,
            builder: (context, homeTeamValue, child) {
              return homeTeamValue != null
                  ? _buildLineupSelector(team: homeTeamValue, isHome: true)
                  : const SizedBox.shrink();
            },
          ),
          ValueListenableBuilder<List<String>>(
            valueListenable: homeLineup,
            builder: (context, homeLineupValue, child) {
              return ValueListenableBuilder<TeamModel?>(
                valueListenable: homeTeam,
                builder: (context, homeTeamValue, child) {
                  return homeTeamValue != null &&
                          homeLineupValue.length == maxLineup
                      ? _buildBenchSelector(team: homeTeamValue, isHome: true)
                      : const SizedBox.shrink();
                },
              );
            },
          ),
          ValueListenableBuilder<TeamModel?>(
            valueListenable: awayTeam,
            builder: (context, awayTeamValue, child) {
              return awayTeamValue != null
                  ? _buildLineupSelector(team: awayTeamValue, isHome: false)
                  : const SizedBox.shrink();
            },
          ),
          ValueListenableBuilder<List<String>>(
            valueListenable: awayLineup,
            builder: (context, awayLineupValue, child) {
              return ValueListenableBuilder<TeamModel?>(
                valueListenable: awayTeam,
                builder: (context, awayTeamValue, child) {
                  return awayTeamValue != null &&
                          awayLineupValue.length == maxLineup
                      ? _buildBenchSelector(team: awayTeamValue, isHome: false)
                      : const SizedBox.shrink();
                },
              );
            },
          ),
          const SizedBox(height: 20),
          ArrowButton(
            label: "Create Match",
            onClick: () async {
              if (homeTeam.value == null || awayTeam.value == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select both home and away teams'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              if (homeTeam.value!.key == awayTeam.value!.key) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Home and away teams must be different'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              if (homeLineup.value.length != maxLineup ||
                  awayLineup.value.length != maxLineup) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Each team must have exactly $maxLineup players in the lineup',
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
              final overlappingPlayers = homeLineup.value.toSet().intersection(
                awayLineup.value.toSet(),
              );
              if (overlappingPlayers.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Players cannot be in both home and away lineups',
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              final overlappingHome = homeLineup.value.toSet().intersection(
                homeBench.value.toSet(),
              );
              final overlappingAway = awayLineup.value.toSet().intersection(
                awayBench.value.toSet(),
              );
              if (overlappingHome.isNotEmpty || overlappingAway.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Players cannot be in both lineup and bench for the same team',
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              try {
                final matchKey = await _tournamentService.createMatchInRound(
                  tournamentKey: widget.tournamentKey,
                  roundIndex: widget.roundIndex,
                  homeTeamKey: homeTeam.value!.key!,
                  awayTeamKey: awayTeam.value!.key!,
                  homeLineup: homeLineup.value,
                  awayLineup: awayLineup.value,
                  homeBench: homeBench.value,
                  awayBench: awayBench.value,
                  date: widget.date,
                  startTime: widget.startTime,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Match added to tournament'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                Get.off(() => MatchDetailsPage(matchKey: matchKey));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error adding match: $e'),
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
    );
  }

  Widget _buildTeamSelector({required bool isHome}) {
    return FutureBuilder<List<TeamModel>>(
      future: _teamService.getAllTeams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No teams available');
        }
        final teams = snapshot.data!;
        final availableTeams =
            teams.where((team) {
              if (isHome && awayTeam.value != null) {
                return team.key != awayTeam.value!.key;
              } else if (!isHome && homeTeam.value != null) {
                return team.key != homeTeam.value!.key;
              }
              return true;
            }).toList();
        return ValueListenableBuilder<TeamModel?>(
          valueListenable: isHome ? homeTeam : awayTeam,
          builder: (context, selectedTeam, child) {
            return DropdownButton<TeamModel>(
              isExpanded: true,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              hint: Text(isHome ? 'Select Home Team' : 'Select Away Team'),
              value: selectedTeam,
              items:
                  availableTeams.map((team) {
                    return DropdownMenuItem<TeamModel>(
                      value: team,
                      child: Text(team.name ?? 'Unnamed Team'),
                    );
                  }).toList(),
              onChanged: (team) {
                if (isHome) {
                  homeTeam.value = team;
                  homeLineup.value = [];
                  homeBench.value = [];
                } else {
                  awayTeam.value = team;
                  awayLineup.value = [];
                  awayBench.value = [];
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLineupSelector({required TeamModel team, required bool isHome}) {
    final otherLineup = isHome ? awayLineup : homeLineup;
    return ValueListenableBuilder<List<String>>(
      valueListenable: isHome ? homeLineup : awayLineup,
      builder: (context, currentLineup, child) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: otherLineup,
          builder: (context, otherLineupValue, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Lineup for ${team.name ?? 'Team'}",
                  style: Fontstyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<PlayerModel>>(
                  future: Future.wait(
                    (team.teamPlayer?.keys ?? []).map(
                      (playerKey) => _playerRepo.getPlayer(playerKey),
                    ),
                  ).then(
                    (players) => players.whereType<PlayerModel>().toList(),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Text('No players available');
                    }
                    final players = snapshot.data!;
                    return Wrap(
                      spacing: 8,
                      children:
                          players.map((player) {
                            final isSelected = currentLineup.contains(
                              player.key,
                            );
                            final isInOtherLineup = otherLineupValue.contains(
                              player.key,
                            );
                            return ChoiceChip(
                              selectedColor: AppColors.primary,
                              label: Text(
                                player.name,
                                style: Fontstyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                ),
                              ),
                              selected: isSelected,
                              disabledColor:
                                  isInOtherLineup ? Colors.grey : null,
                              onSelected:
                                  isInOtherLineup
                                      ? null
                                      : (selected) {
                                        final updatedLineup = List<String>.from(
                                          currentLineup,
                                        );
                                        if (selected &&
                                            updatedLineup.length < maxLineup) {
                                          updatedLineup.add(player.key!);
                                        } else if (!selected) {
                                          updatedLineup.remove(player.key!);
                                        }
                                        if (isHome) {
                                          homeLineup.value = updatedLineup;
                                        } else {
                                          awayLineup.value = updatedLineup;
                                        }
                                      },
                            );
                          }).toList(),
                    );
                  },
                ),
                Text("Selected: ${currentLineup.length}/$maxLineup"),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBenchSelector({required TeamModel team, required bool isHome}) {
    final currentLineup = isHome ? homeLineup : awayLineup;
    final currentBench = isHome ? homeBench : awayBench;
    final otherLineup = isHome ? awayLineup : homeLineup;
    final otherBench = isHome ? awayBench : homeBench;
    return ValueListenableBuilder<List<String>>(
      valueListenable: currentLineup,
      builder: (context, currentLineupValue, child) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: currentBench,
          builder: (context, currentBenchValue, child) {
            return ValueListenableBuilder<List<String>>(
              valueListenable: otherLineup,
              builder: (context, otherLineupValue, child) {
                return ValueListenableBuilder<List<String>>(
                  valueListenable: otherBench,
                  builder: (context, otherBenchValue, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Select Bench for ${team.name ?? 'Team'}",
                          style: Fontstyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<List<PlayerModel>>(
                          future: Future.wait(
                            (team.teamPlayer?.keys ?? []).map(
                              (playerKey) => _playerRepo.getPlayer(playerKey),
                            ),
                          ).then(
                            (players) =>
                                players.whereType<PlayerModel>().toList(),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text(
                                'No players available for bench',
                              );
                            }
                            final players = snapshot.data!;
                            return Wrap(
                              spacing: 8,
                              children:
                                  players.map((player) {
                                    final isSelected = currentBenchValue
                                        .contains(player.key);
                                    final isInLineup = currentLineupValue
                                        .contains(player.key);
                                    final isInOtherLineup = otherLineupValue
                                        .contains(player.key);
                                    final isInOtherBench = otherBenchValue
                                        .contains(player.key);
                                    return ChoiceChip(
                                      selectedColor: AppColors.primary,
                                      label: Text(
                                        player.name,
                                        style: Fontstyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                        ),
                                      ),
                                      selected: isSelected,
                                      disabledColor:
                                          isInOtherLineup ? Colors.grey : null,
                                      onSelected:
                                          (isInLineup ||
                                                  isInOtherLineup ||
                                                  isInOtherBench)
                                              ? null
                                              : (selected) {
                                                final updatedBench =
                                                    List<String>.from(
                                                      currentBenchValue,
                                                    );
                                                if (selected) {
                                                  updatedBench.add(player.key!);
                                                } else {
                                                  updatedBench.remove(
                                                    player.key!,
                                                  );
                                                }
                                                if (isHome) {
                                                  homeBench.value =
                                                      updatedBench;
                                                } else {
                                                  awayBench.value =
                                                      updatedBench;
                                                }
                                              },
                                    );
                                  }).toList(),
                            );
                          },
                        ),
                        Text("Bench Selected: ${currentBenchValue.length}"),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
