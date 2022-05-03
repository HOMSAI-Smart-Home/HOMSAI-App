import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox.widget.dart';
import 'package:homsai/crossconcern/components/common/checkbox/checkbox_bloc.widget.dart';
import 'package:homsai/crossconcern/components/common/radio.widget.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_bloc_scaffold.widget.dart';
import 'package:homsai/globalkeys.widget.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/scan/bloc/home_assistant_scan.bloc.dart';
import 'package:homsai/crossconcern/components/alerts/alert.widget.dart';
import 'package:rive/rive.dart' as rive;
import 'package:super_rich_text/super_rich_text.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

class HomeAssistantScanPage extends StatefulWidget {
  final void Function(bool) onResult;

  const HomeAssistantScanPage({Key? key, required this.onResult})
      : super(key: key);

  @override
  State<HomeAssistantScanPage> createState() => _HomeAssistantScanPage();
}

class _HomeAssistantScanPage extends State<HomeAssistantScanPage> {
  late Image homeAssistanLogo;

  @override
  void initState() {
    super.initState();
    homeAssistanLogo = Image.asset(
      "assets/icons/home_assistant.png",
      height: 32,
      width: 32,
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(homeAssistanLogo.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return HomsaiBlocScaffold(
      providers: [
        BlocProvider<CheckboxBloc>(
          create: (_) => CheckboxBloc(false),
        ),
        BlocProvider<HomeAssistantScanBloc>(
          create: (context) =>
              HomeAssistantScanBloc(context.read<CheckboxBloc>()),
        ),
      ],
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 8,
        left: 8,
        right: 8,
      ),
      children: <Widget>[
        _HomeAssistantScanDialog(),
        const SizedBox(height: 40),
        _SearchLocalInstance(onResult: widget.onResult)
      ],
    );
  }
}

class _HomeAssistantScanDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Alert(
      AlertType.tips,
      icon: const Icon(Icons.wifi_rounded),
      title: Text(
        HomsaiLocalizations.of(context)!.homeAssistantScanDialogTitle,
        style: Theme.of(context).textTheme.headline4,
      ),
      message: SuperRichText(
        text: HomsaiLocalizations.of(context)!.homeAssistantScanDialogMessage,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      cancelable: false,
    );
  }
}

class _SearchLocalInstance extends StatefulWidget {
  final void Function(bool) onResult;

  const _SearchLocalInstance({Key? key, required this.onResult})
      : super(key: key);

  @override
  _SearchLocalInstanceState createState() => _SearchLocalInstanceState();
}

class _SearchLocalInstanceState extends State<_SearchLocalInstance> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          HomsaiLocalizations.of(context)!.homeAssistantScanTitle,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          height: 12,
        ),
        _SearchLocalInstanceContainer(),
        const SizedBox(
          height: 12,
        ),
        _SearchLocalIntanceButtons(widget.onResult)
      ],
    );
  }
}

class _SearchLocalInstanceContainer extends StatefulWidget {
  @override
  State<_SearchLocalInstanceContainer> createState() =>
      _SearchLocalInstanceContainerState();
}

class _SearchLocalInstanceContainerState
    extends State<_SearchLocalInstanceContainer> {
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.scannedUrls.length != current.scannedUrls.length,
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

  Widget? buildChildByStatus(HomeAssistantScanState state) {
    switch (state.status) {
      case HomeAssistantScanStatus.scanningInProgress:
        child = _SearchLocalIntanceScanning(
          key: UniqueKey(),
        );
        break;
      case HomeAssistantScanStatus.scanningSuccess:
        child = _SearchLocalIntanceListResults(
          key: UniqueKey(),
        );
        break;
      case HomeAssistantScanStatus.manual:
        if (child is! _SearchLocalIntanceManual) {
          child = _SearchLocalIntanceManual(
            key: UniqueKey(),
          );
        }
        break;
      default:
        child ??= _SearchLocalIntanceScanning(
          key: UniqueKey(),
        );
    }
    return child;
  }

  Widget buildTransition(Widget child, Animation<double> animation) {
    final inAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation);
    final outAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation);

    if (child.key == this.child?.key) {
      return ClipRect(
        child: SlideTransition(
          position: inAnimation,
          child: child,
        ),
      );
    } else {
      return ClipRect(
        child: SlideTransition(
          position: outAnimation,
          child: child,
        ),
      );
    }
  }
}

class _SearchLocalIntanceScanning extends StatelessWidget {
  const _SearchLocalIntanceScanning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const _HourglassIcon(),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    state.status.isScanningFailure
                        ? HomsaiLocalizations.of(context)!
                            .homeAssistantScanningError
                        : HomsaiLocalizations.of(context)!
                            .homeAssistantScanningProgress,
                    key: ValueKey(state.status),
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: state.status.isScanningFailure
                            ? Theme.of(context).colorScheme.error
                            : HomsaiColors.primaryGrey),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}

class _HourglassIcon extends StatefulWidget {
  const _HourglassIcon({Key? key}) : super(key: key);

  @override
  _HourglassIconState createState() => _HourglassIconState();
}

class _HourglassIconState extends State<_HourglassIcon> {
  rive.SMIInput<bool>? _error;

  void _onHouglassInit(rive.Artboard artboard) {
    final controller =
        rive.StateMachineController.fromArtboard(artboard, 'spin');
    if (controller != null) {
      artboard.addController(controller);
      _error = controller.findInput<bool>('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeAssistantScanBloc, HomeAssistantScanState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        _error?.value = state.status.isScanningFailure;
      },
      child: SizedBox(
        width: 48,
        height: 48,
        child: rive.RiveAnimation.asset(
          "assets/animations/hourglass.riv",
          stateMachines: const [''],
          onInit: _onHouglassInit,
        ),
      ),
    );
  }
}

class _SearchLocalIntanceListResults extends StatelessWidget {
  const _SearchLocalIntanceListResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
        builder: (context, state) {
      return ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Colors.transparent,
              Colors.transparent,
              Theme.of(context).colorScheme.background,
            ],
            stops: const [0.0, 0.05, 0.95, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: AnimatedList(
            key: GlobalKeys.scannedUrlsAnimatedList,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            initialItemCount: state.scannedUrls.length,
            itemBuilder: (context, index, animation) {
              if (state.scannedUrls.isNotEmpty) {
                return slideIn(context, state.scannedUrls[index], animation);
              }
              return const SizedBox.shrink();
            }),
      );
    });
  }

  Widget slideIn(BuildContext context, String url, animation) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _SearchLocalIntanceItemList(url: url),
        ));
  }
}

class _SearchLocalIntanceItemList extends StatelessWidget {
  final String url;

  const _SearchLocalIntanceItemList({Key? key, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
        buildWhen: (previous, current) =>
            previous.selectedUrl != current.selectedUrl,
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: url == state.selectedUrl.value
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Theme.of(context).colorScheme.surface,
                onPrimary: Theme.of(context).colorScheme.onBackground,
                fixedSize: const Size.fromHeight(50),
                padding: const EdgeInsets.all(0)),
            onPressed: () {
              context.read<HomeAssistantScanBloc>().add(UrlSelected(url: url));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              alignment: Alignment.center,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        "assets/icons/home_assistant.png",
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(url),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: RadioButton(
                      key: ValueKey(url == state.selectedUrl.value),
                      initialValue: url == state.selectedUrl.value,
                      onChanged: (changed) {},
                      clickable: false,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class _SearchLocalIntanceManual extends StatelessWidget {
  const _SearchLocalIntanceManual({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _SearchLocalIntanceManualTextField(),
        const SizedBox(
          height: 8,
        ),
        _SearchLocalIntanceManualCheckbox(),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class _SearchLocalIntanceManualCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        child: Row(
          children: [
            const CheckboxButton(initialValue: false),
            const SizedBox(
              width: 8,
            ),
            Text(
              HomsaiLocalizations.of(context)!.homeAssistantScanManualCheckbox,
              style: Theme.of(context).textTheme.bodyText1!,
            ),
          ],
        ),
      ),
      onTap: () =>
          context.read<HomeAssistantScanBloc>().add(ManualToggleRemote()),
    );
  }
}

class _SearchLocalIntanceManualTextField extends StatefulWidget {
  @override
  State<_SearchLocalIntanceManualTextField> createState() =>
      _SearchLocalIntanceManualTextFieldState();
}

class _SearchLocalIntanceManualTextFieldState
    extends State<_SearchLocalIntanceManualTextField> {
  final FocusNode _urlFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _urlFocusNode.addListener(() {
      if (!_urlFocusNode.hasFocus) {
        context.read<HomeAssistantScanBloc>().add(ManualUrlUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _urlFocusNode.dispose();
    super.dispose();
  }

  Color _color(BuildContext context, HomeAssistantScanState state) {
    return (state.selectedUrl.invalid || state.status.isAuthenticationFailure)
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onBackground;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
        builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextFormField(
            restorationId: 'manual_url_text_field',
            initialValue: state.selectedUrl.value,
            focusNode: _urlFocusNode,
            keyboardType: TextInputType.url,
            onChanged: (value) {
              context
                  .read<HomeAssistantScanBloc>()
                  .add(ManualUrlChanged(url: value));
            },
            enabled: !state.status.isAuthenticationInProgress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.link, color: _color(context, state)),
              errorText: state.status.isAuthenticationFailure
                  ? HomsaiLocalizations.of(context)!
                      .homeAssistantScanManualAuthError
                  : state.selectedUrl.invalid
                      ? HomsaiLocalizations.of(context)!
                          .homeAssistantScanManualError
                      : null,
              labelText: HomsaiLocalizations.of(context)!.urlLabel,
            ),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ));
    });
  }
}

class _SearchLocalIntanceButtons extends StatelessWidget {
  final void Function(bool) onResult;

  const _SearchLocalIntanceButtons(this.onResult);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _ContinueRetryButton(onResult),
            const SizedBox(height: 24),
            _ManualUrlButton()
          ],
        );
      },
    );
  }
}

class _ContinueRetryButton extends StatelessWidget {
  final void Function(bool) onResult;

  const _ContinueRetryButton(this.onResult);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeAssistantScanBloc, HomeAssistantScanState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status.isAuthenticationSuccess,
      listener: (context, state) {
        context.router.replace(
          AddPlantRoute(
            onResult: onResult,
            url: Uri.parse(state.selectedUrl.value),
            remote: state.remoteUrl,
          ),
        );
      },
      child: BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.selectedUrl.value != current.selectedUrl.value,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: (state.status.canSubmitUrl && state.selectedUrl.valid)
                ? () =>
                    context.read<HomeAssistantScanBloc>().add(UrlSubmitted())
                : state.status.isScanningFailure
                    ? () => context
                        .read<HomeAssistantScanBloc>()
                        .add(const ScanPressed())
                    : null,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buttonLabel(context, state.status),
            ),
          );
        },
      ),
    );
  }

  Widget _buttonLabel(BuildContext context, HomeAssistantScanStatus status) {
    return status.isAuthenticationInProgress
        ? Center(
            key: ValueKey(status.isAuthenticationInProgress),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          )
        : Text(
            status.isScanningFailure
                ? HomsaiLocalizations.of(context)!.retry
                : HomsaiLocalizations.of(context)!.next,
            key: ValueKey(status.isScanningFailure));
  }
}

class _ManualUrlButton extends StatelessWidget {
  void Function()? onPressed(
      BuildContext context, HomeAssistantScanState state) {
    return state.status.isManual
        ? () => context.read<HomeAssistantScanBloc>().add(const ScanPressed())
        : () => context.read<HomeAssistantScanBloc>().add(ManualUrlPressed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return OutlinedButton(
          onPressed: onPressed(context, state),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              state.status.isManual
                  ? HomsaiLocalizations.of(context)!.homeAssistantScanLabel
                  : HomsaiLocalizations.of(context)!.urlLabel,
              key: ValueKey(state.status.isManual),
            ),
          ),
        );
      },
    );
  }
}
