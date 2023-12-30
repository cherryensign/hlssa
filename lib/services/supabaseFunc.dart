import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunc {
  final supabase = Supabase.instance.client;
  final storage = const FlutterSecureStorage();

  Future<bool> addPlayer(
    String full_name,
    String categoryName,
    String dob,
    String jd,
    String ed,
  ) async {
    try {
      final response = await supabase.from('playersinfo').upsert([
        {
          'full_name': full_name,
          'category': categoryName,
          'date_of_birth': dob,
          'joining_date': jd,
          'end_date': ed,
        }
      ]);
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> fetchPlayersAsCat(String categoryName) async {
    try {
      final response = await supabase.from('playersinfo').select().eq(
          'category',
          categoryName); // Adjust the condition based on your schema
      print(response);
      return response;
    } catch (e) {
      print('Error fetching players: ${e}');
      return null;
    }
  }

  Future<bool> submitAttendance(dynamic attendanceData) async {
    try {
      final response = await supabase.from('attendance').upsert(attendanceData);
      print(response);
      return true;
    } catch (e) {
      print('Error submitting attendance: ${e}');
      return false;
    }
  }

  Future<dynamic> checkTodayAttendance(String categoryNamet) async {
    final date = DateTime.now().toUtc().toIso8601String();
    try {
      final response = await supabase
          .from('attendance')
          .select('player_id, attendance_status')
          .eq('date', date)
          .eq('category', categoryNamet);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getAttendanceCategory(String categoryNamet) async {
    try {
      final response = await supabase
          .from('attendance')
          .select('*')
          .eq('category', categoryNamet);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> fetchPlayerAttendance(int playerId) async {
    try {
      final response = await supabase
          .from('attendance')
          .select('date , attendance_status')
          .eq('player_id', playerId);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<bool> signInSB(
    String email,
    String password,
  ) async {
    try {
      // Sign in with email and password
      var response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      print(response);

      supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        // final Session? session = data.session;
        if (event == AuthChangeEvent.signedIn) {
          storage.write(
              key: 'supabase_token', value: data.session?.accessToken);
        }
      });
      return true;
    } catch (error) {
      // Handle other unexpected errors
      print('Unexpected error occurred: $error');
      return false;
    }
  }

  void logoutSB() async {
    await storage.delete(key: 'supabase_token');
    supabase.auth.signOut();
  }
}
