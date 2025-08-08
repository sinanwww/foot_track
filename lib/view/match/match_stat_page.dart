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
        Get.offAll(() => NavController(index: 1));
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
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        title: Text(
          formatedDate ?? '',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
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
                    return DeleteBox(deleteOnClick: deleteMatch);
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
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    "Home Lineup",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildLineupList(match!.homeLineup ?? [], homeTeam),
                  const SizedBox(height: 20),
                  const Text(
                    "Away Lineup",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildLineupList(match!.awayLineup ?? [], awayTeam),
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
