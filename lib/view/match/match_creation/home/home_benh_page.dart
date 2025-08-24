import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/match/match_creation/away/select_away_page.dart';
import 'package:foot_track/view/match/match_creation/match_creation_data.dart';
import 'package:get/get.dart';

class SelectHomeBenchPage extends StatefulWidget {
  final MatchCreationData data;
  final int maxLinup;

  const SelectHomeBenchPage({super.key, required this.data,required this.maxLinup});

  @override
  State<SelectHomeBenchPage> createState() => _SelectHomeBenchPageState();
}

class _SelectHomeBenchPageState extends State<SelectHomeBenchPage> {
  final PlayerRepo _playerRepo = PlayerRepo();
  final ValueNotifier<List<String>> homeBenchNotifier = ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _playerRepo.init();
    homeBenchNotifier.value = List.from(widget.data.homeBench);
  }

  @override
  void dispose() {
    _playerRepo.close();
    homeBenchNotifier.dispose();
    super.dispose();
  }

  Widget _buildBenchSelector(TeamModel team) {
    final currentLineup = widget.data.homeLineup;
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
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No players available for bench');
            }
            final players = snapshot.data!;
            return ValueListenableBuilder<List<String>>(
              valueListenable: homeBenchNotifier,
              builder: (context, homeBench, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: players.map((player) {
                        final isSelected = homeBench.contains(player.key);
                        final isInLineup = currentLineup.contains(player.key);
                        return ChoiceChip(
                          selectedColor: AppColors.primary,
                          label: Text(
                            player.name,
                            style: Fontstyle(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          selected: isSelected,
                          disabledColor: isInLineup ? Colors.grey : null,
                          onSelected: isInLineup
                              ? null
                              : (selected) {
                                  final newBench = List<String>.from(homeBench);
                                  if (selected) {
                                    newBench.add(player.key!);
                                  } else {
                                    newBench.remove(player.key!);
                                  }
                                  homeBenchNotifier.value = newBench;
                                },
                        );
                      }).toList(),
                    ),
                    Text("Bench Selected: ${homeBench.length}"),
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
    final team = widget.data.homeTeam!;
    return Scaffold(
      appBar: const CustomAppbar(title: "Select Home Bench"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Bench for ${team.name ?? 'Team'}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              _buildBenchSelector(team),
              const SizedBox(height: 20),
              ArrowButton(
                label: "Next",
                onClick: () {
                  Get.to(() => SelectAwayTeamPage(
                    // maxLinup: widget.maxLinup,
                        data: widget.data.copyWith(homeBench: homeBenchNotifier.value),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}