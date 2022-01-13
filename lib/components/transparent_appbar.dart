import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final String navigatorPath;
  final List<Widget> actions;
  final Function? onPressed;

  const TransparentAppBar({
    Key? key,
    this.appBarTitle = '',
    this.navigatorPath = '',
    this.actions = const [],
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(appBarTitle,
        style: const TextStyle(
          color: Colors.black
      ),),
      leading: IconButton(
        icon: const Icon(FontAwesomeIcons.arrowLeft),
        color: Colors.black,
        onPressed: () {
          if(onPressed != null){
            onPressed!();
          } else {
            Navigator.pushNamedAndRemoveUntil(context, navigatorPath , (route) => false);
          }
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }

  @override

  Size get preferredSize {
    return const Size.fromHeight(56.0);
  }
}
