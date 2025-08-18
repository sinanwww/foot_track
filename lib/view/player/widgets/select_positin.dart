import 'package:flutter/material.dart';
import 'package:foot_track/utls/widgets/type_field.dart';

class SelectPositin extends StatefulWidget {
  final Function(String)? onSelectPosition;
  final String? initialPosition;
  const SelectPositin({
    super.key,
    required this.onSelectPosition,
    this.initialPosition,
  });

  @override
  State<SelectPositin> createState() => _SelectPositinState();
}

class _SelectPositinState extends State<SelectPositin> {
  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      selectedPosition = Positions.values.firstWhere(
        (pos) => pos.name == widget.initialPosition,
      );
    }
  }

  Positions? selectedPosition;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Positions>(
      decoration: customDecoretion(
        fillColor: Theme.of(context).colorScheme.surface,
        hintText: "Select position",
      ),
      isExpanded: true,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
      value: selectedPosition,
      items:
          Positions.values.map((position) {
            return DropdownMenuItem<Positions>(
              value: position,
              child: Text(position.name),
            );
          }).toList(),
      onChanged: (value) {
        widget.onSelectPosition!(value!.name);
        setState(() {
          selectedPosition = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a position';
        }
        return null;
      },
    );
  }
}

enum Positions {
  gk("Goalkeeper"),
  df("Defender"),
  fw("Forward"),
  md("Midfielder");

  final String name;
  const Positions(this.name);
}
