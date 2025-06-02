import 'package:flutter/material.dart';
import 'package:anshin_step/pages/step_list.dart';
import 'package:anshin_step/pages/chat.dart';
import 'package:anshin_step/pages/mind_report.dart';
import 'package:anshin_step/components/colors.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const StepList(),
    const Chat(),
    const Scaffold(body: Center(child: Text('日記'))),
    const Scaffold(body: Center(child: Text('一緒に行動'))),
    const MindReport(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.text.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'チャット',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '日記',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '一緒に行動',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'レポート',
          ),
        ],
      ),
    );
  }
}
