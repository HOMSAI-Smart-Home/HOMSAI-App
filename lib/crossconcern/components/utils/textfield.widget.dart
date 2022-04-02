import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:homsai/crossconcern/components/utils/credentials_form/bloc/credentials_form.bloc.dart';
import 'package:rive/rive.dart';

class EmailAddressTextField extends StatelessWidget {
  const EmailAddressTextField({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialsFormBloc, CredentialsFormState>(
        builder: (context, state) {
      return TextFormField(
        restorationId: 'emailaddress_text_field',
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          context.read<CredentialsFormBloc>().add(EmailChanged(email: value));
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email_rounded,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          labelText: HomsaiLocalizations.of(context)!.emailAddress,
          errorText: state.email.invalid ? 'invalid email' : null,
        ),
        style: Theme.of(context).textTheme.subtitle2,
      );
    });
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isPasswordSecure = true;

  @override
  void initState() {
    super.initState();
  }

  void _toggleVisibility() => setState(() {
        isPasswordSecure = !isPasswordSecure;
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialsFormBloc, CredentialsFormState>(
        builder: (context, state) {
      return TextFormField(
        restorationId: 'password_text_field',
        initialValue: state.password.value,
        focusNode: widget.focusNode,
        obscureText: isPasswordSecure,
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          context
              .read<CredentialsFormBloc>()
              .add(PasswordChanged(password: value));
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_rounded,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          suffixIcon: VisibilityIcon(
            onPressed: _toggleVisibility,
          ),
          errorText: state.password.invalid ? 'invalid password' : null,
          labelText: HomsaiLocalizations.of(context)!.password,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      );
    });
  }
}

class VisibilityIcon extends StatefulWidget {
  const VisibilityIcon({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;

  @override
  State<VisibilityIcon> createState() => _VisibilityIconState();
}

class _VisibilityIconState extends State<VisibilityIcon> {
  SMIInput<bool>? _visibility;
  void _toggleVisibility() => setState(() {
        if (_visibility != null) {
          _visibility!.value = !(_visibility!.value);
        }
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      });

  void _onVisibilityInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'toggle');
    if (controller != null) {
      artboard.addController(controller);
      _visibility = controller.findInput<bool>('visible');
      _visibility?.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onBackground,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: IconButton(
          icon: RiveAnimation.asset(
            "assets/animations/visibility.riv",
            onInit: _onVisibilityInit,
          ),
          iconSize: 18,
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
