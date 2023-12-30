import 'package:HLSA/services/supabaseFunc.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentInfoReport extends StatefulWidget {
  StudentInfoReport({super.key, required this.playersInfo});
  final dynamic playersInfo;

  @override
  State<StudentInfoReport> createState() => _StudentInfoReportState();
}

class _StudentInfoReportState extends State<StudentInfoReport> {
  bool loading = true;
  List<dynamic> attendanceData = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime StartDay = DateTime.now();
  Map<String, List<String>> _events = {};
  late ValueNotifier<Map<String, dynamic>> analysisNotifier;

  @override
  void initState() {
    super.initState();
    analysisNotifier =
        ValueNotifier<Map<String, dynamic>>(getAnalysisForMonth());
    fetchPlayerAttendance();
  }

  Future<void> fetchPlayerAttendance() async {
    final response =
        await SupabaseFunc().fetchPlayerAttendance(widget.playersInfo['id']);
    if (response != null) {
      print(response);
      setState(() {
        attendanceData = response;

        for (var entry in response as List<dynamic>) {
          DateTime date = DateTime.parse(entry['date']);
          String status = entry['attendance_status'];

          _events.update(
            date.toString(),
            (value) => [...value, status],
            ifAbsent: () => [status],
          );
        }
        print("Events=================" + _events.toString());
        try {
          analysisNotifier =
              ValueNotifier<Map<String, dynamic>>(getAnalysisForMonth());
          loading = false;
        } catch (e) {
          loading = false;
        }
        loading = false;
      });
    } else {
      print('Error fetching data: ${response}');
      setState(() {
        loading = false;
      });
    }
  }

  Map<String, dynamic> getAnalysisForMonth() {
    int totalPresentDays = 0;
    int totalAbsentDays = 0;
    int totalDaysWithAttendance = attendanceData.length;
    double attendancePercentage = 0;

    _events.forEach((date, statuses) {
      if (statuses.contains('Yes') &&
          _focusedDay.month == DateTime.parse(date).month) {
        totalPresentDays++;
      } else if (statuses.contains('No') &&
          _focusedDay.month == DateTime.parse(date).month) {
        totalAbsentDays++;
      }
    });
    print("=-=-=-=-=-=-=-=-" + totalPresentDays.toString());
    print("=-=-=-=-=-=-=-=-" + totalAbsentDays.toString());
    attendancePercentage = totalPresentDays / totalDaysWithAttendance * 100;
    return {
      'totalPresentDays': totalPresentDays,
      'totalAbsentDays': totalAbsentDays,
      'totalDaysWithAttendance': totalDaysWithAttendance,
      'percentageAttendance': attendancePercentage,
    };
  }

  @override
  Widget build(BuildContext context) {
    final playersInfo = widget.playersInfo;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(playersInfo);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).scaffoldBackgroundColor
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Card(
                    child: Container(
                  padding: const EdgeInsets.all(16),
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 75,
                            color: Color.fromRGBO(18, 86, 196, 1),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${playersInfo['full_name']}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                              playersInfo['category'].toString().toUpperCase()),
                          Text(
                              'Date of Birth: ${playersInfo['date_of_birth']}'),
                          Text('Joining Date: ${playersInfo['joining_date']}'),
                          Text('Ending Date: ${playersInfo['end_date']}'),
                        ],
                      ),
                    ],
                  ),
                )),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Attendance Report',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      attendanceData.isEmpty
                          ? const Text("No Entries found!")
                          : Column(
                              children: [
                                Card(
                                  child: TableCalendar(
                                    calendarFormat: _calendarFormat,
                                    focusedDay: _focusedDay,
                                    // rangeStartDay: rangeStartDay,
                                    firstDay: DateTime.utc(2023, 1, 1),
                                    lastDay: DateTime.now(),
                                    calendarStyle: const CalendarStyle(
                                      outsideDaysVisible: false,
                                      todayDecoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      selectedDecoration: BoxDecoration(
                                        color: Colors.pink,
                                        shape: BoxShape.circle,
                                      ),
                                      markersMaxCount: 1,
                                    ),
                                    startingDayOfWeek: StartingDayOfWeek.sunday,
                                    calendarBuilders: CalendarBuilders(
                                      markerBuilder: (context, day, events) {
                                        if (_events[day.toString().substring(0,
                                                day.toString().length - 1)] !=
                                            null) {
                                          events = _events[day
                                              .toString()
                                              .substring(0,
                                                  day.toString().length - 1)]!;
                                          final attendanceStatus = events;
                                          print(attendanceStatus);
                                          if (attendanceStatus
                                              .contains('Yes')) {
                                            return Center(
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    day.day.toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          if (attendanceStatus.contains('No')) {
                                            return Center(
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    day.day.toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                    onFormatChanged: (format) {
                                      setState(() {
                                        _calendarFormat = format;
                                      });
                                    },
                                    onPageChanged: (rangeStartDay) {
                                      _focusedDay = rangeStartDay;
                                      analysisNotifier.value =
                                          getAnalysisForMonth();
                                    },
                                    onDaySelected: (selectedDay, focusedDay) {
                                      setState(() {
                                        _selectedDay = selectedDay;
                                      });
                                    },
                                  ),
                                ),
                                // AttendanceAnalysisCard(
                                //   attendanceData: _events,
                                //   startday: rangeStartDay,
                                // ),
                                ValueListenableBuilder(
                                    valueListenable: analysisNotifier,
                                    builder: (context, analysis, _) {
                                      return Card(
                                        elevation: 5,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      height: 90,
                                                      width: 90,
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: (100 -
                                                                analysis[
                                                                    'percentageAttendance']) /
                                                            100.0,
                                                        color: Colors.red,
                                                        backgroundColor:
                                                            Colors.green,
                                                        strokeWidth: 10.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      '${analysis['percentageAttendance'].toStringAsFixed(1)}%',
                                                      style: TextStyle(
                                                        // color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Attendance Analysis',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  // Total Present Days
                                                  Text(
                                                      'Total Present Days: ${analysis['totalPresentDays']}'),
                                                  Text(
                                                      'Total Absent Days: ${analysis['totalAbsentDays']}'),
                                                  Text(
                                                      'Percentage of Attendance: ${analysis['percentageAttendance'].toStringAsFixed(1)}%'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
