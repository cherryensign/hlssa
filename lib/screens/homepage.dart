import 'package:HLSA/models/category.dart';
import 'package:HLSA/screens/login_screen.dart';
import 'package:HLSA/services/supabaseFunc.dart';
import 'package:HLSA/screens/addPlayer.dart';
import 'package:HLSA/widgets/categoryButton.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<PlayerCategory> categories = [
    PlayerCategory.under12,
    PlayerCategory.under14,
    PlayerCategory.under17,
    PlayerCategory.under19,
    PlayerCategory.academy,
  ];
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _slideController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void logout(BuildContext context) async {
    SupabaseFunc().logoutSB();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
          centerTitle: true,
          title: CircleAvatar(
              child: Hero(
                  tag: "logo",
                  child: Image.asset("assets/images/HLSLogo.png"))),
          actions: [
            IconButton(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          height: height,
          padding: const EdgeInsets.all(12),
          child: Wrap(
            children: [
              const Text(
                'Welcome',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const Text(
                "Select a Category to take the respective attendance...",
                style: TextStyle(color: Colors.white),
              ),
              Container(
                height: height * 0.8,
                child: GridView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(CurvedAnimation(
                          parent: _fadeController,
                          curve: Curves.easeInOut,
                        )),
                        child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(
                                  0, 0.5), // Slide up from half the screen
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _slideController,
                              curve: Curves.easeInOut,
                            )),
                            child: CategoryButton(
                              category: categories[index],
                            )));
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPlayerForm()));
          },
          child: const Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              Icon(Icons.add),
              Text("Add Player"),
            ],
          ),
        ),
      ),
    );
  }
}
