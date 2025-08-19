import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/resp.dart';
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
  String? _selectedPosition;
  List<PlayerModel> _availablePlayers = [];
  Future<void>? _loadFuture; // Cache the Future
  String? _errorMessage;

  // List of possible positions, including "All" for no position filter
  final List<String> _positions = [
    'All',
    'GK', // Goalkeeper
    'DEF', // Defender
    'MID', // Midfielder
    'FWD', // Forward
  ];

  // Map dropdown abbreviations to PlayerModel position values
  final Map<String, String> _positionMap = {
    'GK': 'Goalkeeper',
    'DEF': 'Defender',
    'MID': 'Midfielder',
    'FWD': 'Forward',
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _selectedPosition = _positions[0]; // Default to "All"
    _loadFuture = _loadData(); // Initialize Future once
  }

  void _onSearchChanged() {
    print('Search query: ${_searchController.text}');
    _searchHandler?.filter(_searchController.text);
  }

  Future<void> _loadData() async {
    try {
      print('Loading data: Initializing PlayerRepo');
      await _playerRepo.init();
      print('Loading data: Fetching all players');
      final allPlayers = await _playerRepo.getAllPlayers();
      print(
        'Loading data: Fetching team player keys for team ${widget.teamKey}',
      );
      final teamPlayerKeys = await _teamService.getTeamPlayerKeys(
        widget.teamKey,
      );
      print(
        'Loaded ${allPlayers.length} players, ${teamPlayerKeys.length} team players',
      );
      print('Player positions: ${allPlayers.map((p) => p.position).toSet()}');
      setState(() {
        _availablePlayers =
            allPlayers
                .where((player) => !teamPlayerKeys.contains(player.key))
                .toList();
        _searchHandler = SearchHandler<PlayerModel>(
          allItems: _availablePlayers,
          filterProperty: (player) => player.name, // Handle null name
        );
        _errorMessage = null;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _errorMessage = 'Failed to load players: $e';
      });
    }
  }

  // Filter players by position
  List<PlayerModel> _filterByPosition(List<PlayerModel> players) {
    if (_selectedPosition == 'All' || _selectedPosition == null) {
      print('Position filter: All, returning ${players.length} players');
      return players;
    }
    final mappedPosition = _positionMap[_selectedPosition];
    if (mappedPosition == null) {
      print(
        'Position filter: Invalid position $_selectedPosition, returning 0 players',
      );
      return [];
    }
    final filtered =
        players.where((player) {
          final matchesPosition =
              player.position.toLowerCase() == mappedPosition.toLowerCase();
          return matchesPosition;
        }).toList();
    print(
      'Position filter: $_selectedPosition ($mappedPosition), returning ${filtered.length} players',
    );
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Add Player"),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _loadFuture, // Use cached Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_errorMessage != null) {
              return Center(child: Text(_errorMessage!));
            }
            if (_availablePlayers.isEmpty && _searchHandler != null) {
              return const Center(child: Text('No players available to add'));
            }
            return Column(
              children: [
                Row(
                  children: [
                    // Search Field
                    Expanded(
                      child: SearchWidget(
                        controller: _searchController,
                        onChanged: (query) => _searchHandler?.filter(query),
                        hintText: 'Search players to add...',
                      ),
                    ),
                    // Position Filter Dropdown
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DropdownButtonFormField<String>(
                          value: _selectedPosition,
                          decoration: InputDecoration(
                            labelText: 'Filter',
                            labelStyle: TextStyle(
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
                          items:
                              _positions.map((position) {
                                return DropdownMenuItem<String>(
                                  value: position,
                                  child: Text(
                                    position,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            print('Selected position: $value');
                            setState(() {
                              _selectedPosition = value;
                              _searchHandler?.filter(_searchController.text);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, cst) {
                      int count = 1;
                      double ratio = 4 / 1;
                      ratio = getRatio(cst.maxWidth);
                      count = getCount(cst.maxWidth);
                      return ValueListenableBuilder<List<PlayerModel>>(
                        valueListenable: _searchHandler!.filteredItemsNotifier,
                        builder: (context, filteredPlayers, _) {
                          // Apply position filter
                          final positionFilteredPlayers = _filterByPosition(
                            filteredPlayers,
                          );
                          if (positionFilteredPlayers.isEmpty) {
                            return const Center(
                              child: Text("No available players to add"),
                            );
                          }
                          print(
                            'Displaying ${positionFilteredPlayers.length} players after filtering',
                          );
                          return GridView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: positionFilteredPlayers.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: ratio,
                                  crossAxisCount: count,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                            itemBuilder: (context, index) {
                              final player = positionFilteredPlayers[index];
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
                                                    style: TextStyle(
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      hintText: "Jersey Number",
                                                      hintStyle: TextStyle(
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
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
