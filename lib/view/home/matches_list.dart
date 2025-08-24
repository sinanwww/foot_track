import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/match_card.dart';
import 'package:foot_track/view%20model/match_service.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view/home/filter_button.dart';
import 'package:foot_track/view/match/match_stat_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchesList extends StatefulWidget {
  const MatchesList({super.key});

  @override
  State<MatchesList> createState() => _MatchesListState();
}

class _MatchesListState extends State<MatchesList> {
  final ValueNotifier<bool> isTodayNotifier = ValueNotifier(true);
  final MatchService _matchService = MatchService();
  final TeamService _teamService = TeamService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter buttons for Today and Upcoming
        Padding(
          padding: EdgeInsets.only(left: 18, top: 18, bottom: 10),
          child: Text(
            'Matches',
            style: Fontstyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isTodayNotifier,
          builder: (context, isToday, child) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ToggleButton(
                    label: "Today",
                    isSelected: isToday,
                    onTap: () => isTodayNotifier.value = true,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(100),
                    ),
                  ),
                  ToggleButton(
                    label: "Upcoming",
                    isSelected: !isToday,
                    onTap: () => isTodayNotifier.value = false,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(100),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        // Matches list
        ValueListenableBuilder(
          valueListenable: isTodayNotifier,
          builder: (context, isToday, child) {
            return FutureBuilder<List<MatchModel>>(
              future: _matchService.getAllMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: Fontstyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                      ),
                    ),
                  );
                }
                final matches = snapshot.data ?? [];
               

                if (matches.isEmpty) {
                  return Center(
                    child: Text(
                      'No matches found',
                      style: Fontstyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  );
                }

                // Filter matches based on isTodayNotifier
                final DateTime now = DateTime.now();
                final DateTime today = DateTime(now.year, now.month, now.day);
                final filteredMatches =
                    matches.where((match) {
                      if (match.date == null) return false;
                      final matchDate = DateTime(
                        match.date!.year,
                        match.date!.month,
                        match.date!.day,
                      );
                     
                      if (isTodayNotifier.value) {
                        return matchDate.isAtSameMomentAs(today);
                      } else {
                        return matchDate.isAfter(today);
                      }
                    }).toList();

               

                if (filteredMatches.isEmpty) {
                  return Center(
                    child: Text(
                      isTodayNotifier.value
                          ? 'No matches today'
                          : 'No upcoming matches',
                      style: Fontstyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      itemCount: filteredMatches.length,
                      itemBuilder: (context, index) {
                        final match = filteredMatches[index];
                        return FutureBuilder<List<TeamModel?>>(
                          future: Future.wait([
                            _teamService.getTeam(match.homeTeamKey ?? ''),
                            _teamService.getTeam(match.awayTeamKey ?? ''),
                          ]),
                          builder: (context, teamSnapshot) {
                            if (teamSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (teamSnapshot.hasError ||
                                teamSnapshot.data == null) {
                              return const SizedBox(
                                width: 200,
                                child: Center(
                                  child: Text('Error loading teams'),
                                ),
                              );
                            }

                            final homeTeam =
                                teamSnapshot.data![0] ??
                                TeamModel(name: 'Unknown', logoImage: null);
                            final awayTeam =
                                teamSnapshot.data![1] ??
                                TeamModel(name: 'Unknown', logoImage: null);

                            // Format date and time with null safety
                            final date =
                                match.date != null
                                    ? DateFormat(
                                      'dd-MMM-yyyy',
                                    ).format(match.date!)
                                    : 'N/A';
                            final startTime =
                                match.startTime != null
                                    ? DateFormat(
                                      'hh:mm',
                                    ).format(match.startTime!)
                                    : 'N/A';

                            return MatchCard(
                              displayDate: date,
                              homeTeam: homeTeam.name ?? 'Unknown Team',
                              homeScore: match.homeScore ?? 0,
                              awayTeam: awayTeam.name ?? 'Unknown Team',
                              awayScore: match.awayScore ?? 0,
                              startTime: startTime,
                              onTap: () {
                                Get.to(
                                  () => MatchStatPage(matchKey: match.key!),
                                );
                              },
                              homeTeamLogoPath: homeTeam.logoImage ?? null,
                              awayTeamLogoPath: awayTeam.logoImage ?? null,
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
      ],
    );
  }

  @override
  void dispose() {
    isTodayNotifier.dispose();
    super.dispose();
  }
}
