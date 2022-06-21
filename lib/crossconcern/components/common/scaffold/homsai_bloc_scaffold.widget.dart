import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/crossconcern/components/common/scaffold/homsai_scaffold.widget.dart';

class HomsaiBlocScaffold extends StatefulWidget {
  const HomsaiBlocScaffold(
      {Key? key,
      required this.providers,
      this.child,
      this.children = const [],
      this.padding = const EdgeInsets.all(10),
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.extendBodyBehindAppBar = false,
      this.resizeToAvoidBottomInset = true,
      this.scrollable = true,
      this.appBar,
      this.bottomNavigationBar,
      this.bottomSheet})
      : super(key: key);

  final EdgeInsetsGeometry padding;
  final List<BlocProvider> providers;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final bool scrollable;
  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;

  @override
  HomsaiBlocScaffoldState createState() => HomsaiBlocScaffoldState();
}

class HomsaiBlocScaffoldState extends State<HomsaiBlocScaffold> {
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
    return MultiBlocProvider(
        providers: widget.providers,
        child: HomsaiScaffold(
          child: widget.child,
          children: widget.children,
          padding: widget.padding,
          mainAxisAlignment: widget.mainAxisAlignment,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          scrollable: widget.scrollable,
          appBar: widget.appBar,
          bottomNavigationBar: widget.bottomNavigationBar,
          bottomSheet: widget.bottomSheet,
        ));
  }
}
