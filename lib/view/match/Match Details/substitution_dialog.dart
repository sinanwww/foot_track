import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view%20model/match_service.dart';
import 'package:foot_track/view%20model/player.dart';

class SubstitutionDialog {
  static Future<void> show({
    required BuildContext context,
    required MatchModel match,
    required TeamModel? team,
    required bool isHome,
    required String outPlayerKey,
    required VoidCallback onSuccess,
  }) async {
    final matchService = MatchService();
    final playerRepo = PlayerRepo();
    final bench = isHome ? match.homeBench : match.awayBench;
    final substitutedOut =
        (match.substitutions ?? [])
            .map((sub) => sub['outPlayerKey'] as String)
            .toSet();
    final redCount =
        (match.redCards ?? [])
            .where((r) => r['playerKey'] == outPlayerKey)
            .length;
    final yellowCount =
        (match.yellowCards ?? [])
            .where((y) => y['playerKey'] == outPlayerKey)
            .length;
    if (substitutedOut.contains(outPlayerKey)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This player has already been substituted'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (redCount > 0 || yellowCount >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This player has been sent off and cannot be substituted',
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final availablePlayers =
        (bench ?? []).where((key) => !substitutedOut.contains(key)).toList();
    String? selectedPlayerKey;

    await showDialog<void>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(
              'Select Substitute Player',
              style: Fontstyle(color: Theme.of(context).colorScheme.secondary),
            ),
            content: StatefulBuilder(
              builder:
                  (context, setState) => DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Choose player from bench'),
                    value: selectedPlayerKey,
                    items:
                        availablePlayers.map((playerKey) {
                          return DropdownMenuItem<String>(
                            value: playerKey,
                            child: FutureBuilder<PlayerModel?>(
                              future: playerRepo.getPlayer(playerKey),
                              builder: (context, snapshot) {
                                final player = snapshot.data;
                                return Text(
                                  player != null
                                      ? '${player.name} (#${team?.teamPlayer?[playerKey]})'
                                      : 'Loading...',
                                  style: Fontstyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPlayerKey = value;
                      });
                    },
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedPlayerKey != null) {
                    try {
                      await matchService.addSubstitution(
                        matchKey: match.key!,
                        outPlayerKey: outPlayerKey,
                        inPlayerKey: selectedPlayerKey!,
                        time: DateTime.now(),
                        isHome: isHome,
                      );
                      onSuccess();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Substitution recorded'),
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
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error recording substitution: $e'),
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
                    }
                  }
                  Navigator.pop(dialogContext);
                },
                child: const Text('Substitute'),
              ),
            ],
          ),
    );
  }
}
