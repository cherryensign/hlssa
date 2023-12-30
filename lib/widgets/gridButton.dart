import 'package:HLSA/screens/pastAttendancePage.dart';
import 'package:HLSA/screens/todaysAttendance.dart';
import 'package:HLSA/screens/viewPlayers.dart';
import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  GridButton({super.key, required this.buttonText, required this.categoryName});
  final String buttonText;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor),
          gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: InkWell(
        onTap: () {
          switch (buttonText) {
            case "View Players":
              print(buttonText);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewPlayersPage(categoryName: categoryName)));
              break;
            case "Today's Attendance":
              print(buttonText);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TodaysAttendancePage(categoryName: categoryName)));
              break;
            case "View Attendance History":
              print(buttonText);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AttendanceHistoryPage(categoryName: categoryName)));
              break;
            default:
          }
        },
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
