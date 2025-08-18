import 'package:flutter/material.dart';
import 'package:foot_track/model/tournament/tournament_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/view/tournament/create%20tournament/add_tour_page%20.dart';
import 'package:foot_track/view/tournament/tournament%20manage/tour_manage_page.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TournamentListPage extends StatefulWidget {
  const TournamentListPage({super.key});

  @override
  State<TournamentListPage> createState() => _TournamentListPageState();
}

class _TournamentListPageState extends State<TournamentListPage> {
  final TournamentService _tournamentService = TournamentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TournamentModel>>(
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
          return LayoutBuilder(
            builder: (context, cst) {
              int count = 1;
              double ratio = 4 / 1;
              ratio = getRatio(cst.maxWidth);
              count = getCount(cst.maxWidth);
              ratio -= .4;
              if (cst.maxWidth < 400) ratio -= .5;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: ratio,
                  crossAxisCount: count,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: const EdgeInsets.all(20),
                itemCount: tournaments.length,
                itemBuilder: (context, index) {
                  final tournament = tournaments[index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => TourManagePage(tournamentKey: tournament.key!),
                      );
                    },
                    child: Card(
                      // margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tournament.name ?? 'Unnamed Tournament',
                              style: Fontstyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              'Venue: ${tournament.venue ?? "N/A"}',
                              style: Fontstyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondary,
                              ),
                            ),
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
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.to(() => const AddTournamentPage());
        },
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Add Tournament"), Icon(Icons.add)],
        ),
      ),
    );
  }
}
