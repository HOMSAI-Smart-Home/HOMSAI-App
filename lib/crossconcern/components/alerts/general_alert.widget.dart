import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homsai/crossconcern/components/alerts/alert.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:super_rich_text/super_rich_text.dart';
import 'package:homsai/crossconcern/utilities/properties/connection.properties.dart';

class NoInternetConnectionAlert extends StatelessWidget {
  const NoInternetConnectionAlert({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return Alert(AlertType.error,
        key: key,
        icon: SvgPicture.asset(
          "assets/icons/wifi.svg",
          color: HomsaiColors.primaryRed,
        ),
        title: Text(
          HomsaiLocalizations.of(context)!.alertNoInternetConnectionAlertTitle,
          style: Theme.of(context).textTheme.headline3,
        ),
        message: SuperRichText(
          text: HomsaiLocalizations.of(context)!
              .alertNoInternetConnectionAlertContent,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        closeBtnAction: () => {
              homeBloc.add(const RemoveAlert(
                  ConnectionProperties.noInternetConnectionAlertKey))
            });
  }
}

class NoHomeAssistantConnectionAlert extends StatelessWidget {
  const NoHomeAssistantConnectionAlert({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return Alert(AlertType.error,
        key: key,
        icon: SvgPicture.asset(
          "assets/icons/wifi.svg",
          color: HomsaiColors.primaryRed,
        ),
        title: Text(
          HomsaiLocalizations.of(context)!
              .alertNoHomeAssistantConnectionAlertTitle,
          style: Theme.of(context).textTheme.headline3,
        ),
        message: SuperRichText(
          text: HomsaiLocalizations.of(context)!
              .alertNoHomeAssistantConnectionAlertContent,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        closeBtnAction: () => {
              homeBloc.add(const RemoveAlert(
                  ConnectionProperties.noInternetConnectionAlertKey))
            });
  }
}
