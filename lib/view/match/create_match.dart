import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/view%20model/match_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/view/match/Match%20Details/match_details_page.dart';
import 'package:get/get.dart';

class CreateMatchPage extends StatefulWidget {
  final DateTime? date;
  final DateTime? startTime;
  final int maxLinup;

  const CreateMatchPage({
    super.key,
    this.date,
    this.startTime,
    required this.maxLinup,
  });

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  TeamModel? homeTeam;
  TeamModel? awayTeam;
  List<String> homeLineup = [];
  List<String> awayLineup = [];
  List<String> homeBench = [];
  List<String> awayBench = [];
  final TeamService _teamService = TeamService();
  final MatchService _matchService = MatchService();
  final PlayerRepo _playerRepo = PlayerRepo();
  int? maxLinup;

  @override
  void initState() {
    maxLinup = widget.maxLinup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Create New Match"),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          const Text(
            "Select Home Team",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          _buildTeamSelector(isHome: true),
          const SizedBox(height: 20),
          const Text(
            "Select Away Team",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          _buildTeamSelector(isHome: false),
          const SizedBox(height: 20),
          if (homeTeam != null)
            _buildLineupSelector(team: homeTeam!, isHome: true),
          if (homeTeam != null && homeLineup.length == maxLinup)
            _buildBenchSelector(team: homeTeam!, isHome: true),
          if (awayTeam != null)
            _buildLineupSelector(team: awayTeam!, isHome: false),
          if (awayTeam != null && awayLineup.length == maxLinup)
            _buildBenchSelector(team: awayTeam!, isHome: false),
          const SizedBox(height: 20),
          ArrowButton(
            label: "Create Match",
            onClick: () async {
              if (homeTeam == null || awayTeam == null) {
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
              if (homeTeam!.key == awayTeam!.key) {
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
              if (homeLineup.length != maxLinup || awayLineup.length != maxLinup) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Each team must have exactly ${maxLinup.toString()} players in the lineup',
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }
              final overlappingPlayers = homeLineup.toSet().intersection(awayLineup.toSet());
              if (overlappingPlayers.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Players cannot be in both home and away lineups'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              final overlappingHome = homeLineup.toSet().intersection(homeBench.toSet());
              final overlappingAway = awayLineup.toSet().intersection(awayBench.toSet());
              if (overlappingHome.isNotEmpty || overlappingAway.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Players cannot be in both lineup and bench for the same team'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              try {
                final matchKey = await _matchService.createMatch(
                  homeTeamKey: homeTeam!.key!,
                  awayTeamKey: awayTeam!.key!,
                  homeLineup: homeLineup,
                  awayLineup: awayLineup,
                  date: widget.date,
                  startTime: widget.startTime,
                  homeBench: homeBench,
                  awayBench: awayBench,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Match created successfully'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                Get.offAll(() => MatchDetailsPage(matchKey: matchKey));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error creating match: $e'),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
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
        final availableTeams = teams.where((team) {
          if (isHome && awayTeam != null) {
            return team.key != awayTeam!.key;
          } else if (!isHome && homeTeam != null) {
            return team.key != homeTeam!.key;
          }
          return true;
        }).toList();
        return DropdownButton<TeamModel>(
          isExpanded: true,
          hint: Text(isHome ? 'Select Home Team' : 'Select Away Team'),
          value: isHome ? homeTeam : awayTeam,
          items: availableTeams.map((team) {
            return DropdownMenuItem<TeamModel>(
              value: team,
              child: Text(team.name ?? 'Unnamed Team'),
            );
          }).toList(),
          onChanged: (team) {
            setState(() {
              if (isHome) {
                homeTeam = team;
                homeLineup = [];
                homeBench = [];
              } else {
                awayTeam = team;
                awayLineup = [];
                awayBench = [];
              }
            });
          },
        );
      },
    );
  }

  Widget _buildLineupSelector({required TeamModel team, required bool isHome}) {
    final otherLineup = isHome ? awayLineup : homeLineup;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Lineup for ${team.name ?? 'Team'}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<PlayerModel>>(
          future: Future.wait(
            (team.teamPlayer?.keys ?? []).map(
              (playerKey) => _playerRepo.getPlayer(playerKey),
            ),
          ).then((players) => players.whereType<PlayerModel>().toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No players available');
            }
            final players = snapshot.data!;
            final currentLineup = isHome ? homeLineup : awayLineup;
            return Wrap(
              spacing: 8,
              children: players.map((player) {
                final isSelected = currentLineup.contains(player.key);
                final isInOtherLineup = otherLineup.contains(player.key);
                return ChoiceChip(
                  label: Text(player.name),
                  selected: isSelected,
                  disabledColor: isInOtherLineup ? Colors.grey : null,
                  onSelected: isInOtherLineup
                      ? null
                      : (selected) {
                          setState(() {
                            if (selected && currentLineup.length < maxLinup!) {
                              currentLineup.add(player.key!);
                            } else if (!selected) {
                              currentLineup.remove(player.key!);
                            }
                          });
                        },
                );
              }).toList(),
            );
          },
        ),
        Text(
          "Selected: ${isHome ? homeLineup.length : awayLineup.length}/${maxLinup.toString()}",
        ),
      ],
    );
  }

  Widget _buildBenchSelector({required TeamModel team, required bool isHome}) {
    final currentLineup = isHome ? homeLineup : awayLineup;
    final currentBench = isHome ? homeBench : awayBench;
    final otherLineup = isHome ? awayLineup : homeLineup;
    final otherBench = isHome ? awayBench : homeBench;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Select Bench for ${team.name ?? 'Team'}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<PlayerModel>>(
          future: Future.wait(
            (team.teamPlayer?.keys ?? []).map(
              (playerKey) => _playerRepo.getPlayer(playerKey),
            ),
          ).then((players) => players.whereType<PlayerModel>().toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No players available for bench');
            }
            final players = snapshot.data!;
            return Wrap(
              spacing: 8,
              children: players.map((player) {
                final isSelected = currentBench.contains(player.key);
                final isInLineup = currentLineup.contains(player.key);
                final isInOtherLineup = otherLineup.contains(player.key);
                final isInOtherBench = otherBench.contains(player.key);
                return ChoiceChip(
                  label: Text(player.name),
                  selected: isSelected,
                  disabledColor: (isInLineup || isInOtherLineup || isInOtherBench) ? Colors.grey : null,
                  onSelected: (isInLineup || isInOtherLineup || isInOtherBench)
                      ? null
                      : (selected) {
                          setState(() {
                            if (selected) {
                              currentBench.add(player.key!);
                            } else {
                              currentBench.remove(player.key!);
                            }
                          });
                        },
                );
              }).toList(),
            );
          },
        ),
        Text(
          "Bench Selected: ${currentBench.length}",
        ),
      ],
    );
  }
}