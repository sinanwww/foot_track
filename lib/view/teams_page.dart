import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, cst) {
            int count = 1;
            double ratio = 4 / 1;
            if (cst.maxWidth > 300) {
              ratio = 3 / .8;
            }
            if (cst.maxWidth > 700) {
              count = 2;
            }
            if (cst.maxWidth > 1200) {
              count = 3;
              ratio = 5 / 1.2;
            }
            if (cst.maxWidth > 2400) {
              count = 3;
              ratio = 6 / 1;
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: ratio,
                crossAxisCount: count,
              ),
              itemCount: 10,
              padding: EdgeInsets.all(10),
              itemBuilder:
                  (context, index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheam.primarywhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "barcelona",
                          style: Fontstyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppTheam.primaryBlack,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }
}
