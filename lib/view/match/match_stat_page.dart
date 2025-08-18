import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/delete_box.dart';
import 'package:foot_track/view/match/Match%20Details/match_details_page.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view%20model/match_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class MatchStatPage extends StatefulWidget {
  final String matchKey;
  const MatchStatPage({super.key, required this.matchKey});

  @override
  State<MatchStatPage> createState() => _MatchStatPageState();
}

class _MatchStatPageState extends State<MatchStatPage> {
  MatchModel? match;
  TeamModel? homeTeam;
  TeamModel? awayTeam;
  bool isLoading = true;
  final MatchService _matchService = MatchService();
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  String? formatedDate;

  @override
  void initState() {
    super.initState();
    _loadMatch();
  }

  Future<void> _loadMatch() async {
    try {
      final loadedMatch = await _matchService.getMatch(widget.matchKey);
      if (loadedMatch != null) {
        final home = await _teamService.getTeam(loadedMatch.homeTeamKey ?? '');
        final away = await _teamService.getTeam(loadedMatch.awayTeamKey ?? '');
        if (mounted) {
          setState(() {
            match = loadedMatch;
            homeTeam = home;
            awayTeam = away;
            formatedDate =
                match!.date != null
                    ? DateFormat("dd-MM-yyyy").format(match!.date!)
                    : 'N/A';
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            formatedDate = 'N/A';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          formatedDate = 'N/A';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading match: $e'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> deleteMatch() async {
    try {
      await _matchService.deleteMatch(match!.key!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Match deleted'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Get.offAll(() => NavController(index: 1, matchTourTabIndex: 0));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting match: $e'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          formatedDate ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        actions: [
          IconButton(
            onPressed:
                match?.key != null
                    ? () =>
                        Get.to(() => MatchDetailsPage(matchKey: match!.key!))
                    : null,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteBox(
                      message: 'Are you sure you want to delete "This Match"?',
                      deleteOnClick: deleteMatch,
                    );
                  },
                ),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : match == null
              ? const Center(child: Text('Match not found'))
              : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        homeTeam?.name ?? 'Home',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        match!.homeScore.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Text(" - ", style: TextStyle(fontSize: 20)),
                      Text(
                        match!.awayScore.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        awayTeam?.name ?? 'Away',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.grey),
                  Text(
                    match!.description == ""
                        ? 'No Description'
                        : match!.description ?? "",
                  ),
                  const Divider(color: AppColors.grey),
                  const SizedBox(height: 20),
                  // Goal Scorers
                  const Text(
                    "Goal Scorers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildGoalScorersList(match!.goalScorers ?? []),
                  const SizedBox(height: 20),
                  // Home Lineup
                  const Text(
                    "Home Lineup",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildLineupList(match!.homeLineup ?? [], homeTeam),
                  const SizedBox(height: 20),
                  // Home Bench
                  const Text(
                    "Home Bench",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildLineupList(match!.homeBench ?? [], homeTeam),
                  const SizedBox(height: 20),
                  // Away Lineup
                  const Text(
                    "Away Lineup",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildLineupList(match!.awayLineup ?? [], awayTeam),
                  const SizedBox(height: 20),
                  // Away Bench
                  const Text(
                    "Away Bench",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildLineupList(match!.awayBench ?? [], awayTeam),
                  const SizedBox(height: 20),
                  // Substitutions
                  const Text(
                    "Substitutions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildSubstitutionsList(match!.substitutions ?? []),
                ],
              ),
    );
  }

  Widget _buildLineupList(List<String> lineup, TeamModel? team) {
    return lineup.isEmpty
        ? const Text("No players selected")
        : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lineup.length,
          itemBuilder: (context, index) {
            final playerKey = lineup[index];
            return FutureBuilder<PlayerModel?>(
              future: _playerRepo.getPlayer(playerKey),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(title: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const ListTile(title: Text('Player not found'));
                }
                final player = snapshot.data!;
                final jerseyNumber =
                    team?.teamPlayer?[playerKey]?.toString() ?? 'N/A';
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            jerseyNumber,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: Fontstyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              player.position,
                              style: Fontstyle(
                                color: AppColors.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.secondary),
                  ],
                );
              },
            );
          },
        );
  }

  Widget _buildGoalScorersList(List<Map<String, dynamic>> goalScorers) {
    if (goalScorers.isEmpty) {
      return const Text("No goals scored");
    }

    // Group goal scorers by team
    final homeGoals =
        goalScorers
            .where(
              (goal) =>
                  (match!.homeLineup ?? []).contains(goal['playerKey']) ||
                  (match!.substitutions ?? []).any(
                    (sub) =>
                        sub['outPlayerKey'] == goal['playerKey'] &&
                        sub['isHome'],
                  ),
            )
            .toList();
    final awayGoals =
        goalScorers
            .where(
              (goal) =>
                  (match!.awayLineup ?? []).contains(goal['playerKey']) ||
                  (match!.substitutions ?? []).any(
                    (sub) =>
                        sub['outPlayerKey'] == goal['playerKey'] &&
                        !sub['isHome'],
                  ),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Home Team Goals
        if (homeGoals.isNotEmpty) ...[
          Text(
            "${homeTeam?.name ?? 'Home'} Goals",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          ...homeGoals
              .map((goal) => _buildGoalScorerItem(goal, homeTeam))
              .toList(),
          const SizedBox(height: 10),
        ],
        // Away Team Goals
        if (awayGoals.isNotEmpty) ...[
          Text(
            "${awayTeam?.name ?? 'Away'} Goals",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          ...awayGoals
              .map((goal) => _buildGoalScorerItem(goal, awayTeam))
              .toList(),
        ],
      ],
    );
  }

  Widget _buildGoalScorerItem(Map<String, dynamic> goal, TeamModel? team) {
    final playerKey = goal['playerKey'] as String;
    final time = goal['time'] as DateTime?;
    return FutureBuilder<PlayerModel?>(
      future: _playerRepo.getPlayer(playerKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(title: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const ListTile(title: Text('Player not found'));
        }
        final player = snapshot.data!;
        final jerseyNumber = team?.teamPlayer?[playerKey]?.toString() ?? 'N/A';
        final timeString =
            time != null ? DateFormat('mm:ss').format(time) : 'N/A';
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    jerseyNumber,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Goal at $timeString',
                      style: Fontstyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: AppColors.secondary),
          ],
        );
      },
    );
  }

  Widget _buildSubstitutionsList(List<Map<String, dynamic>> substitutions) {
    if (substitutions.isEmpty) {
      return const Text("No substitutions made");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: substitutions.length,
      itemBuilder: (context, index) {
        final sub = substitutions[index];
        final outPlayerKey = sub['outPlayerKey'] as String;
        final inPlayerKey = sub['inPlayerKey'] as String;
        final time = sub['time'] as DateTime?;
        final isHome = sub['isHome'] as bool;
        final timeString =
            time != null ? DateFormat('mm:ss').format(time) : 'N/A';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHome
                  ? "${homeTeam?.name ?? 'Home'} Substitution"
                  : "${awayTeam?.name ?? 'Away'} Substitution",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder<PlayerModel?>(
                    future: _playerRepo.getPlayer(outPlayerKey),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const ListTile(title: Text('Player not found'));
                      }
                      final player = snapshot.data!;
                      final jerseyNumber =
                          (isHome
                                  ? homeTeam?.teamPlayer
                                  : awayTeam?.teamPlayer)?[outPlayerKey]
                              ?.toString() ??
                          'N/A';
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              jerseyNumber,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: Fontstyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Out at $timeString',
                                style: Fontstyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.arrow_forward, color: AppColors.secondary),
                const SizedBox(width: 20),
                Expanded(
                  child: FutureBuilder<PlayerModel?>(
                    future: _playerRepo.getPlayer(inPlayerKey),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const ListTile(title: Text('Player not found'));
                      }
                      final player = snapshot.data!;
                      final jerseyNumber =
                          (isHome
                                  ? homeTeam?.teamPlayer
                                  : awayTeam?.teamPlayer)?[inPlayerKey]
                              ?.toString() ??
                          'N/A';
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              jerseyNumber,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: Fontstyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'In at $timeString',
                                style: Fontstyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.secondary),
          ],
        );
      },
    );
  }
}
