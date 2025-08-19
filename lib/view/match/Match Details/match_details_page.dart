import 'package:flutter/material.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/match/Match%20Details/bench_list.dart';
import 'package:foot_track/view/match/Match%20Details/linup_list.dart';
import 'package:foot_track/view/match/Match%20Details/substitution_list.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view%20model/match_service.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchDetailsPage extends StatefulWidget {
  final String matchKey;
  const MatchDetailsPage({super.key, required this.matchKey});

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  MatchModel? match;
  TeamModel? homeTeam;
  TeamModel? awayTeam;
  bool isLoading = true;
  final MatchService _matchService = MatchService();
  final TeamService _teamService = TeamService();
  final TextEditingController homeScoreController = TextEditingController();
  final TextEditingController awayScoreController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedStartTime;

  @override
  void initState() {
    super.initState();
    _loadMatch();
  }

  Future<void> _loadMatch() async {
    final loadedMatch = await _matchService.getMatch(widget.matchKey);
    if (loadedMatch != null) {
      final home = await _teamService.getTeam(loadedMatch.homeTeamKey ?? '');
      final away = await _teamService.getTeam(loadedMatch.awayTeamKey ?? '');
      if (mounted) {
        setState(() {
          match = loadedMatch;
          homeTeam = home;
          awayTeam = away;
          homeScoreController.text = (loadedMatch.homeScore ?? 0).toString();
          awayScoreController.text = (loadedMatch.awayScore ?? 0).toString();
          descriptionController.text = loadedMatch.description ?? '';
          selectedStartTime = loadedMatch.startTime;
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    homeScoreController.dispose();
    awayScoreController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedStartTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  AppColors
                      .primary, // Primary color for headers and selected date
              onPrimary: AppColors.white, // Text/icon color on primary
              surface:
                  Theme.of(
                    context,
                  ).scaffoldBackgroundColor, // Dialog background
              onSurface:
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.black
                      : AppColors.white, // Text/icon color on surface
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary, // Button text color
                textStyle: Fontstyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
            ),
            // ignore: deprecated_member_use
            dialogBackgroundColor: Theme.of(context).colorScheme.surface,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          selectedStartTime ?? DateTime.now(),
        ),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary, // Primary color for time picker
                onPrimary: AppColors.white, // Text/icon color on primary
                surface:
                    Theme.of(
                      context,
                    ).scaffoldBackgroundColor, // Dialog background
                onSurface:
                    Theme.of(context).brightness == Brightness.light
                        ? AppColors.black
                        : AppColors.white, // Text/icon color on surface
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary, // Button text color
                  textStyle: Fontstyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              // ignore: deprecated_member_use
              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null && mounted) {
        setState(() {
          selectedStartTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.offAll(() => NavController(index: 1));
            },
            child: const Text("Finish"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : match == null
              ? const Center(child: Text('Match not found'))
              : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        homeTeam?.name ?? 'Home',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: homeScoreController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: customDecoretion(
                            fillColor:
                                Theme.of(context).colorScheme.onSecondary,
                            hintText: "0",
                          ),
                        ),
                      ),
                      const Text(" - ", style: TextStyle(fontSize: 20)),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: awayScoreController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: customDecoretion(
                            fillColor:
                                Theme.of(context).colorScheme.onSecondary,
                            hintText: "0",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        awayTeam?.name ?? 'Away',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    "Match Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    style: Fontstyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Match Description',
                      labelStyle: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      selectedStartTime == null
                          ? 'Select Start Time'
                          : DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(selectedStartTime!),
                      style: Fontstyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onTap: () => _selectStartTime(context),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    "${homeTeam?.name ?? 'Home'} Lineup",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LineupList(
                    lineup: match!.homeLineup ?? [],
                    team: homeTeam,
                    isHome: true,
                    match: match!,
                    onGoalUpdated: _loadMatch,
                    onCardsUpdated: _loadMatch,
                    onSubstitutionUpdated: _loadMatch,
                    updateScoreControllers: () {
                      setState(() {
                        homeScoreController.text =
                            (match!.homeScore ?? 0).toString();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${homeTeam?.name ?? 'Home'} Bench",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BenchList(bench: match!.homeBench ?? [], team: homeTeam),
                  const SizedBox(height: 20),
                  Text(
                    "${awayTeam?.name ?? 'Away'} Lineup",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LineupList(
                    lineup: match!.awayLineup ?? [],
                    team: awayTeam,
                    isHome: false,
                    match: match!,
                    onGoalUpdated: _loadMatch,
                    onCardsUpdated: _loadMatch,
                    onSubstitutionUpdated: _loadMatch,
                    updateScoreControllers: () {
                      setState(() {
                        awayScoreController.text =
                            (match!.awayScore ?? 0).toString();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${awayTeam?.name ?? 'Away'} Bench",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BenchList(bench: match!.awayBench ?? [], team: awayTeam),
                  const SizedBox(height: 20),
                  const Text(
                    "Substitutions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SubstitutionList(
                    substitutions: match!.substitutions ?? [],
                    homeTeam: homeTeam,
                    awayTeam: awayTeam,
                  ),
                ],
              ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final homeScore = int.tryParse(homeScoreController.text) ?? 0;
          final awayScore = int.tryParse(awayScoreController.text) ?? 0;
          try {
            await _matchService.updateScores(
              matchKey: match!.key!,
              homeScore: homeScore,
              awayScore: awayScore,
            );
            await _matchService.updateMatchDetails(
              matchKey: match!.key!,
              startTime: selectedStartTime,
              description: descriptionController.text.trim(),
            );
            FocusManager.instance.primaryFocus?.unfocus();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Match details updated'),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $e'),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: const Text("Update Match"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
