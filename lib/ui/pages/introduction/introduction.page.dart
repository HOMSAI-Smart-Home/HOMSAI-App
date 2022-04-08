import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_scaffold.widget.dart';
import 'package:homsai/crossconcern/components/utils/shadow.widget.dart';
import 'package:homsai/themes/colors.theme.dart';
import 'package:super_rich_text/super_rich_text.dart';

class IntroductionPage extends StatefulWidget {
  final int page;

  const IntroductionPage({Key? key, this.page = 1}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _Body(widget.page));
  }
}

class _Body extends StatelessWidget {
  final int page;

  const _Body(this.page);

  @override
  Widget build(BuildContext context) {
    return HomsaiScaffold(
      resizeToAvoidBottomInset: true,
      padding: EdgeInsets.zero,
      child: _Steps(page),
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

  const _Steps(this.page);

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
        _TextPadding(page),
        Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff56bb76))),
              onPressed: () =>
                  context.router.replaceAll(const [HomeAssistantScanRoute()]),
              child: Column(children: const [
                Text('Salta'),
                SizedBox(
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

  const _TextPadding(this.page);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: [
              Text(
                _GetTextFromPage.getTitle(page),
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
              _HomeAssistantSuperRichText(_GetTextFromPage.firstText(page))
            ]),
            const SizedBox(
              height: 11,
            ),
            Row(children: [
              _HomeAssistantSuperRichText(_GetTextFromPage.secondText(page))
            ]),
            const SizedBox(
              height: 21,
            ),
            _NextButtonInfo(page)
          ],
        ));
  }
}

class _GetTextFromPage {
  static String getTitle(int page) {
    switch (page) {
      case 1:
        return 'benvenuto!';
      case 2:
        return 'accedi e configura!';
      case 3:
        return 'comfort e risparmio';
    }
    return '';
  }

  static String firstText(int page) {
    switch (page) {
      case 1:
        return "Homsai è l’applicazione che "
            "ti consente di */ottimizzare*/ la gestione "
            "della tua smart home.";
      case 2:
        return "Effettua la registrazione a "
            "Homsai con le tue credenziali di l1Home "
            "Assistantl1 e in pochi istanti avrai "
            "la tua smart home configurata.";
      case 3:
        return "Grazie ad Homsai la tua casa "
            "si prenderà cura di te ottimizzando "
            "i consumi epermettendoti un notevole "
            "risparmio in bolletta.";
    }
    return '';
  }

  static String secondText(int page) {
    switch (page) {
      case 1:
        return "Grazie alla nostra */intelligenza "
            "artificiale*/ riceverai suggerimenti "
            "personalizzati per */l’efficienza e il "
            "risparmio*/. Con un semplice click Homsai "
            "si occuperà di tutto.";
      case 2:
        return "Utilizziamo l2le più avanzate "
            "tecnologiel2 per la salvaguardia dei dati. "
            "La tua privacy è al sicuro.";
      case 3:
        return "L’interfaccia intuitiva ti permetterà "
            "inoltre di controllare */tutti i tuoi dispositivi*/ "
            "e impostare */routine*/facilmente.";
    }
    return '';
  }

  static String buttonText(int page) {
    switch (page) {
      case 1:
        return "Come funziona?";
      case 2:
        return "Quali vantaggi ho?";
      case 3:
        return "Voglio provare Homsai";
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

  const _NextButtonInfo(this.page);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _NextButton(page),
        const SizedBox(height: 21),
        _InfoPage(page)
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final int page;

  const _NextButton(this.page);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        page < 3
            ? context.router.push(IntroductionRoute(page: page + 1))
            : context.router.replaceAll(const [HomeAssistantScanRoute()]);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Text(_GetTextFromPage.buttonText(page),
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
      child: Text('Step $page di 3',
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
          fontSize: 18,
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
