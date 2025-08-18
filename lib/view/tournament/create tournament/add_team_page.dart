import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/search_field.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:foot_track/view/tournament/tournament%20manage/tour_manage_page.dart';
import 'package:get/get.dart';

class AddTeamPage extends StatefulWidget {
  final String tournamentKey;
  const AddTeamPage({super.key, required this.tournamentKey});

  @override
  State<AddTeamPage> createState() => _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamPage> {
  final ValueNotifier<List<TeamModel>> _teamsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> _selectedTeamKeys = ValueNotifier([]);
  final TeamService _teamService = TeamService();
  final TournamentService _tournamentService = TournamentService();
  SearchHandler<TeamModel>? _searchHandler;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _searchHandler?.filter(_searchController.text);
  }

  Future<void> _loadTeams() async {
    final teams = await _teamService.getAllTeams();
    _searchHandler = SearchHandler<TeamModel>(
      allItems: teams,
      filterProperty: (team) => team.name ?? '',
    );
    _teamsNotifier.value = teams;
  }

  Future<void> _saveTeams() async {
    try {
      final tournament = await _tournamentService.getTournament(
        widget.tournamentKey,
      );
      if (tournament == null) {
        throw Exception('Tournament not found');
      }
      tournament.teamKeys = _selectedTeamKeys.value;
      await _tournamentService.updateTournament(tournament);
      Get.offAll(() => TourManagePage(tournamentKey: widget.tournamentKey));
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Teams added to tournament'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Error adding teams: $e'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Add Teams"),
      body: FutureBuilder<void>(
        future: _loadTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Column(
            children: [
              SearchWidget(
                controller: _searchController,
                onChanged: (query) => _searchHandler?.filter(query),
                hintText: 'Search teams...',
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, cst) {
                    int count = 1;
                    double ratio = 4 / 1;
                    count = getCount(cst.maxWidth);
                    ratio = getRatio(cst.maxWidth);
                    return ValueListenableBuilder<List<TeamModel>>(
                      valueListenable: _searchHandler!.filteredItemsNotifier,
                      builder: (context, teams, _) {
                        if (teams.isEmpty) {
                          return const Center(child: Text("No teams found"));
                        }
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: ratio,
                                crossAxisCount: count,
                              ),
                          itemCount: teams.length,
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            var team = teams[index];
                            return ValueListenableBuilder<List<String>>(
                              valueListenable: _selectedTeamKeys,
                              builder: (context, selectedKeys, _) {
                                bool isSelected = selectedKeys.contains(
                                  team.key,
                                );
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[300]!,
                                        spreadRadius: .4,
                                        blurRadius: .4,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedTeamKeys.value = List.from(
                                              _selectedTeamKeys.value,
                                            )..remove(team.key);
                                          } else {
                                            _selectedTeamKeys.value = List.from(
                                              _selectedTeamKeys.value,
                                            )..add(team.key!);
                                          }
                                        });
                                      },
                                      leading:
                                          team.logoImage != null
                                              ? Image.memory(
                                                team.logoImage!,
                                                scale: 4,
                                                height: 40,
                                              )
                                              : Image.asset(
                                                "assets/icon/logo.png",
                                                color: Colors.grey,
                                                scale: 4,
                                                height: 40,
                                              ),
                                      title: Text(
                                        team.name ?? "",
                                        style: Fontstyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        ),
                                      ),
                                      trailing: Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color:
                                            isSelected
                                                ? Colors.green
                                                : Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                      ),
                                    ),
                                  ),
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
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(30),
        child: ArrowButton(label: "Create", onClick: _saveTeams),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchHandler?.dispose();
    _teamsNotifier.dispose();
    _selectedTeamKeys.dispose();
    super.dispose();
  }
}
