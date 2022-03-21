import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/ui/pages/add_implant/bloc/add_implant.bloc.dart';

class AddImplantPage extends StatefulWidget {
  const AddImplantPage({Key? key}) : super(key: key);

  @override
  State<AddImplantPage> createState() => _AddImplantPageState();
}

class _AddImplantPageState extends State<AddImplantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
            create: (_) => AddImplantBloc(), child: const AddImplantToken()),
      ),
    );
  }
}

class AddImplantToken extends StatefulWidget {
  const AddImplantToken({Key? key}) : super(key: key);

  @override
  AddImplantTokenState createState() {
    return AddImplantTokenState();
  }
}

class AddImplantTokenState extends State<AddImplantToken> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddImplantBloc>(context).add(RetrieveToken());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: BlocBuilder<AddImplantBloc, AddImplantState>(
          buildWhen: (previous, current) => previous.token != current.token,
          builder: (context, state) {
            return Text("Token: " + (state.token ?? "No token"));
          },
        ),
      ),
    );
  }
}
