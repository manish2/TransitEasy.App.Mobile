//Represents the user's app preferences
class UserSettings {
  final int searchRadiusKm;
  final int busAlertTrigger;
  final int busLocationInterval;

  UserSettings(
      this.searchRadiusKm, this.busAlertTrigger, this.busLocationInterval);
}
