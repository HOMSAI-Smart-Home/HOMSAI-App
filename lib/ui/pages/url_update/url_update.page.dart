import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/crossconcern/components/utils/double_url/double_url.widget.dart';
import 'package:homsai/ui/pages/url_update/bloc/url_update.bloc.dart';

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
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _UrlUpdateTitle(),
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
    return Text(HomsaiLocalizations.of(context)!.addUrlTitleEdit,
        style: Theme.of(context).textTheme.headline3);
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
