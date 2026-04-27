import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePassword,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: AppColors.softWhite,
        fontFamily: 'Poppins',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.softWhite,
          fontFamily: 'Poppins',
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.lightGray.withOpacity(0.6),
          fontFamily: 'Poppins',
        ),
        prefixIcon: Semantics(
          label: 'Ícone do campo $label',
          child: Icon(
            icon,
            color: AppColors.gold,
          ),
        ),
        suffixIcon: isPassword
            ? Semantics(
                button: true,
                label: obscureText ? 'Mostrar senha' : 'Ocultar senha',
                hint: obscureText
                    ? 'Toque para ouvir os caracteres da senha'
                    : 'Toque para esconder os caracteres da senha',
                child: IconButton(
                  tooltip: obscureText ? 'Mostrar senha' : 'Ocultar senha',
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.gold,
                  ),
                  onPressed: onTogglePassword,
                ),
              )
            : null,
        filled: true,
        fillColor: AppColors.darkBrown,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
