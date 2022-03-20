import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homsai/routes.dart';
import 'package:homsai/themes/card.theme.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:homsai/ui/pages/scan/bloc/home_assistant_scan.bloc.dart';
import 'package:homsai/ui/widget/radio.widget.dart';
import 'package:rive/rive.dart';
import 'package:super_rich_text/super_rich_text.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

class HomeAssistantScanPage extends StatefulWidget {
  const HomeAssistantScanPage({Key? key}) : super(key: key);

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/icons/full_logo.svg", height: 20),
                const SizedBox(height: 32),
                _HomeAssistantScanDialog(),
                const SizedBox(height: 40),
                BlocProvider(
                  create: (_) => HomeAssistantScanBloc(),
                  child: const _SearchLocalInstance(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeAssistantScanDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.wifi_rounded),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        HomsaiLocalizations.of(context)!
                            .homeAssistantScanDialogTitle,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const SizedBox(height: 9),
                    SuperRichText(
                      text: HomsaiLocalizations.of(context)!
                          .homeAssistantScanDialogMessage,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      data: HomsaiCardTheme.confirmTheme(Theme.of(context)),
    );
  }
}

class _SearchLocalInstance extends StatefulWidget {
  const _SearchLocalInstance({Key? key}) : super(key: key);

  @override
  _SearchLocalInstanceState createState() => _SearchLocalInstanceState();
}

class _SearchLocalInstanceState extends State<_SearchLocalInstance> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<HomeAssistantScanBloc>(context).add(ScanPressed());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          HomsaiLocalizations.of(context)!.homeAssistantScanTitle,
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(
          height: 12,
        ),
        _SearchLocalInstanceContainer(),
        const SizedBox(
          height: 12,
        ),
        _SearchLocalIntanceButtons()
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
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: 222,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final inAnimation =
                  Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(animation);
              final outAnimation =
                  Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(animation);

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
            },
            child: getChildByStatus(state.status),
          ),
        );
      },
    );
  }

  Widget? getChildByStatus(HomeAssistantScanStatus status) {
    switch (status) {
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
  SMIInput<bool>? _error;

  void _onHouglassInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'spin');
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
        child: RiveAnimation.asset(
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
        buildWhen: (previous, current) =>
            previous.selectedUrl != current.selectedUrl,
        builder: (context, state) {
          return ListView.separated(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 24),
            itemCount: state.scannedUrls.length,
            itemBuilder: (BuildContext context, int index) =>
                _SearchLocalIntanceItemList(url: state.scannedUrls[index]),
          );
        });
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
                    child: HomsaiRadio(
                      value: url == state.selectedUrl.value,
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
        SuperRichText(
          text: HomsaiLocalizations.of(context)!.homeAssistantScanManualHint,
          style: Theme.of(context).textTheme.subtitle1,
          useGlobalMarkers: false,
          othersMarkers: [
            MarkerText(
                marker: '*',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        )
      ],
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
              prefixIcon: Icon(
                Icons.link,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              errorText: state.status.isAuthenticationFailure
                  ? HomsaiLocalizations.of(context)!
                      .homeAssistantScanManualAuthError
                  : state.selectedUrl.invalid
                      ? HomsaiLocalizations.of(context)!
                          .homeAssistantScanManualError
                      : null,
              labelText:
                  HomsaiLocalizations.of(context)!.homeAssistantScanManualLabel,
            ),
            style: Theme.of(context).textTheme.subtitle2,
          ));
    });
  }
}

class _SearchLocalIntanceButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _ContinueRetryButton(),
            const SizedBox(height: 24),
            if (!state.status.isScanningInProgress) _ManualUrlButton()
          ],
        );
      },
    );
  }
}

class _ContinueRetryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeAssistantScanBloc, HomeAssistantScanState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isAuthenticationSuccess) {
          Navigator.popAndPushNamed(context, RouteConfiguration.addImplant);
        }
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
                    ? () =>
                        context.read<HomeAssistantScanBloc>().add(ScanPressed())
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAssistantScanBloc, HomeAssistantScanState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return OutlinedButton(
          onPressed: state.status.isScanningComplete
              ? () =>
                  context.read<HomeAssistantScanBloc>().add(ManualUrlPressed())
              : state.status.isManual
                  ? () =>
                      context.read<HomeAssistantScanBloc>().add(ScanPressed())
                  : null,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              state.status.isManual
                  ? HomsaiLocalizations.of(context)!.homeAssistantScanLabel
                  : HomsaiLocalizations.of(context)!
                      .homeAssistantScanManualLabel,
              key: ValueKey(state.status.isManual),
            ),
          ),
        );
      },
    );
  }
}
