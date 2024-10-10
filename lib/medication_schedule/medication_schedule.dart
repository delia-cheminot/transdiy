class MedicationSchedule {
  final int? id;
  String name;
  double dose;
  int intervalDays;

  MedicationSchedule({
    this.id,
    required this.name,
    required this.dose,
    required this.intervalDays,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'intervalDays': intervalDays,
    };
  }

  factory MedicationSchedule.fromMap(Map<String, Object?> map) {
    return MedicationSchedule(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: map['dose'] as double,
      intervalDays: map['intervalDays'] as int,
    );
  }

  MedicationSchedule copy() {
    return MedicationSchedule(
      id: id,
      name: name,
      dose: dose,
      intervalDays: intervalDays,
    );
  }

  @override
  String toString() {
    return 'MedicationSchedule{id: $id name: $name}';
  }
}