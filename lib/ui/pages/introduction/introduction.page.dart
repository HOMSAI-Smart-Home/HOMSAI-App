import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_scaffold.widget.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:super_rich_text/super_rich_text.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

class IntroductionPage extends StatefulWidget {
  final void Function(bool) onResult;
  final int page;

  const IntroductionPage({Key? key, required this.onResult, this.page = 1})
      : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    return HomsaiScaffold(
      resizeToAvoidBottomInset: true,
      padding: EdgeInsets.zero,
      child: _Steps(widget.onResult, widget.page),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HomsaiColors.primaryGreen,
          systemNavigationBarColor: Theme.of(context).colorScheme.background,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: HomsaiColors.primaryGreen,
        title: Row(children: [
          const Spacer(),
          SvgPicture.asset("assets/icons/full_logo.svg", height: 20),
          const Spacer()
        ]),
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  final int page;
  final void Function(bool) onResult;

  const _Steps(this.onResult, this.page);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xff56bb76),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Padding(
                child: SvgPicture.asset(_GetTextFromPage.imgPath(page),
                    height: 188),
                padding: const EdgeInsets.only(top: 16, bottom: 16),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        Shadow(
          child: SvgPicture.asset(
            "assets/icons/banner.svg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          offset: const Offset(0, 5),
        ),
        _TextPadding(onResult, page),
        Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff56bb76))),
              onPressed: () => onResult(true),
              child: Column(children: [
                Text(HomsaiLocalizations.of(context)!.introductionSkip),
                const SizedBox(
                  height: 10,
                )
              ]),
            ))
      ],
    );
  }
}

class _TextPadding extends StatelessWidget {
  final int page;
  final void Function(bool) onResult;

  const _TextPadding(this.onResult, this.page);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: [
              Text(
                _GetTextFromPage.getTitle(page, context),
                style: const TextStyle(
                    color: Color(0xffffffff),
                    fontFamily: 'JoyrideExtended',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 22),
              )
            ]),
            const SizedBox(
              height: 13,
            ),
            Row(children: [
              _HomeAssistantSuperRichText(
                  _GetTextFromPage.firstText(page, context))
            ]),
            const SizedBox(
              height: 11,
            ),
            Row(children: [
              _HomeAssistantSuperRichText(
                  _GetTextFromPage.secondText(page, context))
            ]),
            const SizedBox(
              height: 21,
            ),
            _NextButtonInfo(onResult, page)
          ],
        ));
  }
}

class _GetTextFromPage {
  static String getTitle(int page, BuildContext context) {
    switch (page) {
      case 1:
        return HomsaiLocalizations.of(context)!.introductionTitle1;
      case 2:
        return HomsaiLocalizations.of(context)!.introductionTitle2;
      case 3:
        return HomsaiLocalizations.of(context)!.introductionTitle3;
    }
    return '';
  }

  static String firstText(int page, BuildContext context) {
    switch (page) {
      case 1:
        return HomsaiLocalizations.of(context)!.introductionFirstText1;
      case 2:
        return HomsaiLocalizations.of(context)!.introductionFirstText2;
      case 3:
        return HomsaiLocalizations.of(context)!.introductionFirstText3;
    }
    return '';
  }

  static String secondText(int page, BuildContext context) {
    switch (page) {
      case 1:
        return HomsaiLocalizations.of(context)!.introductionSecondText1;
      case 2:
        return HomsaiLocalizations.of(context)!.introductionSecondText2;
      case 3:
        return HomsaiLocalizations.of(context)!.introductionSecondText3;
    }
    return '';
  }

  static String buttonText(int page, BuildContext context) {
    switch (page) {
      case 1:
        return HomsaiLocalizations.of(context)!.introductionButtonText1;
      case 2:
        return HomsaiLocalizations.of(context)!.introductionButtonText2;
      case 3:
        return HomsaiLocalizations.of(context)!.introductionButtonText3;
    }
    return '';
  }

  static String imgPath(int page) {
    switch (page) {
      case 1:
        return 'assets/icons/welcome_banner.svg';
      case 2:
        return 'assets/icons/access_banner.svg';
      case 3:
        return 'assets/icons/comfort_banner.svg';
    }
    return '';
  }
}

class _NextButtonInfo extends StatelessWidget {
  final int page;
  final void Function(bool) onResult;

  const _NextButtonInfo(this.onResult, this.page);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _NextButton(onResult, page),
        const SizedBox(height: 21),
        _InfoPage(page)
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final int page;
  final void Function(bool) onResult;

  const _NextButton(this.onResult, this.page);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        page < 3
            ? context.router.push(
                IntroductionRoute(
                  onResult: onResult,
                  page: page + 1,
                ),
              )
            : onResult(true);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Text(_GetTextFromPage.buttonText(page, context),
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'HelveticaNowText',
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _InfoPage extends StatelessWidget {
  final int page;

  const _InfoPage(this.page);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
          HomsaiLocalizations.of(context)!
              .introductionPageInfo
              .replaceFirst('%1', page.toString()),
          style: const TextStyle(
              fontSize: 16,
              fontFamily: 'HelveticaNowText',
              fontWeight: FontWeight.w300)),
    ));
  }
}

class _HomeAssistantSuperRichText extends StatelessWidget {
  final String text;

  const _HomeAssistantSuperRichText(this.text);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: SuperRichText(
      text: text,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          fontFamily: 'HelveticaNowText'),
      othersMarkers: [
        MarkerText(
            marker: '*/', style: const TextStyle(fontWeight: FontWeight.w700)),
        MarkerText.withUrl(
            marker: 'l1',
            urls: ["https://www.home-assistant.io"],
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline)),
        MarkerText.withUrl(
            marker: 'l2',
            urls: ['https://homsai.app'],
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline)),
      ],
    ));
  }
}
