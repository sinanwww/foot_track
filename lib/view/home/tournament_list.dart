import 'package:flutter/material.dart';
import 'package:foot_track/model/tournament/tournament_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:foot_track/view/home/filter_button.dart';
import 'package:foot_track/view/tournament/tournament%20manage/tour_manage_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TournamentList extends StatefulWidget {
  const TournamentList({super.key});

  @override
  State<TournamentList> createState() => _TournamentListState();
}

class _TournamentListState extends State<TournamentList> {
  final ValueNotifier<bool> isTodayNotifier = ValueNotifier(true);
  final TournamentService _tournamentService = TournamentService();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isTodayNotifier,
      builder: (context, isToday, child) {
        return FutureBuilder<List<TournamentModel>>(
          future: _tournamentService.getAllTournaments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: Fontstyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ),
              );
            }
            final tournaments = snapshot.data ?? [];
            if (tournaments.isEmpty) {
              return Center(
                child: Text(
                  'No tournaments found',
                  style: Fontstyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              );
            }

            // Filter tournaments based on isTodayNotifier
            final DateTime now = DateTime.now();
            final DateTime today = DateTime(now.year, now.month, now.day);
            List<TournamentModel> filteredTournaments =
                tournaments.where((tournament) {
                  if (tournament.date == null)
                    return false; // Skip tournaments with null dates
                  final tournamentDate = DateTime(
                    tournament.date!.year,
                    tournament.date!.month,
                    tournament.date!.day,
                  );
                  if (isTodayNotifier.value) {
                    return tournamentDate.isAtSameMomentAs(today);
                  } else {
                    return tournamentDate.isAfter(today);
                  }
                }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 18, bottom: 10),
                  child: Text(
                    'Tournaments',
                    style: Fontstyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18),
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
                ),
                SizedBox(
                  height: 150,

                  child:
                      filteredTournaments.isEmpty
                          ? Center(
                            child: Text(
                              isTodayNotifier.value
                                  ? 'No tournaments today'
                                  : 'No upcoming tournaments',
                              style: Fontstyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(20),
                            itemCount: filteredTournaments.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final tournament = filteredTournaments[index];
                              return InkWell(
                                onTap: () {
                                  Get.to(
                                    () => TourManagePage(
                                      tournamentKey: tournament.key!,
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 150,
                                  child: Card(
                                    elevation: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            tournament.name ??
                                                'Unnamed Tournament',
                                            style: Fontstyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Venue: ${tournament.venue ?? "N/A"}',
                                            style: Fontstyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.secondary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Date: ${tournament.date != null ? DateFormat('dd-MM-yyyy').format(tournament.date!) : "N/A"}',
                                            style: Fontstyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    isTodayNotifier.dispose();
    super.dispose();
  }
}
