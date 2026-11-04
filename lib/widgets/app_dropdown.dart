import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  final String hint;    
  final IconData icon;
  final List<T> items;  
  final String Function(T item) labelOf;
  final ValueChanged<T?> onChanged;     
  final String? Function(T?)? validator;
  final T? initialValue;                

  const AppDropdown({
    super.key,
    required this.hint,
    required this.icon,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      isExpanded: true, 
      icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textGrey),
      decoration: AppTheme.inputDecoration(hint: '', icon: icon),
      hint: Text(
        hint,
        style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
      ),
      
      
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelOf(item), overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}