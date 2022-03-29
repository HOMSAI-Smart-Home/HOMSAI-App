class ConfigurationBodyDto {
  Map<String, dynamic>? trigger;
  Map<String, dynamic>? condition;
  Map<String, dynamic>? action;

  ConfigurationBodyDto(this.trigger, this.condition, this.action);

  ConfigurationBodyDto.fromJson(Map<String, dynamic> json) {
    json['trigger'] != null ? trigger = json['trigger'] : null;
    json['condition'] != null ? condition = json['condition'] : null;
    json['action'] != null ? action = json['action'] : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['trigger'] != null ? json['trigger'] = trigger : null;
    json['condition'] != null ? json['condition'] = condition : null;
    json['action'] != null ? json['action'] = action : null;
    return json;
  }
}
