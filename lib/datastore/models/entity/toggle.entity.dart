abstract class TogglableEntity {
  bool isOn = false;

  void turnOn() {
    isOn = true;
  }

  void turnOff() {
    isOn = false;
  }
}
