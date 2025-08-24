import 'package:flutter/material.dart';
import 'package:foot_track/model/tournament/tournament_model.dart';
import 'package:foot_track/model/tournament/round_model.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/match/Match%20Details/match_details_page.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:foot_track/view%20model/match_service.dart';
import 'package:foot_track/view%20model/team_service.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view/tournament/create%20tournament/add_round_page.dart';
import 'package:foot_track/view/tournament/create%20tournament/tournament_match/select_config_page.dart';
import 'package:foot_track/view/match/date_bottem.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TourManagePage extends StatefulWidget {
  final String tournamentKey;
  const TourManagePage({super.key, required this.tournamentKey});

  @override
  State<TourManagePage> createState() => _TourManagePageState();
}

class _TourManagePageState extends State<TourManagePage> {
  final TournamentService _tournamentService = TournamentService();
  final MatchService _matchService = MatchService();
  final TeamService _teamService = TeamService();
  TournamentModel? tournament;
  List<String?> tourTeams = [];

  @override
  void initState() {
    super.initState();
    _loadTournament();
  }

  Future<void> _loadTournament() async {
    final fetchedTournament = await _tournamentService.getTournament(
      widget.tournamentKey,
    );
    setState(() {
      tournament = fetchedTournament;
    });
  }

  void _showEditTournamentDialog() {
    final nameController = TextEditingController(text: tournament!.name);
    final venueController = TextEditingController(text: tournament!.venue);
    final descriptionController = TextEditingController(
      text: tournament!.description,
    );
    final dateController = TextEditingController(
      text:
          tournament!.date != null
              ? DateFormat('dd-MM-yyyy').format(tournament!.date!)
              : '',
    );
    DateTime? selectedDate = tournament!.date;
    String? selectedWinner = tournament!.winner;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Edit Tournament',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name"),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: TypeField(
                      hintText: "name",
                      controller: nameController,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Venue"),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: TypeField(
                      hintText: "venue",
                      controller: venueController,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Description"),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: TypeField(
                      hintText: "description",
                      controller: descriptionController,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Winner"),
                  SizedBox(height: 10),
                  FutureBuilder<List<TeamModel>>(
                    future: Future.wait(
                      (tournament!.teamKeys).map(
                        (key) => _teamService.getTeam(key),
                      ),
                    ).then((teams) => teams.whereType<TeamModel>().toList()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return const Text('No teams available');
                      }
                      final teams = snapshot.data!;
                      return DropdownButton<String?>(
                        isExpanded: true,
                        hint: Text(
                          'Select Winner',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        value: selectedWinner,
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              'No winner',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          ...teams.map((team) {
                            return DropdownMenuItem<String>(
                              value: team.key,
                              child: Text(
                                team.name ?? 'Unnamed Team',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          selectedWinner = value;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text("Date"),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: DatePickerBottem(
                      controller: dateController,
                      onSubmit: (newDate) {
                        selectedDate = newDate;
                        dateController.text = DateFormat(
                          'dd-MM-yyyy',
                        ).format(newDate);
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  try {
                    final updatedTournament = TournamentModel(
                      key: tournament!.key,
                      name: nameController.text,
                      venue: venueController.text,
                      description: descriptionController.text,
                      date: selectedDate,
                      teamKeys: tournament!.teamKeys,
                      rounds: tournament!.rounds,
                      winner: selectedWinner,
                    );
                    await _tournamentService.updateTournament(
                      updatedTournament,
                    );
                    setState(() {
                      tournament = updatedTournament;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tournament updated'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating tournament: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  void _showDeleteTournamentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Tournament'),
            content: const Text(
              'Are you sure you want to delete this tournament? This will also delete all associated matches.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _tournamentService.deleteTournament(
                      widget.tournamentKey,
                    );
                    Navigator.pop(context);
                    Get.off(
                      () => const NavController(index: 1, matchTourTabIndex: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tournament deleted'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting tournament: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showEditRoundDialog(int roundIndex, RoundModel round) {
    final nameController = TextEditingController(text: round.name);
    final descriptionController = TextEditingController(
      text: round.description,
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Edit Round',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Round Name',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final updatedRound = RoundModel(
                      description: descriptionController.text,
                      name: nameController.text,
                      matchKeys: round.matchKeys,
                    );
                    await _tournamentService.updateRound(
                      widget.tournamentKey,
                      roundIndex,
                      updatedRound,
                    );
                    await _loadTournament();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Round updated'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating round: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showDeleteRoundDialog(int roundIndex) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Round'),
            content: const Text(
              'Are you sure you want to delete this round? This will also delete all associated matches.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _tournamentService.deleteRound(
                      widget.tournamentKey,
                      roundIndex,
                    );
                    await _loadTournament();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Round deleted'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting round: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddTeamDialog() {
    TeamModel? selectedTeam;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Add Team',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            content: FutureBuilder<List<TeamModel>>(
              future: _teamService.getAllTeams(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Text('No teams available');
                }
                final teams =
                    snapshot.data!
                        .where(
                          (team) => !tournament!.teamKeys.contains(team.key),
                        )
                        .toList();

                return DropdownButton<TeamModel>(
                  isExpanded: true,
                  hint: const Text('Select Team'),
                  value: selectedTeam,
                  items:
                      teams.map((team) {
                        return DropdownMenuItem<TeamModel>(
                          value: team,
                          child: Text(
                            team.name ?? 'Unnamed Team',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (team) {
                    selectedTeam = team;
                  },
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedTeam == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a team'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  try {
                    await _tournamentService.addTeamToTournament(
                      widget.tournamentKey,
                      selectedTeam!.key!,
                    );
                    await _loadTournament();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Team added to tournament'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error adding team: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showDeleteTeamDialog(String teamKey, String teamName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Team'),
            content: Text(
              'Are you sure you want to remove $teamName from the tournament?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _tournamentService.removeTeamFromTournament(
                      widget.tournamentKey,
                      teamKey,
                    );
                    await _loadTournament();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Team removed from tournament'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error removing team: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tournament == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey,
        title: Text(tournament!.name ?? "Tournament Management"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(NavController(index: 1, matchTourTabIndex: 1));
              },
              child: Text("Finish"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tournament Details',
                    style: Fontstyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.primary),
                        onPressed: _showEditTournamentDialog,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: _showDeleteTournamentDialog,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Description: ${tournament!.description ?? "N/A"}',
                style: Fontstyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                'Venue: ${tournament!.venue ?? "N/A"}',
                style: Fontstyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                'Date: ${tournament!.date != null ? DateFormat('dd-MM-yyyy').format(tournament!.date!) : "N/A"}',
                style: Fontstyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              FutureBuilder<TeamModel?>(
                future:
                    tournament!.winner != null
                        ? _teamService.getTeam(tournament!.winner!)
                        : Future.value(null),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final winnerTeam = snapshot.data;
                  return Text(
                    'Winner: ${winnerTeam?.name ?? "No winner declared"}',
                    style: Fontstyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Teams',
                    style: Fontstyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.primary),
                    onPressed: _showAddTeamDialog,
                  ),
                ],
              ),
              FutureBuilder<List<TeamModel>>(
                future: Future.wait(
                  (tournament!.teamKeys).map(
                    (key) => _teamService.getTeam(key),
                  ),
                ).then((teams) {
                  tourTeams = teams.map((e) => e!.key).toList();
                  return teams.whereType<TeamModel>().toList();
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Text('No teams added');
                  }
                  return Column(
                    children:
                        snapshot.data!.map((team) {
                          return Card(
                            child: ListTile(
                              leading:
                                  team.logoImage != null
                                      ? Image.memory(
                                        team.logoImage!,
                                        height: 20,
                                        width: 20,
                                      )
                                      : Image.asset(
                                        "assets/icon/logo.png",
                                        color: Colors.grey,

                                        height: 20,width: 20,
                                      ),
                              title: Text(
                                team.name ?? 'Unnamed Team',
                                style: Fontstyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _showDeleteTeamDialog(
                                      team.key!,
                                      team.name ?? 'Unnamed Team',
                                    ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Rounds',
                style: Fontstyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              if (tournament!.rounds.isEmpty)
                const Text('No rounds added')
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      tournament!.rounds.asMap().entries.map((entry) {
                        final index = entry.key;
                        final round = entry.value;
                        return Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              collapsedIconColor:
                                  Theme.of(context).colorScheme.secondary,
                              iconColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    round.name ?? 'Round ${index + 1}',
                                    style: Fontstyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: AppColors.primary,
                                        ),
                                        onPressed:
                                            () => _showEditRoundDialog(
                                              index,
                                              round,
                                            ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _showDeleteRoundDialog(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              children: [
                                Text(round.description ?? ""),
                                FutureBuilder<List<MatchModel>>(
                                  future: Future.wait(
                                    round.matchKeys.map(
                                      (key) => _matchService.getMatch(key),
                                    ),
                                  ).then(
                                    (matches) =>
                                        matches
                                            .whereType<MatchModel>()
                                            .toList(),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Text(
                                        'No matches in this round',
                                      );
                                    }
                                    return Column(
                                      children:
                                          snapshot.data!.map((match) {
                                            return FutureBuilder<
                                              List<TeamModel>
                                            >(
                                              future: Future.wait([
                                                _teamService.getTeam(
                                                  match.homeTeamKey!,
                                                ),
                                                _teamService.getTeam(
                                                  match.awayTeamKey!,
                                                ),
                                              ]).then(
                                                (teams) =>
                                                    teams
                                                        .whereType<TeamModel>()
                                                        .toList(),
                                              ),
                                              builder: (context, teamSnapshot) {
                                                if (teamSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                }
                                                final teams =
                                                    teamSnapshot.data ?? [];
                                                final homeTeam =
                                                    teams.isNotEmpty
                                                        ? teams[0]
                                                        : null;
                                                final awayTeam =
                                                    teams.length > 1
                                                        ? teams[1]
                                                        : null;
                                                return Card(
                                                  elevation: 3,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.surface,
                                                  child: ListTile(
                                                    onTap: () {
                                                      Get.to(
                                                        () => MatchDetailsPage(
                                                          matchKey: match.key!,
                                                        ),
                                                      );
                                                    },
                                                    title: Text(
                                                      '${homeTeam?.name ?? "Unknown"} vs ${awayTeam?.name ?? "Unknown"}',
                                                      style: Fontstyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      'Score: ${match.homeScore ?? 0} - ${match.awayScore ?? 0}',
                                                      style: Fontstyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                    );
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(
                                      () => SelectMatchConfigPage(
                                        teamKeys:
                                            tourTeams
                                                .whereType<String>()
                                                .toList(),
                                        tournamentKey: widget.tournamentKey,
                                        roundIndex: index,
                                      ),
                                    );

                                    print(tourTeams);
                                  },
                                  child: const Text(
                                    'Add Match',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed:
            () =>
                Get.to(() => AddRoundPage(tournamentKey: widget.tournamentKey)),
        label: Row(children: [Text("Add Round"), Icon(Icons.add_rounded)]),
      ),
    );
  }
}
