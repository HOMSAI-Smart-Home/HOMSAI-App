class TriggerBodyDto{
  String? state;
  String? entityId;
  String? from;
  String? to;

  TriggerBodyDto(this.state, this.entityId, this.from, this.to);

  TriggerBodyDto.fromJson(Map<String, dynamic> json) {
    state = json['state']; 
    entityId = json['entityId'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    return {"platform": state, "entity_id": entityId, "from": from, "to": to};
  }
}