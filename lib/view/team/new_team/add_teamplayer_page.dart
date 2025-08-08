import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/search_field.dart';
import 'package:foot_track/view/team/new_team/create_team_page.dart';
import 'package:foot_track/view/team/widget/select_playercard.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:get/get.dart';

class AddTeamPlayerPage extends StatefulWidget {
  final String teamKey;
  const AddTeamPlayerPage({super.key, required this.teamKey});

  @override
  State<AddTeamPlayerPage> createState() => _AddTeamPlayerPageState();
}

class _AddTeamPlayerPageState extends State<AddTeamPlayerPage> {
  final PlayerRepo _playerRepo = PlayerRepo();
  final TeamService _teamService = TeamService();
  final TextEditingController jerseyNumberCt = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SearchHandler<PlayerModel>? _searchHandler;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _searchHandler?.filter(_searchController.text);
  }

  Future<void> _loadData() async {
    await _playerRepo.init();
    final allPlayers = await _playerRepo.getAllPlayers();
    final teamPlayerKeys = await _teamService.getTeamPlayerKeys(widget.teamKey);
    final availablePlayers =
        allPlayers
            .where((player) => !teamPlayerKeys.contains(player.key))
            .toList();
    _searchHandler = SearchHandler<PlayerModel>(
      allItems: availablePlayers,
      filterProperty: (player) => player.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Add Player"),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _loadData(),
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
                  hintText: 'Search players to add...',
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      double childAspectRatio = 4 / 1;
                      if (constraints.maxWidth > 300) {
                        childAspectRatio = 3 / 0.8;
                      }
                      if (constraints.maxWidth > 700) {
                        crossAxisCount = 2;
                      }
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 3;
                        childAspectRatio = 5 / 1.2;
                      }
                      if (constraints.maxWidth > 2400) {
                        crossAxisCount = 3;
                        childAspectRatio = 6 / 1;
                      }
                      return ValueListenableBuilder<List<PlayerModel>>(
                        valueListenable: _searchHandler!.filteredItemsNotifier,
                        builder: (context, filteredPlayers, _) {
                          if (filteredPlayers.isEmpty) {
                            return const Center(
                              child: Text("No available players to add"),
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: filteredPlayers.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: childAspectRatio,
                                  crossAxisCount: crossAxisCount,
                                ),
                            itemBuilder: (context, index) {
                              final player = filteredPlayers[index];
                              return SelectPlayerCard(
                                onClick: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder:
                                        (context) => Form(
                                          key: _formKey,
                                          child: AnimatedPadding(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            padding: EdgeInsets.only(
                                              bottom:
                                                  MediaQuery.of(
                                                    context,
                                                  ).viewInsets.bottom,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                          hintText:
                                                              "Jersey Number",
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                    controller: jerseyNumberCt,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return 'Please enter a jersey number';
                                                      }
                                                      if (int.tryParse(value) ==
                                                          null) {
                                                        return 'Please enter a valid number';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const SizedBox(height: 20),
                                                  AuthButton(
                                                    onClick: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        final jerseyNumber =
                                                            int.parse(
                                                              jerseyNumberCt
                                                                  .text
                                                                  .trim(),
                                                            );
                                                        try {
                                                          await _teamService
                                                              .addPlayerToTeam(
                                                                teamKey:
                                                                    widget
                                                                        .teamKey,
                                                                playerKey:
                                                                    player.key!,
                                                                jerseyNumber:
                                                                    jerseyNumber,
                                                              );
                                                          jerseyNumberCt
                                                              .clear();
                                                          Get.offAll(
                                                            () => CreateTeam(
                                                              teamKey:
                                                                  widget
                                                                      .teamKey,
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                '${player.name} added to team',
                                                              ),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                    bottom: 200,
                                                                    left: 20,
                                                                    right: 20,
                                                                  ),
                                                              backgroundColor:
                                                                  Colors.green,
                                                              duration:
                                                                  const Duration(
                                                                    seconds: 2,
                                                                  ),
                                                            ),
                                                          );
                                                        } catch (e) {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                e.toString(),
                                                              ),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                    bottom: 200,
                                                                    left: 20,
                                                                    right: 20,
                                                                  ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                              duration:
                                                                  const Duration(
                                                                    seconds: 2,
                                                                  ),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    label: "Add Player",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                },
                                playerModel: player,
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
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    jerseyNumberCt.dispose();
    _searchHandler?.dispose();
    _playerRepo.close();
    super.dispose();
  }
}
