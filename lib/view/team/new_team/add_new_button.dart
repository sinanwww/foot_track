import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foot_track/utls/font_style.dart';

class AddNewButton extends StatelessWidget {
  final String image;
  final String label;
  final Function() onClick;

  const AddNewButton({
    super.key,
    required this.image,
    required this.label,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onClick,
      child: Container(
        // padding: EdgeInsets.all(10),
        // width: 360,
        // height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(image)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: Fontstyle(
                      color: Colors.white,
                      fontSize: ScreenWidth < 1200 ? 18.sp : 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: ScreenWidth < 1200 ? 18.w : 10.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
