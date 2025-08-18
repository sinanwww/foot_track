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

      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),

        child: Center(
          child: ListTile(
            horizontalTitleGap: 20,
            leading: CircleAvatar(
              backgroundImage:
                  widget.playerModel.imageData!.isNotEmpty
                      ? MemoryImage(widget.playerModel.imageData!)
                      : null,
              child:
                  widget.playerModel.imageData!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
            ),
            title: Text(
              widget.playerModel.name,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            subtitle: Text(
              widget.playerModel.position,
              style: TextStyle(color: AppColors.secondary),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
