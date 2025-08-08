import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/delete_box.dart';
import 'package:foot_track/view%20model/team_service.dart';

enum PlayerMenuOption { editJersey, deletePlayer, toggleCaptain }

class PlayerMenu {
  static void showPlayerMenu({
    required BuildContext context,
    required Offset position,
    required String teamKey,
    required String playerKey,
    required int jerseyNumber,
    required bool isCaptain,
    required Function() onActionComplete,
  }) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final menuPosition = RelativeRect.fromLTRB(
      position.dx,
      position.dy + 10, // Slight offset below tap
      overlay.size.width - position.dx,
      overlay.size.height - position.dy,
    );

    showMenu<PlayerMenuOption>(
      context: context,
      position: menuPosition,
      items: [
        _buildMenuItem(
          value: PlayerMenuOption.editJersey,
          label: 'Edit Jersey Number',
          onTap:
              () => editJerseyNumber(
                context: context,
                teamKey: teamKey,
                playerKey: playerKey,
                currentJerseyNumber: jerseyNumber,
                onComplete: onActionComplete,
              ),
        ),
        _buildMenuItem(
          value: PlayerMenuOption.deletePlayer,
          label: 'Delete Player',
          onTap:
              () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteBox(
                    deleteOnClick:
                        () => removePlayer(
                          context: context,
                          teamKey: teamKey,
                          playerKey: playerKey,
                          onComplete: onActionComplete,
                        ),
                  );
                },
              ),
        ),
        _buildMenuItem(
          value: PlayerMenuOption.toggleCaptain,
          label: isCaptain ? 'Remove Captain' : 'Set as Captain',
          onTap:
              () => toggleCaptain(
                context: context,
                teamKey: teamKey,
                playerKey: playerKey,
                isCaptain: isCaptain,
                onComplete: onActionComplete,
              ),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static PopupMenuItem<PlayerMenuOption> _buildMenuItem({
    required PlayerMenuOption value,
    required String label,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem<PlayerMenuOption>(
      value: value,
      child: Text(
        label,
        style: Fontstyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheam.primaryBlack,
        ),
      ),
      onTap: () => Future.delayed(const Duration(milliseconds: 100), onTap),
    );
  }

  static Future<void> editJerseyNumber({
    required BuildContext context,
    required String teamKey,
    required String playerKey,
    required int currentJerseyNumber,
    required VoidCallback onComplete,
  }) async {
    await showDialog<void>(
      context: context,
      builder:
          (dialogContext) => _JerseyNumberDialog(
            teamKey: teamKey,
            playerKey: playerKey,
            currentJerseyNumber: currentJerseyNumber,
            onComplete: onComplete,
          ),
    );
  }

  static Future<void> removePlayer({
    required BuildContext context,
    required String teamKey,
    required String playerKey,
    required VoidCallback onComplete,
  }) async {
    await TeamService().removePlayerFromTeam(
      teamKey: teamKey,
      playerKey: playerKey,
    );
    onComplete();
  }

  static Future<void> toggleCaptain({
    required BuildContext context,
    required String teamKey,
    required String playerKey,
    required bool isCaptain,
    required VoidCallback onComplete,
  }) async {
    try {
      final TeamService _teamService = TeamService();
      if (isCaptain) {
        await _teamService.removeCaptain(teamKey: teamKey);
        onComplete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Captain removed'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        await _teamService.setCaptain(teamKey: teamKey, playerKey: playerKey);
        onComplete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Captain set'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _JerseyNumberDialog extends StatefulWidget {
  final String teamKey;
  final String playerKey;
  final int currentJerseyNumber;
  final VoidCallback onComplete;

  const _JerseyNumberDialog({
    required this.teamKey,
    required this.playerKey,
    required this.currentJerseyNumber,
    required this.onComplete,
  });

  @override
  _JerseyNumberDialogState createState() => _JerseyNumberDialogState();
}

class _JerseyNumberDialogState extends State<_JerseyNumberDialog> {
  final TextEditingController _jerseyNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TeamService _teamService = TeamService();

  @override
  void initState() {
    super.initState();
    _jerseyNumberController.text = widget.currentJerseyNumber.toString();
  }

  @override
  void dispose() {
    _jerseyNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Jersey Number'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _jerseyNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter new jersey number',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a jersey number';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newJerseyNumber = int.parse(
                _jerseyNumberController.text.trim(),
              );
              if (newJerseyNumber != widget.currentJerseyNumber) {
                final isUnique = await _teamService.isJerseyNumberUnique(
                  widget.teamKey,
                  newJerseyNumber,
                );
                if (!isUnique) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Jersey number $newJerseyNumber is already in use',
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                        bottom: 0,
                        left: 20,
                        right: 20,
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }
              }
              try {
                await _teamService.updatePlayerJerseyNumber(
                  teamKey: widget.teamKey,
                  playerKey: widget.playerKey,
                  newJerseyNumber: newJerseyNumber,
                );
                widget.onComplete();
                Navigator.pop(context, newJerseyNumber);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Jersey number updated'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                        bottom: 200,
                        left: 20,
                        right: 20,
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                        bottom: 200,
                        left: 20,
                        right: 20,
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
