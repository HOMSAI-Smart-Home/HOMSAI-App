import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/components/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/main.dart';

part 'url_update.event.dart';
part 'url_update.state.dart';

class UrlUpdateBloc extends Bloc<UrlUpdateEvent, UrlUpdateState> {
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();
  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  DoubleUrlBloc doubleUrlBloc;
  Plant? plant;

  UrlUpdateBloc(
    this.doubleUrlBloc,
  ) : super(const UrlUpdateState()) {
    on<AutoComplete>(_onAutoColplete);
    on<UrlSubmitted>(_onUrlSubmitted);

    add(AutoComplete());
  }

  void _onAutoColplete(
    AutoComplete event,
    Emitter<UrlUpdateState> emit,
  ) async {
    plant = await appDatabase.getPlant();

    if (plant != null) {
      doubleUrlBloc.add(DoubleUrlAutoComplete(
        localUrl: plant!.localUrl ?? '',
        remoteUrl: plant!.remoteUrl ?? '',
      ));
    }
  }

  void _onUrlSubmitted(UrlSubmitted event, Emitter<UrlUpdateState> emit) async {
    doubleUrlBloc.add(
      DoubleUrlSubmitted(
        onSubmit: (localurl, remote) async {
          plant = plant?.copyWith(
            localUrl: localurl,
            remoteUrl: remote,
          );

          if (plant != null) await appDatabase.plantDao.updateItem(plant!);

          event.onSubmit();
        },
      ),
    );
  }
}
