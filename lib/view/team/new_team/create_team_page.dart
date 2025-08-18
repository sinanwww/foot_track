import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view/team/new_team/add_teamplayer_page.dart';
import 'package:foot_track/view%20model/team_repo.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:get/get.dart';

class CreateTeam extends StatefulWidget {
  final String teamKey;
  const CreateTeam({super.key, required this.teamKey});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  TeamModel? team;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  Future<void> _loadTeam() async {
    try {
      final loadedTeam = await TeamRepo().getTeam(widget.teamKey);
      if (mounted) {
        setState(() {
          team = loadedTeam;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load team: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(team?.name ?? 'Team Details')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    ArrowButton(
                      label: "Add Player",
                      onClick: () {
                        Get.to(
                          () => AddTeamPlayerPage(teamKey: widget.teamKey),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    team?.teamPlayer?.isEmpty ?? true
                        ? const Center(child: Text("No players in this team"))
                        : Expanded(
                          child: LayoutBuilder(
                            builder: (context, cst) {
                              int count = getCount(cst.maxWidth);
                              double ratio = getRatio(cst.maxWidth);
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: ratio,
                                      crossAxisCount: count,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                itemCount: team!.teamPlayer!.length,
                                itemBuilder: (context, index) {
                                  final playerKey = team!.teamPlayer!.keys
                                      .elementAt(index);
                                  final jerseyNumber =
                                      team!.teamPlayer![playerKey]!;

                                  return FutureBuilder<PlayerModel?>(
                                    future: PlayerRepo().getPlayer(playerKey),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Card(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Card(
                                          child: Center(
                                            child: ListTile(
                                              leading: const Icon(Icons.error),
                                              title: Text(
                                                'Jersey: $jerseyNumber',
                                              ),
                                              subtitle: const Text(
                                                'Error loading player',
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return Card(
                                          child: Center(
                                            child: ListTile(
                                              leading: const Icon(Icons.error),
                                              title: Text(
                                                'Jersey: $jerseyNumber',
                                              ),
                                              subtitle: const Text(
                                                'Player not found',
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final player = snapshot.data!;
                                      return Card(
                                        child: Center(
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.orange,
                                              child: Text(
                                                jerseyNumber.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              player.name,
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                              ),
                                            ),
                                            subtitle: Text(
                                              player.position,
                                              style: TextStyle(
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                            trailing:
                                                player.imageData != null
                                                    ? CircleAvatar(
                                                      backgroundImage:
                                                          MemoryImage(
                                                            player.imageData!,
                                                          ),
                                                    )
                                                    : const CircleAvatar(
                                                      child: Icon(Icons.person),
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
                        ),
                  ],
                ),
              ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(15),
        child: AuthButton(
          onClick: () {
            Get.to(() => NavController(index: 3, teamPlayerTabIndex: 0));
          },
          label: "Finish",
        ),
      ),
    );
  }
}
