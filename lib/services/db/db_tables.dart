const String createSupplyItemsTable = '''
    CREATE TABLE supply_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      name TEXT NOT NULL,
      totalDose TEXT,
      usedDose TEXT,
      concentration TEXT,
      moleculeJson TEXT,
      administrationRouteName TEXT,
      esterName TEXT,
      amount INTEGER
    )
    ''';

const String createMedicationIntakesTable = '''
    CREATE TABLE medication_intakes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      scheduledDateTime TEXT NOT NULL,
      takenDateTime TEXT,
      takenTimeZone TEXT,
      dose TEXT NOT NULL,
      scheduleId INTEGER,
      side TEXT,
      moleculeJson TEXT NOT NULL,
      administrationRouteName TEXT NOT NULL,
      esterName TEXT,
      supplyItemId INTEGER,
      notes TEXT,
      FOREIGN KEY (supplyItemId) REFERENCES supply_items(id) ON DELETE SET NULL
    )
    '''; // TODO use foreign key for scheduleId

const String createMedicationSchedulesTable = '''
    CREATE TABLE medication_schedules(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      dose TEXT NOT NULL,
      intervalDays INTEGER NOT NULL,
      startDate TEXT NOT NULL,
      moleculeJson TEXT NOT NULL,
      administrationRouteName TEXT NOT NULL,
      esterName TEXT,
      notificationTimes TEXT NOT NULL
    )
    ''';

const String createBloodTestsTable = '''
    CREATE TABLE blood_tests(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      dateTime TEXT NOT NULL,
      timeZone TEXT NOT NULL,
      estradiolLevels TEXT,
      testosteroneLevels TEXT
    )
    ''';
