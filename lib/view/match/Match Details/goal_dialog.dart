import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view%20model/match_service.dart';

class GoalDialog {
  static Future<void> show({
    required BuildContext context,
    required MatchModel match,
    required String playerKey,
    required int currentGoals,
    required bool isHome,
    required VoidCallback onSuccess,
  }) async {
    int goalCount = currentGoals;
    final matchService = MatchService();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Player Goals'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red),
                    onPressed: goalCount > 0
                        ? () {
                            setState(() {
                              goalCount--;
                            });
                          }
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Goals: $goalCount',
                      style: Fontstyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheam.primaryBlack,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        goalCount++;
                      });
                    },
                  ),
                ],
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
                print('Updating goals for player $playerKey: $goalCount (isHome: $isHome)');
                await matchService.updatePlayerGoals(
                  matchKey: match.key!,
                  playerKey: playerKey,
                  goalCount: goalCount,
                  time: DateTime.now(),
                  isHome: isHome,
                );
                onSuccess();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Player goals updated'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                print('Error updating goals: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating goals: $e'),
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