import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/features/login/data/models/login_request_model.dart';
import 'package:event_ticket_booking/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_ticket_booking/features/login/presentation/cubit/login_state.dart';
import 'package:event_ticket_booking/features/login/presentation/ui/widgets/login_button.dart';
import 'package:event_ticket_booking/features/login/presentation/ui/widgets/login_field.dart';
import 'package:event_ticket_booking/features/login/presentation/ui/widgets/login_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<LoginCubit>().login(
      LoginRequestModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
              Text(
                'Enter your credentials to access your account',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              LoginField.email(controller: _emailController),
              LoginField.password(
                controller: _passwordController,
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 24),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return LoginButton(
                    isLoading: state.status == Status.loading,
                    onPressed: _login,
                  );
                },
              ),
              const SizedBox(height: 16),
              const LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}