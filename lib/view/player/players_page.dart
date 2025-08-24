import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/add_float_button.dart';
import 'package:foot_track/utls/widgets/search_field.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/player/add_player_page.dart';
import 'package:foot_track/view/player/widgets/player_card.dart';
import 'package:get/get.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final PlayerRepo _playerRepo = PlayerRepo();
  SearchHandler<PlayerModel>? _searchHandler;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializePlayers();
  }

  void _onSearchChanged() {
    _searchHandler?.filter(_searchController.text);
  }

  Future<void> _initializePlayers() async {
    await _playerRepo.init();
    setState(() {
      _searchHandler = SearchHandler<PlayerModel>(
        allItems: _playerRepo.playersNotifier.value,
        filterProperty: (player) => player.name,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<List<PlayerModel>>(
          valueListenable: _playerRepo.playersNotifier,
          builder: (context, players, _) {
            if (_searchHandler == null) {
              return const Center(child: CircularProgressIndicator());
            }
            // _searchHandler!.allItems = players; // Sync search handler with latest players
            return Column(
              children: [
                SearchWidget(
                  controller: _searchController,
                  onChanged: (query) => _searchHandler?.filter(query),
                  hintText: 'Search players...',
                ),
                Expanded(
                  child: ValueListenableBuilder<List<PlayerModel>>(
                    valueListenable: _searchHandler!.filteredItemsNotifier,
                    builder: (context, filteredPlayers, _) {
                      if (filteredPlayers.isEmpty) {
                        return Center(
                          child: Text(
                            "No players found",
                            style: Fontstyle(
                              fontSize: 16,
                              color: AppColors.secondary,
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
                          return GridView.builder(
                            padding: const EdgeInsets.all(15),
                            itemCount: filteredPlayers.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
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
      floatingActionButton: AddFloatButton(
        label: "Add Player",
        onPressed: () {
          Get.to(() => const AddPlayerPage());
        },
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
