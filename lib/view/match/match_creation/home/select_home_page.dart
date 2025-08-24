import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/player_select_card.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/match/match_creation/home/home_benh_page.dart';
import 'package:foot_track/view/match/match_creation/match_creation_data.dart';
import 'package:get/get.dart';

class SelectHomeTeamPage extends StatefulWidget {
  final DateTime? date;
  final DateTime? startTime;
  final int maxLinup;

  const SelectHomeTeamPage({
    super.key,
    this.date,
    this.startTime,
    required this.maxLinup,
  });

  @override
  State<SelectHomeTeamPage> createState() => _SelectHomeTeamPageState();
}

class _SelectHomeTeamPageState extends State<SelectHomeTeamPage> {
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  TeamModel? homeTeam;
  final ValueNotifier<List<String>> homeLineupNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _playerRepo.init();
  }

  @override
  void dispose() {
    _playerRepo.close();
    homeLineupNotifier.dispose();
    super.dispose();
  }

  Widget _buildTeamSelector() {
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
        return DropdownButton<TeamModel>(
          isExpanded: true,
          hint: const Text('Select Home Team'),
          value: homeTeam,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          items:
              teams.map((team) {
                return DropdownMenuItem<TeamModel>(
                  value: team,
                  child: Text(team.name ?? 'Unnamed Team'),
                );
              }).toList(),
          onChanged: (team) {
            if (team != homeTeam) {
              setState(() {
                homeTeam = team;
                homeLineupNotifier.value =
                    []; // Reset lineup only when team changes
              });
            }
          },
        );
      },
    );
  }

  Widget _buildLineupSelector(TeamModel team) {
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
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Text('No players available');
            }
            final players = snapshot.data!;
            return ValueListenableBuilder<List<String>>(
              valueListenable: homeLineupNotifier,
              builder: (context, homeLineup, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children:
                          players.map((player) {
                            final isSelected = homeLineup.contains(player.key);
                            final isMaxReached =
                                homeLineup.length >= widget.maxLinup;
                            return PlayerSelectCard(
                              name: player.name,
                              isSelected: isSelected,
                              enabled: !isMaxReached || isSelected,
                              subTitele:
                                  isMaxReached && !isSelected
                                      ? const Text(
                                        'Maximum lineup size reached',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      )
                                      : Text(
                                        player.position,
                                        style: Fontstyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
                                        ),
                                      ),
                              imageData: player.imageData,
                              onChanged: (value) {
                                final newLineup = List<String>.from(homeLineup);
                                if (value == true &&
                                    newLineup.length < widget.maxLinup) {
                                  newLineup.add(player.key!);
                                } else if (value == false) {
                                  newLineup.remove(player.key);
                                }
                                homeLineupNotifier.value = newLineup;
                              },
                            );
                          }).toList(),
                    ),
                    Text("Selected: ${homeLineup.length}/${widget.maxLinup}"),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Select Home Team"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Home Team",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              _buildTeamSelector(),
              const SizedBox(height: 20),
              if (homeTeam != null) _buildLineupSelector(homeTeam!),
              const SizedBox(height: 20),
              ArrowButton(
                label: "Next",
                onClick: () {
                  if (homeTeam == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a home team'),
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
                  if (homeLineupNotifier.value.length != widget.maxLinup) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select exactly ${widget.maxLinup} players for the lineup',
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
                  Get.to(
                    () => SelectHomeBenchPage(
                      maxLinup: widget.maxLinup,
                      data: MatchCreationData(
                        homeTeam: homeTeam,
                        homeLineup: homeLineupNotifier.value,
                        date: widget.date,
                        startTime: widget.startTime,
                        maxLinup: widget.maxLinup,
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
