import 'package:event_ticket_booking/features/register/data/models/register_request_model.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_state.dart';
import 'package:event_ticket_booking/features/register/presentation/ui/widgets/header_text.dart';
import 'package:event_ticket_booking/features/register/presentation/ui/widgets/register_button.dart';
import 'package:event_ticket_booking/features/register/presentation/ui/widgets/register_field.dart';
import 'package:event_ticket_booking/features/register/presentation/ui/widgets/register_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<RegisterCubit>().register(
      RegisterRequestModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rePassword: _rePasswordController.text,
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderText(),
              const SizedBox(height: 32),
              RegisterField.name(controller: _nameController),
              RegisterField.email(controller: _emailController),
              RegisterField.phone(controller: _phoneController),
              RegisterField.password(controller: _passwordController),
              RegisterField.confirmPassword(
                controller: _rePasswordController,
                passwordController: _passwordController,
                onSubmitted: (_) => _register(),
              ),
              const SizedBox(height: 24),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return RegisterButton(
                    isLoading: state.status == Status.loading,
                    onPressed: _register,
                  );
                },
              ),
              const SizedBox(height: 16),
              const RegisterFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
