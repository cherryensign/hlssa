import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AttendanceList extends StatefulWidget {
  final List<dynamic> attendanceData;

  const AttendanceList({Key? key, required this.attendanceData}) : super(key: key);

  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  String? expandedDate;

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    widget.attendanceData.sort((a, b) => b['date'].compareTo(a['date']));

    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var entry in widget.attendanceData) {
      String date = entry['date'];
      groupedData.putIfAbsent(date, () => []);
      groupedData[date]!.add(entry);
    }

    return ListView.builder(
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        String date = groupedData.keys.elementAt(index);
        List<Map<String, dynamic>> dateAttendanceData = groupedData[date]!;
        bool isToday = isSameDay(DateTime.now(), DateFormat('yyyy-MM-dd').parse(date));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with date
            InkWell(
              onTap: () {
                setState(() {
                  expandedDate = expandedDate == date ? null : date;
                });
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isToday ? '$date (Today)' : '$date',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,),
                      ),
                      Icon(expandedDate == date ? Icons.arrow_drop_up_rounded: Icons.arrow_drop_down_rounded),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: expandedDate == date ? dateAttendanceData.length *80.0 :0,
              child: SingleChildScrollView(
                child: Visibility(
                      visible: expandedDate==date,
                      child: Column(
                        children: [
                          for (var entry in dateAttendanceData)
                            Card(
                              child: ListTile(
                                leading: CircleAvatar(child: Center(child: Text('${entry['player_id']}'))),
                                title: Text(entry['full_name'].toString()),
                                trailing: Text(
                                  entry['attendance_status'].toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

