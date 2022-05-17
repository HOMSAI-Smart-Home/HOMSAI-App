import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/bloc/url_text_field.bloc.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/url_text_field.widget.dart';
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
        BlocProvider<LocalUrlTextFieldBloc>(
          create: (context) => LocalUrlTextFieldBloc(),
        ),
        BlocProvider<RemoteUrlTextFieldBloc>(
          create: (context) => RemoteUrlTextFieldBloc(),
        ),
        BlocProvider<UrlUpdateBloc>(
          create: (context) => UrlUpdateBloc(
            BlocProvider.of<LocalUrlTextFieldBloc>(context),
            BlocProvider.of<RemoteUrlTextFieldBloc>(context),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _UrlUpdateTitle(),
        const SizedBox(
          height: 24,
        ),
        _UrlsForm(),
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

class _UrlsForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UrlsFormState();
}

class _UrlsFormState extends State<_UrlsForm> {
  final FocusNode _localUrlFocus = FocusNode();
  final FocusNode _remoteUrlFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _localUrlFocus.addListener(() {
      if (!_localUrlFocus.hasFocus) {
        context.read<LocalUrlTextFieldBloc>().add(UrlUnfocused());
      }
    });

    _remoteUrlFocus.addListener(() {
      if (!_remoteUrlFocus.hasFocus) {
        context.read<RemoteUrlTextFieldBloc>().add(UrlUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _localUrlFocus.dispose();
    _remoteUrlFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LocalUrlTextTextField(_localUrlFocus),
        _RemoteUrlTextTextField(_remoteUrlFocus),
      ],
    );
  }
}

class _LocalUrlTextTextField extends StatelessWidget {
  final FocusNode focusNode;

  const _LocalUrlTextTextField(this.focusNode);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<LocalUrlTextFieldBloc>(context),
      child: BlocListener<LocalUrlTextFieldBloc, UrlTextFieldState>(
        listenWhen: (previous, current) => previous.url != current.url,
        listener: (context, state) => context
            .read<UrlUpdateBloc>()
            .add(LocalUrlChanged(url: state.url.value.trim())),
        child: UrlTextField<LocalUrlTextFieldBloc>(
          focusNode: focusNode,
          labelText: HomsaiLocalizations.of(context)!.localUrlLabel,
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }
}

class _RemoteUrlTextTextField extends StatelessWidget {
  final FocusNode focusNode;

  const _RemoteUrlTextTextField(this.focusNode);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<RemoteUrlTextFieldBloc>(context),
      child: BlocListener<RemoteUrlTextFieldBloc, UrlTextFieldState>(
        listenWhen: (previous, current) => previous.url != current.url,
        listener: (context, state) => context
            .read<UrlUpdateBloc>()
            .add(RemoteUrlChanged(url: state.url.value)),
        child: UrlTextField<RemoteUrlTextFieldBloc>(
          focusNode: focusNode,
          labelText: HomsaiLocalizations.of(context)!.remoteUrlLabel,
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }
}

class _UrlUpdateSave extends StatelessWidget {
  final void Function(bool) onResult;
  final bool wizard;

  const _UrlUpdateSave(this.onResult, this.wizard);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlUpdateBloc, UrlUpdateState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.status.isValid
                ? () {
                    context.read<UrlUpdateBloc>().add(UrlSubmitted(
                        onSubmit: () => wizard
                            ? context.router.replace(
                                AddPlantRoute(
                                  onResult: onResult,
                                ),
                              )
                            : onResult(true)));
                  }
                : null,
            child: Text(HomsaiLocalizations.of(context)!.next),
          );
        });
  }
}
