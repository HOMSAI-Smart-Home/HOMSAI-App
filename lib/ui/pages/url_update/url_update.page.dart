import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/ui/widget/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/ui/widget/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/ui/widget/utils/double_url/double_url.widget.dart';
import 'package:homsai/ui/pages/url_update/bloc/url_update.bloc.dart';
import 'package:super_rich_text/super_rich_text.dart';

class UrlUpdatePage extends StatelessWidget {
  final void Function(bool) onResult;
  final bool wizard;

  const UrlUpdatePage({
    Key? key,
    required this.onResult,
    this.wizard = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<DoubleUrlBloc>(
          create: (context) => DoubleUrlBloc(),
        ),
        BlocProvider<UrlUpdateBloc>(
          create: (context) => UrlUpdateBloc(
            BlocProvider.of<DoubleUrlBloc>(context),
          ),
          lazy: false,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: true,
      children: <Widget>[
        _UrlUpdateTitle(),
        const SizedBox(
          height: 24,
        ),
        _UrlDescription(),
        const SizedBox(
          height: 24,
        ),
        const DoubleUrl(),
        const SizedBox(
          height: 16,
        ),
        _UrlUpdateSave(onResult, wizard),
      ],
    );
  }
}

class _UrlUpdateTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(HomsaiLocalizations.of(context)!.urlTitle,
        style: Theme.of(context).textTheme.headline2);
  }
}

class _UrlDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuperRichText(
      textAlign: TextAlign.center,
      text: HomsaiLocalizations.of(context)!.urlDescription,
      style: Theme.of(context).textTheme.bodyText1,
      othersMarkers: [
        MarkerText.withUrl(
          marker: '%1',
          urls: [
            "https://companion.home-assistant.io/docs/troubleshooting/networking/"
          ],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}

class _UrlUpdateSave extends StatelessWidget {
  final void Function(bool) onResult;
  final bool wizard;

  const _UrlUpdateSave(this.onResult, this.wizard);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoubleUrlBloc, DoubleUrlState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.status.isValid
                ? () {
                    context.read<UrlUpdateBloc>().add(
                          UrlSubmitted(
                            onSubmit: () => wizard
                                ? context.router.replace(
                                    AddPlantRoute(onResult: onResult),
                                  )
                                : onResult(true),
                          ),
                        );
                  }
                : null,
            child: Text(HomsaiLocalizations.of(context)!.next),
          );
        });
  }
}
