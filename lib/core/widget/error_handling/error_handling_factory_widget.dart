import 'package:flutter/widgets.dart';
import 'package:quotes/core/error_handling/failure.dart';
import 'package:quotes/core/utils/constants.dart';
import 'error_handling_widget.dart';

abstract class ErrorHandlingFactoryWidget extends Widget {
  factory ErrorHandlingFactoryWidget(
    BuildContext context,
    Failure failure, {
    final void Function()? onClickListener,
  }) {
    switch (failure) {
      case Failure.serverError:
        return ErrorHandlingWidget(
          title: "There is a problem connecting to the server",
          description: "Please try again later",
          image: ImagesPath.serverError,
          tryAgainVisibility: false,
          onClickListener: onClickListener,
        );

      case Failure.noInternetConnectionError:
        return ErrorHandlingWidget(
          title: "No internet connection",
          description: "Please check your internet connection",
          image: ImagesPath.noInternetConnectionError,
          tryAgainVisibility: true,
          onClickListener: onClickListener,
        );

      case Failure.noFoundData:
        return ErrorHandlingWidget(
          title: "There is no information to display",
          description: "",
          image: ImagesPath.noFoundData,
          tryAgainVisibility: false,
          onClickListener: onClickListener,
        );

      case Failure.unknownError:
        return ErrorHandlingWidget(
          title: "An unknown error has occurred",
          description: "Please try again",
          image: ImagesPath.unknownError,
          tryAgainVisibility: true,
          onClickListener: onClickListener,
        );
    }
  }
}
