import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:students_app/database/appointment_editor.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _eventsCollection = _firestore.collection('events');
// Stream<QuerySnapshot> events = _eventsCollection
//   .where('user_id', isEqualTo: userId)
//   .snapshots();
// List<Appointment> appointmentsList = [];
// appointments.listen((QuerySnapshot snapshot) {
//   appointmentsList = snapshot.docs.map((DocumentSnapshot document) {
//     final data = document.data() as Map<String, dynamic>;
//     return Appointment(
//       startTime: DateTime.parse(data['start_time']),
//       endTime: DateTime.parse(data['end_time']),
//       subject: data['title'],
//       color: Color(int.parse(data['color'])),
//       notes: data['note'],
//       recurrenceRule: data['recurrence_rule'],
//     );
//   }).toList();
//   setState(() {
//     _dataSource = MeetingDataSource(appointmentsList);
//   });
// });

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final String userId = user?.uid ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _eventsCollection.where('user_id', isEqualTo: userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Appointment> appointmentsList =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            return Appointment(
              startTime: DateTime.parse(data['start_time']),
              endTime: DateTime.parse(data['end_time']),
              subject: data['title'].toString(),
              color: Color(int.parse(data['color'], radix: 16)),
              notes: data['note'].toString(),
              recurrenceRule: data['recurrence_rule'],
            );
          }).toList();
          return SfCalendar(
            showDatePickerButton: true,
            showNavigationArrow: true,
            view: CalendarView.week,
            dataSource: MeetingDataSource(appointmentsList),
            initialDisplayDate: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            onTap: (calendarTapDetails) {
              if (calendarTapDetails.appointments!.isNotEmpty &&
                  calendarTapDetails.appointments != null) {
                final dynamic occurrenceAppointment =
                    calendarTapDetails.appointments![0];
                final Appointment? patternAppointment =
                    MeetingDataSource(appointmentsList).getPatternAppointment(
                        occurrenceAppointment, '') as Appointment?;
                if (patternAppointment != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(patternAppointment.subject.toString()),
                      content: Text(patternAppointment.notes.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            String id = snapshot.data!.docs
                                .firstWhere((element) =>
                                    element.get('recurrence_rule') ==
                                        patternAppointment.recurrenceRule &&
                                    element.get('note') ==
                                        patternAppointment.notes &&
                                    element.get('title') ==
                                        patternAppointment.subject &&
                                    DateTime.parse(element.get('start_time')) ==
                                        patternAppointment.startTime &&
                                    DateTime.parse(element.get('end_time')) ==
                                        patternAppointment.endTime &&
                                    Color(int.parse(element.get('color'),
                                            radix: 16)) ==
                                        patternAppointment.color)
                                .id;
                            final DocumentReference eventRef = FirebaseFirestore
                                .instance
                                .collection('events')
                                .doc(id);
                            eventRef.delete();
                            Navigator.pop(context);
                          },
                          child: const Text('DELETE'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          List<Appointment> appointments = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppointmentEditor()),
          );
          setState(() {
            final User? user = _auth.currentUser;
            final String userId = user?.uid ?? '';
            _firestore.collection('events').add({
              'title': appointments[0].subject,
              'note': appointments[0].notes,
              'color': appointments[0].color.value.toRadixString(16),
              'start_time': appointments[0].startTime.toString(),
              'end_time': appointments[0].endTime.toString(),
              'recurrence_rule': appointments[0].recurrenceRule ?? '',
              'user_id': userId.toString(),
            });
          });
        },
      ),
    );
  }
}

List<Appointment> getAppointments(
  DateTime start,
  DateTime end,
  String name,
  int repeats,
  Color color,
  String notes,
) {
  // print(generateWeeklyRecurrenceRule(start.weekday, repeats));
  // print('Start time: $start, End time: $end,name: $name');
  List<Appointment> meetings = <Appointment>[];
  meetings.add(
    Appointment(
      startTime: start,
      endTime: end,
      subject: name,
      color: color,
      notes: notes,
      recurrenceRule: generateWeeklyRecurrenceRule(start.weekday, repeats),
    ),
  );
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
  Appointment getAppointment(int index) => appointments![index] as Appointment;
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String getEndTimeZone(int index) {
    return appointments![index].toZone;
  }

  @override
  List<DateTime> getRecurrenceExceptionDates(int index) {
    return appointments![index].exceptionDates;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }

  @override
  String getStartTimeZone(int index) {
    return appointments![index].fromZone;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

String generateWeeklyRecurrenceRule(int dayOfWeek, int numberOfWeeks) {
  String dayString;
  switch (dayOfWeek) {
    case 1:
      dayString = 'MO';
      break;
    case 2:
      dayString = 'TU';
      break;
    case 3:
      dayString = 'WE';
      break;
    case 4:
      dayString = 'TH';
      break;
    case 5:
      dayString = 'FR';
      break;
    case 6:
      dayString = 'SA';
      break;
    case 7:
      dayString = 'SU';
      break;
    default:
      throw ArgumentError('Invalid day of week');
  }
  // print('FREQ=WEEKLY;COUNT=$numberOfWeeks;BYDAY=$dayString');

  return 'FREQ=WEEKLY;COUNT=$numberOfWeeks;BYDAY=$dayString';
}
