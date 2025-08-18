import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:get/get.dart';

class AddMatchPage extends StatefulWidget {
  final String tournamentKey;
  final int roundIndex;
  final List<String> teamKeys;

  const AddMatchPage({
    super.key,
    required this.tournamentKey,
    required this.roundIndex,
    required this.teamKeys,
  });

  @override
  State<AddMatchPage> createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  final TournamentService _tournamentService = TournamentService();
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  String? homeTeamKey;
  String? awayTeamKey;
  final List<String> homeLineup = [];
  final List<String> awayLineup = [];

  Future<void> _createMatch() async {
    if (homeTeamKey == null ||
        awayTeamKey == null ||
        homeTeamKey == awayTeamKey) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select two different teams'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    try {
      await _tournamentService.createMatchInRound(
        tournamentKey: widget.tournamentKey,
        roundIndex: widget.roundIndex,
        homeTeamKey: homeTeamKey!,
        awayTeamKey: awayTeamKey!,
        homeLineup: homeLineup,
        awayLineup: awayLineup,
      );
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match created'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
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
  }

  Future<List<Widget>> _buildPlayerCheckboxes(
    String teamKey,
    List<String> selectedPlayers,
  ) async {
    final team = await _teamService.getTeam(teamKey);
    final playerKeys = team?.teamPlayer?.keys.toList() ?? [];
    final players = await Future.wait(
      playerKeys.map((key) => _playerRepo.getPlayer(key)),
    );
    return players.asMap().entries.map((entry) {
      final player = entry.value;
      if (player == null) return Container();
      return CheckboxListTile(
        title: Text(
          player.name,
          style: Fontstyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        value: selectedPlayers.contains(player.key),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              selectedPlayers.add(player.key!);
            } else {
              selectedPlayers.remove(player.key);
            }
          });
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Add Match"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Home Team",
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
                        return Text(snapshot.data?.name ?? "Loading...");
                      },
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                homeTeamKey = value;
                homeLineup.clear();
              });
            },
          ),
          if (homeTeamKey != null) ...[
            const SizedBox(height: 10),
            const Text(
              "Home Lineup",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Widget>>(
              future: _buildPlayerCheckboxes(homeTeamKey!, homeLineup),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Column(children: snapshot.data ?? []);
              },
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            "Away Team",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            hint: const Text("Select away team"),
            value: awayTeamKey,
            isExpanded: true,
            items:
                widget.teamKeys.map((key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: FutureBuilder<TeamModel?>(
                      future: _teamService.getTeam(key),
                      builder: (context, snapshot) {
                        return Text(snapshot.data?.name ?? "Loading...");
                      },
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                awayTeamKey = value;
                awayLineup.clear();
              });
            },
          ),
          if (awayTeamKey != null) ...[
            const SizedBox(height: 10),
            const Text(
              "Away Lineup",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Widget>>(
              future: _buildPlayerCheckboxes(awayTeamKey!, awayLineup),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Column(children: snapshot.data ?? []);
              },
            ),
          ],
          const SizedBox(height: 20),
          ArrowButton(label: "Create Match", onClick: _createMatch),
        ],
      ),
    );
  }
}
