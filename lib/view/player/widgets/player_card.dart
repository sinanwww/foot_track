import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/delete_box.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view/player/edit_player_page.dart';
import 'package:foot_track/view/player/player_detail_page.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:get/get.dart';

class PlayerCard extends StatefulWidget {
  final PlayerModel playerModel;
  final PlayerRepo playerRepo;

  const PlayerCard({
    super.key,
    required this.playerModel,
    required this.playerRepo,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  Future<void> removePlayer(String playerKey) async {
    try {
      await widget.playerRepo.deletePlayer(playerKey);

      Get.offAll(NavController(index: 3, teamPlayerTabIndex: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Player deleted'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting player: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var player = widget.playerModel;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),

      child: Center(
        child: ListTile(
          onTap: () => Get.to(() => PlayerDetailPage(playerModel: player)),
          horizontalTitleGap: 20,
          leading: CircleAvatar(
            backgroundImage:
                player.imageData != null
                    ? MemoryImage(player.imageData!)
                    : null,
            child: player.imageData == null ? const Icon(Icons.person) : null,
          ),
          title: Text(
            player.name,
            style: Fontstyle(color: Theme.of(context).colorScheme.secondary),
          ),
          subtitle: Text(
            player.position,
            style: Fontstyle(color: AppColors.secondary),
          ),
          trailing: PopupMenuButton(
            itemBuilder:
                (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    onTap: () {
                      Get.to(
                        () => EditPlayerPage(playerModel: player),
                      )?.then((_) {});
                    },
                    child: Row(
                      children: [
                        Text(
                          "Edit",
                          style: Fontstyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap:
                        () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteBox(
                              message:
                                  'Are you sure you want to delete "${player.name}"?',
                              deleteOnClick: () => removePlayer(player.key!),
                            );
                          },
                        ),
                    child: const Row(
                      children: [
                        Text("Delete", style: TextStyle(color: Colors.red)),
                        Spacer(),
                        Icon(Icons.delete, color: Colors.red),
                      ],
                    ),
                  ),
                ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
