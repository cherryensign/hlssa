import 'package:HLSA/services/supabaseFunc.dart';
import 'package:flutter/material.dart';

class TodaysAttendancePage extends StatefulWidget {
  const TodaysAttendancePage({super.key, required this.categoryName});
  final String categoryName;

  @override
  State<TodaysAttendancePage> createState() => _TodaysAttendancePageState();
}

class _TodaysAttendancePageState extends State<TodaysAttendancePage> {
  List<dynamic> players = [];
  Map<String, String> attendanceStatusMap = {};
  String categoryNamet = "";
  bool attendanceTaken = false;

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
    checkAttendance();
    fetchViewPlayer();
  }

  Future<void> fetchViewPlayer() async {
    final response = await SupabaseFunc().fetchPlayersAsCat(categoryNamet);

    if (response != null) {
      setState(() {
        players = response; //as List<Map<String, dynamic>>;
      });
    } else {
      print('Error fetching data: ${response}');
    }
  }

  Future<void> checkAttendance() async {
    final response = await SupabaseFunc().checkTodayAttendance(categoryNamet);

    if (response != null) {
      print(response);
      final attendanceData = response as List<dynamic>;
      setState(() {
        if (attendanceData.isNotEmpty) {
          // Attendance already taken
          attendanceTaken = true;
          attendanceStatusMap = Map.fromIterable(attendanceData,
              key: (attendance) => attendance['player_id'].toString(),
              value: (attendance) => attendance['attendance_status']);
        } else {
          // Attendance not taken
          attendanceTaken = false;
        }
      });
    } else {
      print('Error checking attendance: ');
    }
  }

  Future<void> submitAttendance() async {
    final date = DateTime.now().toUtc().toIso8601String();

    // Prepare attendance data with player details
    final attendanceData = players.map((player) {
      final playerId = player['id'].toString();
      final attendanceStatus = attendanceStatusMap[playerId];
      return {
        'player_id': playerId,
        'attendance_status': attendanceStatus,
        'date': date,
        'full_name': player['full_name'],
        'category': player['category'],
      };
    }).toList();

    bool response = await SupabaseFunc().submitAttendance(attendanceData);
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Attendance submitted successfully!'),
        duration: Duration(seconds: 3),
      ));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error submitting attendance. Please try again'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void updateAttendanceStatus(String playerId, String newValue) {
    setState(() {
      attendanceStatusMap[playerId] = newValue;
    });
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
        body: attendanceTaken
            ? Container(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                    "Today's attendance already taken!",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final playerId = player['id'].toString();
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                                child: Text((index + 1).toString())),
                            title: Text(player['full_name'].toString()),
                            subtitle: Text('id: ' + player['id'].toString()),
                            trailing: Text(
                              attendanceStatusMap[playerId].toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ]))
            : Container(
                padding: const EdgeInsets.all(20),
                child: players.length == 0
                    ? Center(
                        child: Text(
                            "Player list is Empty or Not found.\nPlease check with administrator."),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: players.length,
                              itemBuilder: (context, index) {
                                final player = players[index];
                                final playerId = player['id'].toString();
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        child: Text((index + 1).toString())),
                                    title: Text(player['full_name'].toString()),
                                    subtitle:
                                        Text('id: ' + player['id'].toString()),
                                    trailing: DropdownButton<String>(
                                      value: attendanceStatusMap[playerId],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          updateAttendanceStatus(
                                              playerId, newValue!);
                                        });
                                      },
                                      items: <String>['Yes', 'No']
                                          .map<DropdownMenuItem<String>>(
                                            (String value) =>
                                                DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: submitAttendance,
                            child: Text('Submit Attendance'),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
