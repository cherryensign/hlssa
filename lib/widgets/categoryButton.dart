import 'package:HLSA/models/category.dart';
import 'package:HLSA/screens/categoryMenupage.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  CategoryButton({required this.category});
  final PlayerCategory category;

  @override
  Widget build(BuildContext context) {
    String buttonText;
    Icon icont = Icon(Icons.person_4_rounded);
    switch (category) {
      case PlayerCategory.under12:
        buttonText = 'Under 12';
        icont = const Icon(
          Icons.person_4_rounded,
          color: Colors.white,
          size: 50,
        );
        break;
      case PlayerCategory.under14:
        buttonText = 'Under 14';
        icont = const Icon(
          Icons.person_4_rounded,
          color: Colors.white,
          size: 60,
        );
        break;
      case PlayerCategory.under17:
        buttonText = 'Under 17';
        icont = const Icon(
          Icons.person_4_rounded,
          color: Colors.white,
          size: 70,
        );
        break;
      case PlayerCategory.under19:
        buttonText = 'Under 19';
        icont = const Icon(
          Icons.person_4_rounded,
          size: 80,
          color: Colors.white,
        );
        break;
      case PlayerCategory.academy:
        icont = const Icon(
          Icons.groups_2_rounded,
          color: Colors.white,
          size: 80,
        );
        buttonText = 'Academy Players';
        break;
    }
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
          // Handle button click based on the category
          print('Button clicked: $buttonText');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryMenuPage(categoryName: buttonText)));
        },
        child: Center(
            child: Wrap(
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            icont,
            Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        )),
      ),
    );
  }
}
