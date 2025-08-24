import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/match/match_creation/away/away_bench_page.dart';
import 'package:foot_track/view/match/match_creation/match_creation_data.dart';
import 'package:get/get.dart';

class SelectAwayTeamPage extends StatefulWidget {
  final MatchCreationData data;

  const SelectAwayTeamPage({super.key, required this.data});

  @override
  State<SelectAwayTeamPage> createState() => _SelectAwayTeamPageState();
}

class _SelectAwayTeamPageState extends State<SelectAwayTeamPage> {
  final TeamService _teamService = TeamService();
  final PlayerRepo _playerRepo = PlayerRepo();
  TeamModel? awayTeam;
  final ValueNotifier<List<String>> awayLineupNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _playerRepo.init();
    awayLineupNotifier.value = List.from(widget.data.awayLineup);
  }

  @override
  void dispose() {
    _playerRepo.close();
    awayLineupNotifier.dispose();
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
        final availableTeams =
            teams
                .where((team) => team.key != widget.data.homeTeam!.key)
                .toList();
        return DropdownButton<TeamModel>(
          isExpanded: true,
          hint: const Text('Select Away Team'),
          value: awayTeam,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          items:
              availableTeams.map((team) {
                return DropdownMenuItem<TeamModel>(
                  value: team,
                  child: Text(team.name ?? 'Unnamed Team'),
                );
              }).toList(),
          onChanged: (team) {
            if (team != awayTeam) {
              setState(() {
                awayTeam = team;
                awayLineupNotifier.value = [];
              });
            }
          },
        );
      },
    );
  }

  Widget _buildLineupSelector(TeamModel team) {
    final otherLineup = widget.data.homeLineup;
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
              valueListenable: awayLineupNotifier,
              builder: (context, awayLineup, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children:
                          players.map((player) {
                            final isSelected = awayLineup.contains(player.key);
                            final isInOtherLineup = otherLineup.contains(
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
                                        final newLineup = List<String>.from(
                                          awayLineup,
                                        );
                                        if (selected &&
                                            newLineup.length <
                                                widget.data.maxLinup) {
                                          newLineup.add(player.key!);
                                        } else if (!selected) {
                                          newLineup.remove(player.key!);
                                        }
                                        awayLineupNotifier.value = newLineup;
                                      },
                            );
                          }).toList(),
                    ),
                    Text(
                      "Selected: ${awayLineup.length}/${widget.data.maxLinup}",
                    ),
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
      appBar: const CustomAppbar(title: "Select Away Team"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Away Team",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              _buildTeamSelector(),
              const SizedBox(height: 20),
              if (awayTeam != null) _buildLineupSelector(awayTeam!),
              const SizedBox(height: 20),
              ArrowButton(
                label: "Next",
                onClick: () {
                  if (awayTeam == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an away team'),
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
                  if (awayLineupNotifier.value.length != widget.data.maxLinup) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select exactly ${widget.data.maxLinup} players for the lineup',
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
                    () => SelectAwayBenchPage(
                      data: widget.data.copyWith(
                        awayTeam: awayTeam,
                        awayLineup: awayLineupNotifier.value,
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
