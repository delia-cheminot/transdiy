import 'package:flutter/material.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/l10n/app_localizations.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:provider/provider.dart';

class EditScheduleNotificationsPage extends StatefulWidget {
  final MedicationSchedule schedule;
  final bool isNewSchedule;

  EditScheduleNotificationsPage(
      {required this.schedule, this.isNewSchedule = false});

  @override
  State<EditScheduleNotificationsPage> createState() =>
      _EditScheduleNotificationsPageState();
}

class _EditScheduleNotificationsPageState
    extends State<EditScheduleNotificationsPage> {
  late List<TimeOfDay> _notificationTimes;
  late MedicationScheduleProvider _medicationScheduleProvider;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final alreadyExists = _notificationTimes.any(
        (time) => time.hour == picked.hour && time.minute == picked.minute,
      );

      if (!alreadyExists) {
        setState(() {
          _notificationTimes.add(picked);
          _notificationTimes.sort((a, b) => a.compareTo(b));
        });
      }
    }
  }

  void _savechanges() {
    if (!mounted) return;

    final updatedSchedule = widget.schedule.copyWith(
      notificationTimes: _notificationTimes,
    );

    if (widget.isNewSchedule) {
      _medicationScheduleProvider.add(updatedSchedule);
      Navigator.pop(context);
    } else {
      _medicationScheduleProvider.updateSchedule(updatedSchedule);
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _notificationTimes = widget.schedule.notificationTimes.toList();
    _medicationScheduleProvider =
        Provider.of<MedicationScheduleProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final localizations = AppLocalizations.of(context)!;

    if (medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.scheduleNotifications),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.scheduleNotifications),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _savechanges,
              child: Text(localizations.save),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickTime,
        tooltip: localizations.addNotification,
        child: Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: false,
      body: _notificationTimes.isEmpty
          ? Center(
              child: Padding(
                padding: pagePadding,
                child: Text(
                  localizations
                      .noNotificationsForSchedule(widget.schedule.name),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SafeArea(
              child: ListView.builder(
                itemCount: _notificationTimes.length,
                itemBuilder: (context, index) {
                  final time = _notificationTimes[index];
                  return ListTile(
                    title: Text(time.format(context)),
                    leading: Icon(Icons.alarm),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          _notificationTimes.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
