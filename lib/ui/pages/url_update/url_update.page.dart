import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/bloc/url_text_field.bloc.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/url_text_field.widget.dart';
import 'package:homsai/ui/pages/url_update/bloc/url_update.bloc.dart';

class UrlUpdatePage extends StatefulWidget {
  const UrlUpdatePage({Key? key}) : super(key: key);

  @override
  State<UrlUpdatePage> createState() => _UrlUpdatePageState();
}

class _UrlUpdatePageState extends State<UrlUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<LocalUrlTextFieldBlock>(
          create: (context) => LocalUrlTextFieldBlock(),
        ),
        BlocProvider<RemoteUrlTextFieldBlock>(
          create: (context) => RemoteUrlTextFieldBlock(),
        ),
        BlocProvider<UrlUpdateBloc>(
          create: (context) => UrlUpdateBloc(
            BlocProvider.of<LocalUrlTextFieldBlock>(context),
            BlocProvider.of<RemoteUrlTextFieldBlock>(context),
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
        _UrlUpdateSave(),
      ],
    );
  }
}

class _UrlUpdateTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(HomsaiLocalizations.of(context)!.addPlantTitle,
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
        context.read<LocalUrlTextFieldBlock>().add(UrlUnfocused());
      }
    });

    _remoteUrlFocus.addListener(() {
      if (!_localUrlFocus.hasFocus) {
        context.read<RemoteUrlTextFieldBlock>().add(UrlUnfocused());
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
    return BlocBuilder<UrlUpdateBloc, UrlUpdateState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return UrlTextField(
          focusNode: focusNode,
          labelText: "Inserisci l'Url locale",
        );
      },
    );
  }
}

class _RemoteUrlTextTextField extends StatelessWidget {
  final FocusNode focusNode;

  const _RemoteUrlTextTextField(this.focusNode);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlUpdateBloc, UrlUpdateState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return UrlTextField(
          focusNode: focusNode,
          labelText: "Inserisci l'Url remoto",
        );
      },
    );
  }
}

class _UrlUpdateSave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<UrlUpdateBloc>().add(UrlSubmitted(
              onSubmit: () => context.router.pop(),
            ));
      },
      child: Text(HomsaiLocalizations.of(context)!.next),
    );
  }
}
