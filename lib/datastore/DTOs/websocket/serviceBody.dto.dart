class ServiceBodyDto {
  Map<String, String>? serviceData;
  Map<String, String>? target;

  ServiceBodyDto(this.serviceData, this.target);

  ServiceBodyDto.fromJson(Map<String, dynamic> json) {
    json['service_data'] != null ? serviceData = json['service_data'] : null;
    json['target'] != null ? target = json['target'] : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['service_data'] != null ? json['service_data'] = serviceData : null;
    json['target'] != null ? json['target'] = target : null;
    return json;
  }
}
