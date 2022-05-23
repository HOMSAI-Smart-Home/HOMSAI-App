import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/bloc/url_text_field.bloc.dart';
import 'package:homsai/crossconcern/components/utils/url_text_field/url_text_field.widget.dart';

class DoubleUrl extends StatelessWidget {
  const DoubleUrl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalUrlTextFieldBloc>(
          create: (context) => LocalUrlTextFieldBloc(),
        ),
        BlocProvider<RemoteUrlTextFieldBloc>(
          create: (context) => RemoteUrlTextFieldBloc(),
        ),
        BlocProvider.value(
          value: BlocProvider.of<DoubleUrlBloc>(context),
        ),
      ],
      child: _DoubleUrl(),
    );
  }
}

class _DoubleUrl extends StatefulWidget {
  @override
  State<_DoubleUrl> createState() => _DoubleUrlState();
}

class _DoubleUrlState extends State<_DoubleUrl> {
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
        _LocalUrlTextField(_localUrlFocus),
        _RemoteUrlTextField(_remoteUrlFocus),
      ],
    );
  }
}

class _LocalUrlTextField extends StatelessWidget {
  final FocusNode focusNode;

  const _LocalUrlTextField(this.focusNode);

  @override
  Widget build(BuildContext context) {
    context.read<DoubleUrlBloc>().initializeBlocs(
          localUrlTextFieldBloc:
              BlocProvider.of<LocalUrlTextFieldBloc>(context),
        );
    return UrlTextField<LocalUrlTextFieldBloc>(
      focusNode: focusNode,
      labelText: HomsaiLocalizations.of(context)!.localUrlLabel,
      textInputAction: TextInputAction.next,
      onChange: (url) =>
          context.read<DoubleUrlBloc>().add(DoubleUrlLocalUrlChanged(url: url)),
    );
  }
}

class _RemoteUrlTextField extends StatelessWidget {
  final FocusNode focusNode;

  const _RemoteUrlTextField(this.focusNode);

  @override
  Widget build(BuildContext context) {
    context.read<DoubleUrlBloc>().initializeBlocs(
          remoteUrlTextFieldBloc:
              BlocProvider.of<RemoteUrlTextFieldBloc>(context),
        );
    return UrlTextField<RemoteUrlTextFieldBloc>(
      focusNode: focusNode,
      labelText: HomsaiLocalizations.of(context)!.remoteUrlLabel,
      onChange: (url) => context
          .read<DoubleUrlBloc>()
          .add(DoubleUrlRemoteUrlChanged(url: url)),
    );
  }
}
