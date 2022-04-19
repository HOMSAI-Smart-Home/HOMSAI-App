import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/ui/pages/intro_beta/bloc/intro_beta.bloc.dart';
import 'package:super_rich_text/super_rich_text.dart';
import 'package:rive/rive.dart' as rive;

class IntroBetaPage extends StatefulWidget {
  final void Function(bool) onResult;

  const IntroBetaPage({Key? key, required this.onResult}) : super(key: key);

  @override
  State<IntroBetaPage> createState() => _IntroBetaPageState();
}

class _IntroBetaPageState extends State<IntroBetaPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<IntroBetaBloc>(
          create: (_) => IntroBetaBloc(),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      resizeToAvoidBottomInset: false,
      children: <Widget>[
        _IntroBetaContainer(),
        const SizedBox(height: 16),
        _IntroBetaSubmit(widget.onResult),
      ],
    );
  }
}

class _IntroBetaContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntroBetaContainerState();
}

class _IntroBetaContainerState extends State<_IntroBetaContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBetaBloc, IntroBetaState>(
      buildWhen: (previous, current) =>
          previous.introBetaStatus != current.introBetaStatus &&
          current.introBetaStatus != IntroBetaStatus.loading,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: 222,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: buildTransition,
            child: buildChildByStatus(state),
          ),
        );
      },
    );
  }

  Widget? buildChildByStatus(IntroBetaState state) {
    switch (state.introBetaStatus) {
      case IntroBetaStatus.emailEntry:
        return _EmailEntry(
          key: UniqueKey(),
        );
      case IntroBetaStatus.pending:
        return _Pending(
          key: UniqueKey(),
        );
      case IntroBetaStatus.notRegistered:
        return _NotRegistered(
          key: UniqueKey(),
        );
      default:
        return _EmailEntry(
          key: UniqueKey(),
        );
    }
  }

  Widget buildTransition(Widget child, Animation<double> animation) {
    final inAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation);

    return ClipRect(
      child: SlideTransition(
        position: inAnimation,
        child: child,
      ),
    );
  }
}

class _EmailEntry extends StatelessWidget {
  const _EmailEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _IntroBetaTitle(
          title: HomsaiLocalizations.of(context)!.emailEntryTitle,
        ),
        _IntroBetaDescription(
          description: HomsaiLocalizations.of(context)!.emailEntryDescription,
        ),
        const SizedBox(height: 16),
        _IntroBetaForm(),
      ],
    );
  }
}

class _Pending extends StatelessWidget {
  const _Pending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const _IntroBetaIcon(isPending: true),
        const SizedBox(height: 16),
        _IntroBetaTitle(
          title: HomsaiLocalizations.of(context)!.emailPendingTitle,
        ),
        _IntroBetaDescription(
          description: HomsaiLocalizations.of(context)!.emailPendingDescription,
        ),
      ],
    );
  }
}

class _NotRegistered extends StatelessWidget {
  const _NotRegistered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBetaBloc, IntroBetaState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _IntroBetaIcon(isPending: false),
          const SizedBox(height: 16),
          _IntroBetaTitle(
            title: HomsaiLocalizations.of(context)!.emailNotRegisteredTitle,
          ),
          _IntroBetaDescription(
            description: HomsaiLocalizations.of(context)!
                .emailNotRegisteredDescription
                .replaceFirst('{}', state.email.value),
          ),
        ],
      );
    });
  }
}

class _IntroBetaIcon extends StatelessWidget {
  final bool isPending;

  const _IntroBetaIcon({Key? key, required this.isPending}) : super(key: key);

  void _onHouglassInit(rive.Artboard artboard) {
    final controller =
        rive.StateMachineController.fromArtboard(artboard, 'spin');
    if (controller != null) {
      artboard.addController(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 48,
        height: 48,
        child: isPending
            ? rive.RiveAnimation.asset(
                "assets/animations/hourglass.riv",
                stateMachines: const [''],
                onInit: _onHouglassInit,
              )
            : SvgPicture.asset("assets/icons/error.svg"));
  }
}

class _IntroBetaTitle extends StatelessWidget {
  final String title;

  const _IntroBetaTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class _IntroBetaDescription extends StatelessWidget {
  final String description;

  const _IntroBetaDescription({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SuperRichText(
          text: description,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class _IntroBetaForm extends StatefulWidget {
  @override
  State<_IntroBetaForm> createState() => _IntroBetaFormState();
}

class _IntroBetaFormState extends State<_IntroBetaForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[_EmailAddressTextField()],
    );
  }
}

class _EmailAddressTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBetaBloc, IntroBetaState>(
        buildWhen: (previous, current) =>
            previous.email != current.email ||
            previous.initialEmail != current.initialEmail,
        builder: (context, state) {
          return TextFormField(
            key: ValueKey(
              state.initialEmail,
            ),
            restorationId: 'emailaddress_text_field',
            initialValue: state.initialEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              context.read<IntroBetaBloc>().add(EmailChanged(email: value));
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              labelText: HomsaiLocalizations.of(context)!.emailAddress,
              errorText: state.email.invalid
                  ? HomsaiLocalizations.of(context)!.invalidEmail
                  : null,
            ),
            style: Theme.of(context).textTheme.bodyText1,
          );
        });
  }
}

class _IntroBetaSubmit extends StatelessWidget {
  final void Function(bool) onResult;

  const _IntroBetaSubmit(this.onResult);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBetaBloc, IntroBetaState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.introBetaStatus != current.introBetaStatus,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.status.isValid
                ? () => context
                    .read<IntroBetaBloc>()
                    .add(OnSubmit(() => onResult(true)))
                : null,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buttonLabel(context, state),
            ),
          );
        });
  }

  Widget _buttonLabel(BuildContext context, IntroBetaState state) {
    return state.introBetaStatus == IntroBetaStatus.loading
        ? Center(
            key: ValueKey(state.introBetaStatus),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          )
        : Text(
            () {
              switch (state.introBetaStatus) {
                case IntroBetaStatus.emailEntry:
                  return HomsaiLocalizations.of(context)!.next;
                case IntroBetaStatus.loading:
                  return HomsaiLocalizations.of(context)!.next;
                case IntroBetaStatus.pending:
                  return HomsaiLocalizations.of(context)!.retry;
                case IntroBetaStatus.notRegistered:
                  return HomsaiLocalizations.of(context)!.emailSubmitError;
                default:
                  return "";
              }
            }() as String,
            key: ValueKey(state.introBetaStatus));
  }
}
