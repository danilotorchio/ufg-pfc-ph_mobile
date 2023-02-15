import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

import '../auth_wrapper.dart';
import '../../../../shared/shared.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  String _email = '';
  String _password = '';

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthLoginRequested(_email, _password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      bodyBuilder: (context) => Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Faça login para acessar o app',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32.0),
            AppInput(
              label: 'E-mail',
              placeholder: 'Informe seu e-mail de acesso',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.mail,
                  color: const Color(0xFF707070).withOpacity(0.3),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe seu e-mail';
                } else if (!EmailValidator.validate(value)) {
                  return 'E-mail inválido';
                }

                return null;
              },
              onChanged: (value) => setState(() {
                _email = value;
              }),
            ),
            const SizedBox(height: 18.0),
            AppInput(
              label: 'Senha',
              placeholder: 'Informe sua senha',
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.lock,
                  color: const Color(0xFF707070).withOpacity(0.3),
                ),
              ),
              suffixIcon: GestureDetector(
                child: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe sua senha';
                } else if (value.length < 6) {
                  return 'A senha deve conter ao menos 6 caracteres';
                }

                return null;
              },
              onChanged: (value) => setState(() {
                _password = value;
              }),
            ),
            const SizedBox(height: 32.0),
            BlocSelector<AuthBloc, AuthState, bool>(
              selector: (state) => state.loading,
              builder: (context, state) => AppButton(
                label: 'Confirmar login',
                loading: state,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
      footerBuilder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ainda não possui uma conta?'),
          const SizedBox(width: 4.0),
          GestureDetector(
            child: Text(
              'Clique aqui',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
            ),
            onTap: () => Navigator.of(context).pushNamed('routeName'),
          ),
        ],
      ),
    );
  }
}
