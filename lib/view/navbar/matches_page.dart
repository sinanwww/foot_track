import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/widgets/match_card.dart';
import 'package:foot_track/view/match/match_stat_page.dart';
import 'package:foot_track/view%20model/match_service.dart';
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
  final MatchService _matchService = MatchService();
  final TeamService _teamService = TeamService();

  @override
  void initState() {
    super.initState();
    _cleanInvalidMatches();
  }

  Future<void> _cleanInvalidMatches() async {
    try {
      await _matchService.cleanInvalidMatches();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error cleaning invalid matches: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cleaning matches: $e'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _deleteAllMatches() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete All Matches'),
            content: const Text(
              'Are you sure you want to delete all matches? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (shouldDelete == true && mounted) {
      try {
        await _matchService.deleteAllMatches();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All matches deleted'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting matches: $e'),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE8E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Matches',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: _deleteAllMatches,
            tooltip: 'Delete All Matches',
          ),
          const SizedBox(width: 15),
        ],
      ),
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
                  style: TextStyle(color: AppTheam.primaryBlack),
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
                    if (cst.maxWidth > 300) {
                      ratio = 3 / 0.8;
                    }
                    if (cst.maxWidth > 700) {
                      count = 2;
                    }
                    if (cst.maxWidth > 1200) {
                      count = 3;
                      ratio = 5 / 1.2;
                    }
                    if (cst.maxWidth > 2400) {
                      count = 3;
                      ratio = 6 / 1;
                    }
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
                                    style: TextStyle(
                                      color: AppTheam.primaryBlack,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final homeTeam = teamSnapshot.data?[0];
                            final awayTeam = teamSnapshot.data?[1];
                            return MatchCard(
                              awayTeamLogoPath: awayTeam?.logoimagePath,
                              homeTeamLogoPath: homeTeam?.logoimagePath,
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
