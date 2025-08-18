import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

double getRatio(screenWidth) {
  double ratio = 4 / 1;
  if (screenWidth > 300) {
    ratio = 3 / 0.8;
  }

  if (screenWidth > 1200) {
    ratio = 5 / 1.2;
  }
  if (screenWidth > 2400) {
    ratio = 6 / 1;
  }
  return ratio;
}

int getCount(screenWidth) {
  int count = 1;
  if (screenWidth > 700) {
    count = 2;
  }
  if (screenWidth > 1200) {
    count = 3;
  }
  if (screenWidth > 2400) {
    count = 3;
  }
  return count;
}

class FormWrap extends StatelessWidget {
  final Widget child;
  const FormWrap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cst) {
        bool isMax = cst.maxWidth > 600;

        return Center(
          child: Container(
            padding: isMax ? EdgeInsets.all(20) : null,
            constraints: BoxConstraints(maxWidth: 600),
            decoration:
                isMax
                    ? BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                    : null,
            child: child,
          ),
        );
      },
    );
  }
}
