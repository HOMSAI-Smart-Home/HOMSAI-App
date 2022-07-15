import 'package:equatable/equatable.dart';

class CheckboxState  extends Equatable {
  const CheckboxState({
    this.remote = false,
    this.disable = false,
  });

  final bool remote;
  final bool disable;

  CheckboxState copyWith({
    bool? remote,
    bool? disable,
  }) {
    return CheckboxState(
      remote: remote ?? this.remote,
      disable: disable ?? this.disable
    );
  }

  @override
  List<Object> get props => [remote, disable];
}