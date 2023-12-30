import 'package:HLSA/screens/studentInfo.dart';
import 'package:HLSA/services/supabaseFunc.dart';
import 'package:flutter/material.dart';

class ViewPlayersPage extends StatefulWidget {
  const ViewPlayersPage({super.key, required this.categoryName});
  final String categoryName;

  @override
  State<ViewPlayersPage> createState() => _ViewPlayersPageState();
}

class _ViewPlayersPageState extends State<ViewPlayersPage> {
  List<dynamic> players = [];
  String categoryNamet = "";
  @override
  void initState() {
    super.initState();
    fetchViewPlayer();
  }

  Future<void> fetchViewPlayer() async {
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

    final response = await SupabaseFunc().fetchPlayersAsCat(categoryNamet);

    if (response != null) {
      setState(() {
        players = response; //as List<Map<String, dynamic>>;
      });
    } else {
      print('Error fetching data: ${response}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).scaffoldBackgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            widget.categoryName + " Players List",
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
        body: players.isEmpty
            ? const Center(
                child: Text(
                    "Player list is Empty or Not found.\nPlease check with administrator."),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentInfoReport(
                                        playersInfo: player,
                                      )));
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                                child: Text((index + 1).toString())),
                            title: Text(player['full_name'].toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("DOB: " +
                                    player['date_of_birth'].toString()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
