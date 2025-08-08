import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/widgets/search_field.dart';
import 'package:foot_track/view/player/widgets/player_card.dart';
import 'package:foot_track/view model/player.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  SearchHandler<PlayerModel>? _searchHandler;
  final PlayerRepo _playerRepo = PlayerRepo();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _searchHandler?.filter(_searchController.text);
  }

  Future<void> _loadPlayers() async {
    await _playerRepo.init();
    final players = await _playerRepo.getAllPlayers();
    _searchHandler = SearchHandler<PlayerModel>(
      allItems: players,
      filterProperty: (player) => player.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _loadPlayers(),
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
                  hintText: 'Search players...',
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, cst) {
                      int count = 1;
                      double ratio = 4 / 1;
                      if (cst.maxWidth > 300) ratio = 3 / 0.8;
                      if (cst.maxWidth > 700) count = 2;
                      if (cst.maxWidth > 1200) {
                        count = 3;
                        ratio = 5 / 1.2;
                      }
                      if (cst.maxWidth > 2400) {
                        count = 3;
                        ratio = 6 / 1;
                      }

                      return ValueListenableBuilder<List<PlayerModel>>(
                        valueListenable: _searchHandler!.filteredItemsNotifier,
                        builder: (context, filteredPlayers, _) {
                          if (filteredPlayers.isEmpty) {
                            return const Center(
                              child: Text("No players found"),
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: filteredPlayers.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: ratio,
                                  crossAxisCount: count,
                                ),
                            itemBuilder:
                                (context, index) => PlayerCard(
                                  playerModel: filteredPlayers[index],
                                  playerRepo: _playerRepo,
                                ),
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
    _searchHandler?.dispose();
    _playerRepo.close();
    super.dispose();
  }
}
