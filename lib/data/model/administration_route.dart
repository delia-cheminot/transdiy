class AdministrationRoute {
  final String name;
  final String unit;

  const AdministrationRoute({
    required this.name,
    required this.unit,
  });

  static const injection = AdministrationRoute(
    name: 'injection',
    unit: 'ml',
  );
  static const oral = AdministrationRoute(
    name: 'oral',
    unit: 'pill',
  );
  static const sublingual = AdministrationRoute(
    name: 'sublingual',
    unit: 'pill',
  );
  static const patch = AdministrationRoute(
    name: 'patch',
    unit: 'patch',
  );
  static const gel = AdministrationRoute(
    name: 'gel',
    unit: 'pump',
  );
  static const implant = AdministrationRoute(
    name: 'implant',
    unit: 'implant',
  );
  static const suppository = AdministrationRoute(
    name: 'suppository',
    unit: 'suppository',
  );
}
