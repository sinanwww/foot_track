import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/view%20model/match_service.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/match/Match%20Details/match_details_page.dart';
import 'package:foot_track/view/match/match_creation/match_creation_data.dart';
import 'package:get/get.dart';

class SelectAwayBenchPage extends StatefulWidget {
  final MatchCreationData data;

  const SelectAwayBenchPage({super.key, required this.data});

  @override
  State<SelectAwayBenchPage> createState() => _SelectAwayBenchPageState();
}

class _SelectAwayBenchPageState extends State<SelectAwayBenchPage> {
  final PlayerRepo _playerRepo = PlayerRepo();
  final MatchService _matchService = MatchService();
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

  Widget _buildBenchSelector(TeamModel team) {
    final currentLineup = widget.data.awayLineup;
    final otherLineup = widget.data.homeLineup;
    final otherBench = widget.data.homeBench;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Text('No players available for bench');
            }
            final players = snapshot.data!;
            return ValueListenableBuilder<List<String>>(
              valueListenable: awayBenchNotifier,
              builder: (context, awayBench, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children:
                          players.map((player) {
                            final isSelected = awayBench.contains(player.key);
                            final isInLineup = currentLineup.contains(
                              player.key,
                            );
                            final isInOtherLineup = otherLineup.contains(
                              player.key,
                            );
                            final isInOtherBench = otherBench.contains(
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
                                  (isInLineup ||
                                          isInOtherLineup ||
                                          isInOtherBench)
                                      ? Colors.grey
                                      : null,
                              onSelected:
                                  (isInLineup ||
                                          isInOtherLineup ||
                                          isInOtherBench)
                                      ? null
                                      : (selected) {
                                        final newBench = List<String>.from(
                                          awayBench,
                                        );
                                        if (selected) {
                                          newBench.add(player.key!);
                                        } else {
                                          newBench.remove(player.key!);
                                        }
                                        awayBenchNotifier.value = newBench;
                                      },
                            );
                          }).toList(),
                    ),
                    Text("Bench Selected: ${awayBench.length}"),
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
    final team = widget.data.awayTeam!;
    return Scaffold(
      appBar: const CustomAppbar(title: "Select Away Bench"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Bench for ${team.name ?? 'Team'}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              _buildBenchSelector(team),
              const SizedBox(height: 20),
              ArrowButton(
                label: "Create Match",
                onClick: () async {
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
                    final matchKey = await _matchService.createMatch(
                      homeTeamKey: widget.data.homeTeam!.key!,
                      awayTeamKey: widget.data.awayTeam!.key!,
                      homeLineup: widget.data.homeLineup,
                      awayLineup: widget.data.awayLineup,
                      date: widget.data.date,
                      startTime: widget.data.startTime,
                      homeBench: widget.data.homeBench,
                      awayBench: awayBenchNotifier.value,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Match created successfully'),
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
                    Get.offAll(() => MatchDetailsPage(matchKey: matchKey));
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
