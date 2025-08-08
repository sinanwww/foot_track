import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/search_field.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view/tournament/tournament%20manage/tour_manage_page.dart';
import 'package:get/get.dart';

class AddTeamPage extends StatefulWidget {
  const AddTeamPage({super.key});

  @override
  State<AddTeamPage> createState() => _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamPage> {
  final ValueNotifier<List<TeamModel>> _teamsNotifier = ValueNotifier([]);
  final TeamService _teamService = TeamService();
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
                            var showdata = teams[index];
                            return Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheam.primarywhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300]!,
                                    spreadRadius: 4,
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: ListTile(
                                  onTap: () {},
                                  leading:
                                      showdata.logoimagePath != null
                                          ? Image.file(
                                            File(showdata.logoimagePath!),
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
                                    showdata.name ?? "",
                                    style: Fontstyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheam.primaryBlack,
                                    ),
                                  ),
                                  trailing: Icon(Icons.circle_outlined),
                                ),
                              ),
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
        margin: EdgeInsets.all(30),
        child: ArrowButton(
          label: "Create",
          onClick: () {
            Get.offAll(() => TourManagePage());
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchHandler?.dispose();
    _teamsNotifier.dispose();
    super.dispose();
  }
}
