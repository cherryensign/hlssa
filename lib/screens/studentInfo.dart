import 'package:HLSA/services/supabaseFunc.dart';
import 'package:HLSA/widgets/analysiscard.dart';
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
  Map<String, List<String>> _events = {};
  int totalPresentDays = 0;
  int totalAbsentDays = 0;
  int totalDaysWithAttendance = 0;

  @override
  void initState() {
    super.initState();
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
            // (value) => value..add(status),
            (value) => [...value, status],
            ifAbsent: () => [status],
          );
        }
        print("Events=================" + _events.toString());
        try {
          calculateAttendanceStatistics(_events);
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

  void calculateAttendanceStatistics(Map<String, List<String>> attendanceData) {
    totalPresentDays = 0;
    totalAbsentDays = 0;
    totalDaysWithAttendance = attendanceData.length;

    attendanceData.forEach((date, statuses) {
      if (statuses.contains('Yes')) {
        totalPresentDays++;
      } else if (statuses.contains('No')) {
        totalAbsentDays++;
      }
    });
    print("=-=-=-=-=-=-=-=-" + totalPresentDays.toString());
    print("=-=-=-=-=-=-=-=-" + totalAbsentDays.toString());
  }

  void updateAnalysisForMonth(
      DateTime firstVisibleDay, DateTime lastVisibleDay) {
    // Filter attendance data for the visible month
    Map<DateTime, List<String>> filteredData = {};

    _events.forEach((data, statuses) {
      DateTime date = DateTime.parse(data);
      if (date.isAfter(firstVisibleDay.subtract(Duration(days: 1))) &&
          date.isBefore(lastVisibleDay.add(Duration(days: 1)))) {
        filteredData[date] = statuses;
      }
    });

    // Calculate statistics for the filtered data
    totalPresentDays = 0;
    totalAbsentDays = 0;
    totalDaysWithAttendance = filteredData.length;

    filteredData.forEach((date, statuses) {
      if (statuses.contains('Yes')) {
        totalPresentDays++;
      } else if (statuses.contains('No')) {
        totalAbsentDays++;
      }
    });

    double percentageAttendance = totalDaysWithAttendance > 0
        ? (totalPresentDays / totalDaysWithAttendance) * 100.0
        : 0.0;

    print('For the month of ${firstVisibleDay.month}/${firstVisibleDay.year}:');
    print('Total Present Days: $totalPresentDays');
    print('Total Absent Days: $totalAbsentDays');
    print('Total Days with Attendance: $totalDaysWithAttendance');
    print(
        'Percentage of Attendance: ${percentageAttendance.toStringAsFixed(1)}%');
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
                                    onPageChanged: (focusedDay) {
                                      _focusedDay = focusedDay;
                                    },
                                    // onVisibleDaysChanged:
                                    //     (first, last, format) {
                                    //   // Update analysis based on the visible month
                                    //   updateAnalysisForMonth(first, last);
                                    // },
                                    onDaySelected: (selectedDay, focusedDay) {
                                      setState(() {
                                        _selectedDay = selectedDay;
                                      });
                                    },
                                  ),
                                ),
                                AttendanceAnalysisCard(
                                  totalPresentDays: totalPresentDays,
                                  totalAbsentDays: totalAbsentDays,
                                  attendancePercentage: totalPresentDays /
                                      totalDaysWithAttendance *
                                      100,
                                )
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
