import 'package:flutter/material.dart';

class NavBarItem {
  final IconData icon;
  final String label;

  NavBarItem({this.icon, this.label});
}

class BottomNavBar extends StatefulWidget {
  final List<NavBarItem> navBarItems;
  final Duration animationDuration;
  final Function onNavBarTap;

  BottomNavBar({this.navBarItems, this.animationDuration, this.onNavBarTap});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  int selectedNavBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildNavBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildNavBarItems() {
    List<Widget> _barItems = [];

    for (int i = 0; i < widget.navBarItems.length; i++) {
      NavBarItem navBarItem = widget.navBarItems[i];
      bool isSelected = selectedNavBarIndex == i;
      _barItems.add(
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              selectedNavBarIndex = i;
              widget.onNavBarTap(i);
            });
          },
          child: AnimatedContainer(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black12 : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  navBarItem.icon,
                  color: isSelected ? Colors.black87 : Colors.black26,
                  size: 30.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                AnimatedSize(
                  vsync: this,
                  curve: Curves.easeInOut,
                  duration: widget.animationDuration,
                  child: Text(
                    isSelected ? navBarItem.label : '',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return _barItems;
  }
}
