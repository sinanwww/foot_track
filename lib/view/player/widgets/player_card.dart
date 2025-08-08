import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/delete_box.dart';
import 'package:foot_track/view/player/edit_player_page.dart';
import 'package:foot_track/view/player/player_detail_page.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:get/get.dart';

class PlayerCard extends StatelessWidget {
  final PlayerModel playerModel;
  final PlayerRepo playerRepo;

  const PlayerCard({
    super.key,
    required this.playerModel,
    required this.playerRepo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: AppTheam.primarywhite,
      child: ListTile(
        onTap: () => Get.to(() => PlayerDetailPage(playerModel: playerModel)),
        horizontalTitleGap: 20,
        leading: CircleAvatar(
          backgroundImage:
              playerModel.imagePath != null
                  ? FileImage(File(playerModel.imagePath!))
                  : null,
          child: playerModel.imagePath == null ? Icon(Icons.person) : null,
        ),
        title: Text(playerModel.name),
        subtitle: Text(playerModel.position),
        trailing: PopupMenuButton(
          itemBuilder:
              (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    Get.to(EditPlayerPage(playerModel: playerModel));
                  },
                  child: Row(
                    children: [Text("Edit"), Spacer(), Icon(Icons.edit)],
                  ),
                ),
                PopupMenuItem(
                  onTap:
                      () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteBox(
                            deleteOnClick:
                                () => playerRepo.deletePlayer(playerModel.key!),
                          );
                        },
                      ),

                  child: Row(
                    children: [
                      Text("Delete", style: Fontstyle(color: Colors.red)),
                      Spacer(),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  ),
                ),
              ],
          icon: Icon(Icons.more_vert, color: AppTheam.primaryBlack),
        ),
      ),
    );
  }
}
