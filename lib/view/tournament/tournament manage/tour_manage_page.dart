import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';

class TourManagePage extends StatefulWidget {
  const TourManagePage({super.key});

  @override
  State<TourManagePage> createState() => _TourManagePageState();
}

class _TourManagePageState extends State<TourManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "tour name"),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheam.primary,
        foregroundColor: Colors.white,
        onPressed: () {},
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Add New Round"), Icon(Icons.add)],
        ),
      ),
    );
  }
}
