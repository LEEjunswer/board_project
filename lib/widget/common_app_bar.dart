import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;

  const CommonAppBar({Key? key, this.title, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        padding: const EdgeInsets.only(top: 12.0, left: 10),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
        icon: SvgPicture.asset(
          'assets/icons/left_arrow.svg',
          width: 24,
          height: 24,
        ),
      ),
      title: title != null
          ? Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          title!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      )
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(9),
        child: Column(
          children: [
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 9);
}