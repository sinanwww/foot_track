import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view%20model/match_service.dart';

class CardDialog {
  static Future<void> show({
    required BuildContext context,
    required MatchModel match,
    required String playerKey,
    required int currentYellows,
    required int currentReds,
    required VoidCallback onSuccess,
  }) async {
    int yellowCount = currentYellows;
    int redCount = currentReds;
    final matchService = MatchService();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Player Cards'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: yellowCount,
                hint: const Text('Yellow Cards'),
                items: [0, 1, 2].map((count) {
                  return DropdownMenuItem<int>(
                    value: count,
                    child: Text('$count Yellow Card${count == 1 ? '' : 's'}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    yellowCount = value!;
                    if (yellowCount == 2) {
                      redCount = 1; // Two yellows require a red
                    } else if (yellowCount < 2 && redCount == 1 && currentYellows == 2) {
                      redCount = 0; // Remove auto red if yellows reduced
                    }
                  });
                },
              ),
              DropdownButton<int>(
                value: redCount,
                hint: const Text('Red Cards'),
                items: [0, 1].map((count) {
                  return DropdownMenuItem<int>(
                    value: count,
                    child: Text('$count Red Card${count == 1 ? '' : 's'}'),
                  );
                }).toList(),
                onChanged: yellowCount >= 2
                    ? null // Disable red card dropdown if two yellows
                    : (value) {
                        setState(() {
                          redCount = value!;
                        });
                      },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await matchService.updatePlayerCards(
                  matchKey: match.key!,
                  playerKey: playerKey,
                  yellowCount: yellowCount,
                  redCount: redCount,
                  time: DateTime.now(),
                );
                onSuccess();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Player cards updated'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating cards: $e'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}