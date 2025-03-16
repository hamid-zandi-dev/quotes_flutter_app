import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/theme_manager.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import 'error_handling_factory_widget.dart';

class ErrorHandlingWidget extends StatefulWidget implements ErrorHandlingFactoryWidget {
  const ErrorHandlingWidget({super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.tryAgainVisibility,
    this.onClickListener
  });
  final String title;
  final String description;
  final String image;
  final bool tryAgainVisibility;
  final void Function()? onClickListener;

  @override
  State<ErrorHandlingWidget> createState() => _ErrorHandlingWidgetState();
}

class _ErrorHandlingWidgetState extends State<ErrorHandlingWidget> {
  late AppColor _appColor;
  @override
  Widget build(BuildContext context) {
    _appColor = Theme.of(context).extension<AppColor>()!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createImage(),
          const SizedBox(height: 4),
          _createTitleWidget(),
          const SizedBox(height: 12),
          _createDescriptionWidget(),
          if (widget.tryAgainVisibility) const SizedBox(height: 32),
          if (widget.tryAgainVisibility) _createRetryWidget()
        ],
    ));
  }

  Widget _createImage() {
    return Image.asset(
      widget.image,
      width: Utils.getWidth(context) * 0.5,
      height: Utils.getWidth(context) * 0.5,
    );
  }

  Widget _createTitleWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }


  Widget _createDescriptionWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.description,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _appColor.secondaryTextColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _createRetryWidget() {
    return Material(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(Dimen.retryRadius)),
        child: Ink(
          decoration: BoxDecoration(
            color: _appColor.backgroundColor,
            border: Border.all(color: _appColor.iconTintColor, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(Dimen.retryRadius)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _createRetryIconWidget(),
                const SizedBox(width: 4),
                _createRetryTextWidget(),
              ],
            ),
          ),
        ),
        onTap: () {
          if (widget.onClickListener != null) {
            widget.onClickListener!();
          }
        },
      ),
    );
  }

  Widget _createRetryIconWidget() {
    return SvgPicture.asset(
      ImagesPath.iconRetry,
      width: 20,
      height: 20,
    );
  }

  Widget _createRetryTextWidget() {
    return const Text("Retry",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

}
