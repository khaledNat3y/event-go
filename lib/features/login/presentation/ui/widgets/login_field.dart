import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/core/utils/validators.dart';
import 'package:event_ticket_booking/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;

  const LoginField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.onSubmitted,
  });

  const LoginField.email({
    Key? key,
    required TextEditingController controller,
  }) : this(
         key: key,
         label: 'Email',
         hint: 'Enter your email',
         icon: Icons.email_outlined,
         controller: controller,
         keyboardType: TextInputType.emailAddress,
         textInputAction: TextInputAction.next,
         validator: LoginValidators.email,
       );

  const LoginField.password({
    Key? key,
    required TextEditingController controller,
    required void Function(String) onSubmitted,
  }) : this(
         key: key,
         label: 'Password',
         hint: 'Enter your password',
         icon: Icons.lock_outline,
         controller: controller,
         textInputAction: TextInputAction.done,
         obscureText: true,
         validator: LoginValidators.password,
         onSubmitted: onSubmitted,
       );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomTextField(
        label: label,
        hint: hint,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        textInputAction: textInputAction,
        obscureText: obscureText,
        validator: validator,
        onFieldSubmitted: onSubmitted,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
      ),
    );
  }
}