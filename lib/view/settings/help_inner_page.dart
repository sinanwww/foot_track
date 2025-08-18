import 'package:flutter/material.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';

class HelpInnerPage extends StatefulWidget {
  final String title;
  final List<String> guidlinesList;
  const HelpInnerPage({super.key, required this.title, required this.guidlinesList});

  @override
  State<HelpInnerPage> createState() => _HelpInnerPageState();
}

class _HelpInnerPageState extends State<HelpInnerPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.guidlinesList.length);
    return Scaffold(
      appBar: CustomAppbar(title: widget.title),
      body: LayoutBuilder(
        builder: (context, co) {
          return ListView.builder(
            padding: EdgeInsets.all(30),
            itemCount: widget.guidlinesList.length,
            itemBuilder: (context, index) {
              return txt(index + 1, widget.guidlinesList[index]);
            },
          );
        },
      ),
    );
  }

  Widget txt(int orderNumber, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${orderNumber.toString()}.",
            style: Fontstyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 15),
          SizedBox(
            width: 250,
            child: Text(
              label,
              style: Fontstyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
