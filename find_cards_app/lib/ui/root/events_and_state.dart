class AppState {
  String url = '';
  bool haveInternet = false;
  bool presentUrl = false;
  bool conditionsChecked = false;

  AppState(this.haveInternet, this.presentUrl, this.url);

  @override
  operator ==(other) {
    if (other.runtimeType != AppState) return false;
    return other.hashCode == hashCode;
  }

  @override
  int get hashCode =>
      url.hashCode ^
      haveInternet.hashCode ^
      presentUrl.hashCode ^
      conditionsChecked.hashCode;
}
