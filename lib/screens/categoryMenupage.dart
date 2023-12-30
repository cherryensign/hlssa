import 'package:HLSA/widgets/gridButton.dart';
import 'package:flutter/material.dart';

class CategoryMenuPage extends StatefulWidget {
  CategoryMenuPage({super.key, required this.categoryName});
  final String categoryName;

  @override
  State<CategoryMenuPage> createState() => _CategoryMenuPageState();
}

class _CategoryMenuPageState extends State<CategoryMenuPage>
    with TickerProviderStateMixin {
  final options = [
    "Today's Attendance",
    "View Attendance History",
    "View Players"
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

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
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
              widget.categoryName,
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
          body: Center(
            child: GridView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              itemCount: options.length,
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
                          begin:
                              Offset(0, 0.5), // Slide up from half the screen
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _slideController,
                          curve: Curves.easeInOut,
                        )),
                        child: GridButton(
                          buttonText: options[index],
                          categoryName: widget.categoryName,
                        )));
              },
            ),
          ),
        ));
  }
}
