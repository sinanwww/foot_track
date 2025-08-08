import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/delete_box.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view/team/new_team/add_teamplayer_page.dart';
import 'package:foot_track/view%20model/team_repo.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/team/widget/player_menu.dart';
import 'package:get/get.dart';

class TeamDetailPage extends StatefulWidget {
  final TeamModel data;
  const TeamDetailPage({super.key, required this.data});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  TeamModel? team;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  Future<void> _loadTeam() async {
    final loadedTeam = await TeamRepo().getTeam(widget.data.key ?? '');
    if (mounted) {
      setState(() {
        team = loadedTeam;
        isLoading = false;
      });
    }
  }

  Future<void> deleteTeam() async {
    await TeamRepo().deleteTeam(widget.data.key!);
    Get.offAll(() => NavController(index: 3, teamPlayerTabIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.name ?? 'Unnamed Team'),
        actions: [
          IconButton(
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteBox(deleteOnClick: deleteTeam);
                  },
                ),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : team == null
              ? const Center(child: Text('Team not found'))
              : team!.teamPlayer == null || team!.teamPlayer!.isEmpty
              ? const Center(child: Text('No players in this team'))
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: team!.teamPlayer!.length,
                itemBuilder: (context, index) {
                  final playerKey = team!.teamPlayer!.keys.elementAt(index);
                  final jerseyNumber = team!.teamPlayer![playerKey] ?? 0;

                  return FutureBuilder<PlayerModel?>(
                    future: PlayerRepo().getPlayer(playerKey),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text('Loading player...'),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Container(
                            color: Colors.amber,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.error, color: Colors.white),
                              ),
                              title: Text('Jersey: $jerseyNumber'),
                              subtitle: const Text('Player not found'),
                            ),
                          ),
                        );
                      }

                      final player = snapshot.data!;
                      return GestureDetector(
                        onLongPressStart: (LongPressStartDetails details) {
                          PlayerMenu.showPlayerMenu(
                            context: context,
                            position: details.globalPosition,
                            teamKey: widget.data.key!,
                            playerKey: playerKey,
                            jerseyNumber: jerseyNumber,
                            isCaptain: team!.captainKey == playerKey,
                            onActionComplete: _loadTeam,
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(
                                jerseyNumber.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              player.name +
                                  (team!.captainKey == playerKey
                                      ? ' (Captain)'
                                      : ''),
                              style: Fontstyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppTheam.primaryBlack,
                              ),
                            ),
                            subtitle: Text(
                              player.position,
                              style: Fontstyle(
                                fontSize: 14,
                                color: AppTheam.desableGreay,
                              ),
                            ),
                            trailing:
                                player.imagePath != null &&
                                        player.imagePath!.isNotEmpty &&
                                        File(player.imagePath!).existsSync()
                                    ? CircleAvatar(
                                      backgroundImage: FileImage(
                                        File(player.imagePath!),
                                      ),
                                    )
                                    : const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddTeamPlayerPage(teamKey: widget.data.key!));
        },
        label: Text("ADD PLAYER", style: Fontstyle(color: Colors.white)),
        backgroundColor: AppTheam.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
