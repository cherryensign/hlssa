import 'package:HLSA/services/supabaseFunc.dart';
import 'package:HLSA/widgets/attendanceList.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key, required this.categoryName});
  final String categoryName;

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<dynamic> attendanceData = [];
  String categoryNamet = "";

  @override
  void initState() {
    super.initState();
    print("Category recieved:" + widget.categoryName);
    switch (widget.categoryName) {
      case "Under 12":
        categoryNamet = "under12";
        break;
      case "Under 14":
        categoryNamet = "under14";
        break;
      case "Under 17":
        categoryNamet = "under17";
        break;
      case "Under 19":
        categoryNamet = "under19";
        break;
      case "Academy Players":
        categoryNamet = "academy";
        break;
      default:
        categoryNamet = "";
        break;
    }
    print("CategorynameT:" + categoryNamet);
    getAttendanceCat();
  }

  Future<void> getAttendanceCat() async {
    final response = await SupabaseFunc().getAttendanceCategory(categoryNamet);

    if (response != null) {
      print(response);
      attendanceData = response as List<dynamic>;
      setState(() {});
    } else {
      print('Error checking attendance: ');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text(
              widget.categoryName + "'s Attendance",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                )),
          ),
          body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Expanded(
                  child: AttendanceList(attendanceData: attendanceData),
                )
              ]))),
    );
  }
}
