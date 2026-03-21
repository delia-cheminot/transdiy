enum SupplyType {
  medication("medication"),
  generic("generic");

  final String name;
  const SupplyType(this.name);

  static SupplyType fromName(String name) {
    return values.firstWhere((value)=>value.name==name);
  }
}