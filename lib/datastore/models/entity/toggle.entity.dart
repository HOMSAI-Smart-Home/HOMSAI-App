abstract class ToggleEntity {
  bool? isOn;

  void turnOn() {
    isOn = true;
  }

  void turnOff() {
    isOn = false;
  }
}
