import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/core/utils/validators.dart';
import 'package:event_ticket_booking/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegisterField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? passwordController;
  final void Function(String)? onSubmitted;
  const RegisterField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.passwordController,
    this.onSubmitted,
  });
  const RegisterField.name({
    Key? key,
    required TextEditingController controller,
  }) : this(
         key: key,
         label: 'Full Name',
         hint: 'Enter your full name',
         icon: Icons.person_outline,
         controller: controller,
         keyboardType: TextInputType.name,
         textInputAction: TextInputAction.next,
         validator: RegisterValidators.name,
       );
  const RegisterField.email({
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
         validator: RegisterValidators.email,
       );
  const RegisterField.phone({
    Key? key,
    required TextEditingController controller,
  }) : this(
         key: key,
         label: 'Phone Number',
         hint: 'Enter your phone number',
         icon: Icons.phone_outlined,
         controller: controller,
         keyboardType: TextInputType.phone,
         textInputAction: TextInputAction.next,
         validator: RegisterValidators.phone,
       );
  const RegisterField.password({
    Key? key,
    required TextEditingController controller,
  }) : this(
         key: key,
         label: 'Password',
         hint: 'Create a password',
         icon: Icons.lock_outline,
         controller: controller,
         textInputAction: TextInputAction.next,
         obscureText: true,
         validator: RegisterValidators.password,
       );
  RegisterField.confirmPassword({
    Key? key,
    required TextEditingController controller,
    required TextEditingController passwordController,
    required void Function(String) onSubmitted,
  }) : this(
         key: key,
         label: 'Confirm Password',
         hint: 'Confirm your password',
         icon: Icons.lock_outline,
         controller: controller,
         textInputAction: TextInputAction.done,
         obscureText: true,
         validator: (value) =>
             RegisterValidators.confirmPassword(value, passwordController.text),
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
