import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/delete_box.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view/player/edit_player_page.dart';
import 'package:get/get.dart';

class PlayerDetailPage extends StatefulWidget {
  final PlayerModel playerModel;
  const PlayerDetailPage({super.key, required this.playerModel});

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  PlayerRepo _playerRepo = PlayerRepo();

  Future<void> removePlayer(String playerKey) async {
    try {
      await _playerRepo.deletePlayer(playerKey);

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
    return Scaffold(
      appBar: CustomAppbar(title: "Player Details"),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image:
                        widget.playerModel.imageData != null
                            ? DecorationImage(
                              fit: BoxFit.fill,
                              image: MemoryImage(widget.playerModel.imageData!),
                            )
                            : null,
                  ),

                  child:
                      widget.playerModel.imageData == null
                          ? Icon(Icons.person, size: 100.w)
                          : null,
                ),
                SizedBox(height: 50),
                dtLabel("Player Name", widget.playerModel.name),
                dtLabel("Player date of Birth", widget.playerModel.dateOfBirth),
                dtLabel("Player Position", widget.playerModel.position),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    btn(
                      label: "Edit",
                      color: AppColors.primary,
                      onTap: () {
                        Get.to(
                          () => EditPlayerPage(playerModel: widget.playerModel),
                        )?.then((_) {});
                      },
                    ),
                    SizedBox(width: 50),
                    btn(
                      label: "Delete",
                      color: Colors.red,
                      onTap:
                          () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteBox(
                                message:
                                    'Are you sure you want to delete "${widget.playerModel.name}"?',
                                deleteOnClick:
                                    () => removePlayer(widget.playerModel.key!),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btn({
    required String label,
    required Color color,
    required Function() onTap,
  }) => ElevatedButton(
    onPressed: onTap,
    child: Text(label),

    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: AppColors.white,
    ),
  );
  Widget dtLabel(String inicator, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          inicator + " :",
          style: Fontstyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10),
        Text(
          value,
          style: Fontstyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
