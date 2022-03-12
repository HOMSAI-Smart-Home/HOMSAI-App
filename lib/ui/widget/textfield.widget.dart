import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:rive/rive.dart';

class EmailAddressTextField extends StatelessWidget {
  const EmailAddressTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      restorationId: 'emailaddress_text_field',
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email_rounded,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        labelText: HomsaiLocalizations.of(context)!.emailAddress,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextField();
}

class _PasswordTextField extends State<PasswordTextField> {
  bool isPasswordSecure = true;

  void _toggleVisibility() => setState(() {
        isPasswordSecure = !isPasswordSecure;
        _visibility?.value = isPasswordSecure;
      });

  SMIInput<bool>? _visibility;

  @override
  void initState() {
    super.initState();
  }

  void _onVisibilityInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'toggle');
    if (controller != null) {
      artboard.addController(controller);
      _visibility = controller.findInput<bool>('visibile');
      _visibility?.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      restorationId: 'password_text_field',
      obscureText: isPasswordSecure,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_rounded,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        suffixIcon: Material(
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
              onPressed: _toggleVisibility,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        labelText: HomsaiLocalizations.of(context)!.password,
        labelStyle: Theme.of(context).textTheme.subtitle2,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
