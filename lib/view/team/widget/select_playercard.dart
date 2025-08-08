import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/view%20model/team_repo.dart';

class SelectPlayerCard extends StatefulWidget {
  final PlayerModel playerModel;
  final TeamRepo? teamRepo;
  final Function() onClick;
  const SelectPlayerCard({
    super.key,
    required this.playerModel,
    this.teamRepo,
    required this.onClick,
  });

  @override
  State<SelectPlayerCard> createState() => _SelectPlayerCardState();
}

class _SelectPlayerCardState extends State<SelectPlayerCard> {
  TextEditingController JCt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      // showModalBottomSheet(
      //   useSafeArea: true,
      //   isScrollControlled: true,
      //   enableDrag: false,
      //   context: context,
      //   builder: (context) {
      //     return AddPalyerSheet(
      //       playerKey: playerModel.key!,
      //       existingJerseyNumbers:
      //           teamRepo.teamPlayerList.value.map((e) => e.jercyNo).toList(),
      //       onPlayerAdded: (TeamPlayer teamPlayer) {
      //         teamRepo.addTeamPlayer(teamPlayer);
      //       },
      //     );
      //   },
      // );

      // showAboutDialog(
      //   context: context,
      //   children: [
      //     TextField(controller: JCt),
      //     IconButton(onPressed: () {}, icon: Icon(Icons.add_box)),
      //   ],
      // );
      // },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: AppTheam.primarywhite,
        child: ListTile(
          horizontalTitleGap: 20,
          leading: CircleAvatar(
            backgroundImage:
                widget.playerModel.imagePath!.isNotEmpty
                    ? FileImage(File(widget.playerModel.imagePath!))
                    : null,
            child:
                widget.playerModel.imagePath!.isEmpty
                    ? const Icon(Icons.person)
                    : null,
          ),
          title: Text(widget.playerModel.name),
          subtitle: Text(widget.playerModel.position),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ),
    );
  }
}
