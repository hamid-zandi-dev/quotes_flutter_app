import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final String appBarTitle;
  final String appBarIcon;
  final bool? backButtonVisibility;
  final void Function()? onBackButtonClickListener;
  const CustomAppBar({
    super.key,
    required this.appBarTitle,
    required this.appBarIcon,
    this.backButtonVisibility,
    this.onBackButtonClickListener,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: Visibility(
        visible: backButtonVisibility ?? false,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (onBackButtonClickListener != null) {
              onBackButtonClickListener!();
            }
          },
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              appBarTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          SvgPicture.asset(
            appBarIcon,
            width: 48,
            height: 48,
          )
        ],
      ),
    );
  }
}
