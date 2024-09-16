import 'package:flutter/material.dart';

class SideNavigationBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback fun;
  final bool isSelected;

  const SideNavigationBarItem({
    super.key,
    required this.fun,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: fun,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle, // Makes the container circular
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0, 3), // Adds shadow effect
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: isSelected ? Colors.green : Colors.grey,
                size: 30, // Size of the icon
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // Spacing between the button and label
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
