import 'package:flutter/material.dart';

class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {

  int _isSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager"), centerTitle: true),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _isSelectedIndex,
        onDestinationSelected: (int index){
          _isSelectedIndex = index;
          setState(() {

          });
        },
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.new_label_outlined),
              label: "New"
          ),
          NavigationDestination(
            icon: Icon(Icons.refresh),
            label: "Progress",
          ),
          NavigationDestination(
              icon: Icon(Icons.close),
              label: "Cancelled"
          ),
          NavigationDestination(
              icon: Icon(Icons.done),
              label: "Completed"
          ),
        ],
      ),
    );
  }
}
