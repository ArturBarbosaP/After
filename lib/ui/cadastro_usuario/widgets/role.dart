import 'package:flutter/material.dart';

class RoleToggle extends StatelessWidget {
  const RoleToggle({super.key, required this.organizador, required this.onChanged});

  final bool organizador;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(33),
        border: Border.all(color: const Color(0xC2610053), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _seg("Sou usuário", !organizador, () => onChanged(false), 137, Color(0xFFC758AF)),
          _seg("Sou organizador(a)", organizador, () => onChanged(true), 156, Color(0xFF7953B3)),
        ],
      ),
    );
  }

  Widget _seg(String label, bool active, VoidCallback onTap, double w, Color activeColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w,
        height: 29,
        alignment: Alignment.center,
        color: active ? activeColor : Colors.transparent,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}