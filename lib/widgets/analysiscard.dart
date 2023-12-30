import 'package:flutter/material.dart';

class AttendanceAnalysisCard extends StatelessWidget {
  final int totalPresentDays;
  final int totalAbsentDays;
  final double attendancePercentage;

  AttendanceAnalysisCard({
    required this.totalPresentDays,
    required this.totalAbsentDays,
    required this.attendancePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    height: 90,
                    width: 90,
                    child: CircularProgressIndicator(
                      value: (100 - attendancePercentage) / 100.0,
                      color: Colors.red,
                      backgroundColor: Colors.green,
                      strokeWidth: 10.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${attendancePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Attendance Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Total Present Days
                Text('Total Present Days: $totalPresentDays'),
                // Total Absent Days
                Text('Total Absent Days: $totalAbsentDays'),
                // Percentage of Attendance
                Text(
                    'Percentage of Attendance: ${attendancePercentage.toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
