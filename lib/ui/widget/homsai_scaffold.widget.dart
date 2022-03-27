import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomsaiScaffold extends StatefulWidget {
  const HomsaiScaffold({
    Key? key,
    this.providers = const [],
    this.child,
    this.children = const [],
    this.padding = const EdgeInsets.all(20),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.bottomNavigationBar,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final List<BlocProvider> providers;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  _HomsaiScaffoldState createState() => _HomsaiScaffoldState();
}

class _HomsaiScaffoldState extends State<HomsaiScaffold> {
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
      child: Scaffold(
        appBar: widget.appBar ??
            AppBar(
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  const Spacer(),
                  SvgPicture.asset("assets/icons/full_logo.svg", height: 20),
                  const Spacer(),
                ],
              ),
            ),
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        body: SafeArea(
          child: (widget.resizeToAvoidBottomInset)
              ? SingleChildScrollView(
                  child: _HomsaiScaffoldBody(
                    padding: widget.padding,
                    mainAxisAlignment: widget.mainAxisAlignment,
                    children: widget.children,
                    child: widget.child,
                  ),
                )
              : _HomsaiScaffoldBody(
                  padding: widget.padding,
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: widget.children,
                  child: widget.child,
                ),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }
}

class _HomsaiScaffoldBody extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final Widget? child;
  final List<Widget> children;

  const _HomsaiScaffoldBody(
      {Key? key,
      required this.padding,
      required this.mainAxisAlignment,
      required this.children,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child ??
          Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
    );
  }
}
