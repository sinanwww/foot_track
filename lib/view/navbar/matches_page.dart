import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/match_card.dart';
import 'package:foot_track/view/match/match_stat_page.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final TeamService _teamService = TeamService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Box<MatchModel>>(
          future: Hive.openBox<MatchModel>('matches'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error opening matches: ${snapshot.error}',
                  style: TextStyle(color: AppColors.black),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Unable to open matches'));
            }
            return ValueListenableBuilder<Box<MatchModel>>(
              valueListenable: snapshot.data!.listenable(),
              builder: (context, box, _) {
                final matches = box.values.toList();
                if (matches.isEmpty) {
                  return const Center(child: Text('No matches available'));
                }
                return LayoutBuilder(
                  builder: (context, cst) {
                    int count = 1;
                    double ratio = 4 / 1;
                    ratio = getRatio(cst.maxWidth);
                    count = getCount(cst.maxWidth);
                    ratio = ratio - .5;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: ratio,
                        crossAxisCount: count,
                      ),
                      itemCount: matches.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        if (match.key == null) {
                          return const Card(
                            child: Center(child: Text('Invalid match data')),
                          );
                        }
                        return FutureBuilder<List<TeamModel?>>(
                          future: Future.wait([
                            _teamService.getTeam(match.homeTeamKey ?? ''),
                            _teamService.getTeam(match.awayTeamKey ?? ''),
                          ]),
                          builder: (context, teamSnapshot) {
                            if (teamSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (teamSnapshot.hasError) {
                              return Card(
                                child: Center(
                                  child: Text(
                                    'Error loading teams: ${teamSnapshot.error}',
                                    style: TextStyle(color: AppColors.black),
                                  ),
                                ),
                              );
                            }
                            final homeTeam = teamSnapshot.data?[0];
                            final awayTeam = teamSnapshot.data?[1];
                            return MatchCard(
                              awayTeamLogoPath: awayTeam?.logoImage,
                              homeTeamLogoPath: homeTeam?.logoImage,
                              displayDate:
                                  match.date != null
                                      ? DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(match.date!)
                                      : 'N/A',

                              homeTeam: homeTeam?.name ?? 'Home',
                              homeScore: match.homeScore!,
                              awayTeam: awayTeam?.name ?? 'Away',
                              awayScore: match.awayScore!,

                              startTime:
                                  match.startTime != null
                                      ? DateFormat(
                                        'HH:mm',
                                      ).format(match.startTime!)
                                      : 'N/A',

                              onTap: () {
                                Get.to(
                                  () => MatchStatPage(matchKey: match.key!),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
