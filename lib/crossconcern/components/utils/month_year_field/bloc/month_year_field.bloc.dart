import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
part 'month_year_field.event.dart';
part 'month_year_field.state.dart';

class MonthYearFieldBloc
    extends Bloc<MonthYearFieldEvent, MonthYearFieldState> {
  MonthYearFieldBloc() : super(const MonthYearFieldState()) {
    on<FieldChanged>(_onFieldChanged);
    on<FieldFocused>(_onFieldFocused);
    on<FieldUnfocused>(_onFieldUnfocused);
  }

  void _onFieldChanged(FieldChanged event, Emitter<MonthYearFieldState> emit) {
    var value = event.value.replaceAll(RegExp(r"\D"), "");
    TextEditingValue controller;
    var yl = event.yearLetter;
    var ml = event.monthLetter;
    switch (value.length) {
      case 0:
        controller = event.controller.copyWith(
          text: "$ml$ml/$yl$yl$yl$yl",
          selection: const TextSelection.collapsed(offset: 0),
        );
        break;
      case 1:
        controller = event.controller.copyWith(
          text: "$value$ml/$yl$yl$yl$yl",
          selection: const TextSelection.collapsed(offset: 1),
        );
        break;
      case 2:
        controller = event.controller.copyWith(
          text: "$value/$yl$yl$yl$yl",
          selection: const TextSelection.collapsed(offset: 2),
        );
        break;
      case 3:
        controller = event.controller.copyWith(
          text: "${value.substring(0, 2)}/${value.substring(2)}$yl$yl$yl",
          selection: const TextSelection.collapsed(offset: 4),
        );
        break;
      case 4:
        controller = event.controller.copyWith(
          text: "${value.substring(0, 2)}/${value.substring(2, 4)}$yl$yl",
          selection: const TextSelection.collapsed(offset: 5),
        );
        break;
      case 5:
        controller = event.controller.copyWith(
          text: "${value.substring(0, 2)}/${value.substring(2, 5)}$yl",
          selection: const TextSelection.collapsed(offset: 6),
        );

        break;
      default:
        controller = event.controller.copyWith(
          text: "${value.substring(0, 2)}/${value.substring(2, 6)}",
          selection: const TextSelection.collapsed(offset: 7),
        );
        break;
    }
    print("controllerValue: ${controller.text}");
    emit(
      state.copyWith(controller: controller),
    );
  }

  void _onFieldFocused(FieldFocused event, Emitter<MonthYearFieldState> emit) {
    if (state.controller.text == "") {
      var controller = TextEditingValue(
          text: event.controllerText,
          selection: const TextSelection.collapsed(offset: 0));
      emit(
        state.copyWith(
          controller: controller,
        ),
      );
    }
  }

  void _onFieldUnfocused(
    FieldUnfocused event,
    Emitter<MonthYearFieldState> emit,
  ) {
    if (state.controller.text == event.startValue) {
      var controller = const TextEditingValue(
          text: "", selection: TextSelection.collapsed(offset: 0));

      emit(
        state.copyWith(
          controller: controller,
        ),
      );
    }
  }
}
