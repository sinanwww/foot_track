import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/match/Match%20Details/card_dialog.dart';
import 'package:foot_track/view/match/Match%20Details/goal_dialog.dart';
import 'package:foot_track/view/match/Match%20Details/substitution_dialog.dart';

class LineupList extends StatelessWidget {
  final List<String> lineup;
  final TeamModel? team;
  final bool isHome;
  final MatchModel match;
  final VoidCallback onGoalUpdated;
  final VoidCallback onCardsUpdated;
  final VoidCallback onSubstitutionUpdated;
  final VoidCallback updateScoreControllers;

  const LineupList({
    super.key,
    required this.lineup,
    this.team,
    required this.isHome,
    required this.match,
    required this.onGoalUpdated,
    required this.onCardsUpdated,
    required this.onSubstitutionUpdated,
    required this.updateScoreControllers,
  });

  @override
  Widget build(BuildContext context) {
    final playerRepo = PlayerRepo();
    return lineup.isEmpty
        ? const Text("No players selected")
        : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lineup.length,
          itemBuilder: (context, index) {
            final playerKey = lineup[index];
            return FutureBuilder<PlayerModel?>(
              future: playerRepo.getPlayer(playerKey),
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
                final goals =
                    (match.goalScorers ?? [])
                        .where((g) => g['playerKey'] == playerKey)
                        .length;
                final yellows =
                    (match.yellowCards ?? [])
                        .where((g) => g['playerKey'] == playerKey)
                        .length;
                final reds =
                    (match.redCards ?? [])
                        .where((g) => g['playerKey'] == playerKey)
                        .length;
                final isSentOff = reds > 0 || yellows >= 2;
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              isSentOff ? Colors.grey : Colors.orange[400],
                          child: Text(
                            jerseyNumber,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: Fontstyle(
                                  color:
                                      isSentOff
                                          ? Colors.grey
                                          : Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                player.position,
                                style: Fontstyle(
                                  color:
                                      isSentOff
                                          ? Colors.grey
                                          : AppColors.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if (isSentOff)
                                Text(
                                  'Sent Off',
                                  style: Fontstyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            if (goals > 0)
                              playerStat(
                                isGoal: true,
                                count: goals,
                                iconColor: Colors.green,
                              ),
                            if (yellows > 0)
                              playerStat(
                                count: yellows,
                                iconColor: Colors.yellow,
                              ),
                            if (reds > 0)
                              playerStat(count: reds, iconColor: Colors.red),

                            const SizedBox(width: 10),

                            PopupMenuButton(
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      onTap:
                                          isSentOff
                                              ? null
                                              : () => GoalDialog.show(
                                                context: context,
                                                match: match,
                                                playerKey: playerKey,
                                                currentGoals: goals,
                                                isHome: isHome,
                                                onSuccess: () {
                                                  onGoalUpdated();
                                                  updateScoreControllers();
                                                },
                                              ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.sports_soccer,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            "Goal",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap:
                                          isSentOff
                                              ? null
                                              : () => SubstitutionDialog.show(
                                                context: context,
                                                match: match,
                                                team: team,
                                                isHome: isHome,
                                                outPlayerKey: playerKey,
                                                onSuccess:
                                                    onSubstitutionUpdated,
                                              ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.swap_horiz_rounded,
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            "sub",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap:
                                          () => CardDialog.show(
                                            context: context,
                                            match: match,
                                            playerKey: playerKey,
                                            currentYellows: yellows,
                                            currentReds: reds,
                                            onSuccess: onCardsUpdated,
                                          ),
                                      child: Row(
                                        children: [
                                          Transform.rotate(
                                            angle: 300,
                                            child: Icon(
                                              Icons.rectangle_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "Card",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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

  Widget playerStat({
    required int count,
    bool isGoal = false,
    required Color iconColor,
  }) => Row(
    children: [
      Transform.rotate(
        angle: 300,
        child: Icon(
          isGoal == true ? Icons.sports_soccer : Icons.rectangle,
          color: iconColor,
        ),
      ),
      Text(count.toString()),
    ],
  );
}
