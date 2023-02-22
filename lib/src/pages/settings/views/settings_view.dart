import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:email_validator/email_validator.dart';

import 'package:ph_mobile/src/shared/shared.dart';

import '../../pages.dart' show HomePage;

class SettingsView extends StatefulWidget {
  final BluetoothDevice device;

  const SettingsView({super.key, required this.device});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();

  String _wifiSSID = '';
  String _wifiPass = '';
  String _userEmail = '';
  String _userPass = '';
  String _apiUrl = '';

  final _wifiSSIDController = TextEditingController();
  final _wifiPassController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPassController = TextEditingController();
  final _apiUrlController = TextEditingController();

  @override
  void initState() {
    _loadDefaults();
    super.initState();
  }

  void _loadDefaults() async {
    final prefs = await context.read<StationCubit>().getSettings();

    Future.delayed(
      Duration.zero,
      () => setState(() {
        if (prefs != null) {
          _wifiSSIDController.text = _wifiSSID = prefs.wifiSSID;
          _wifiPassController.text = _wifiPass = prefs.wifiPass;
          _userEmailController.text = _userEmail = prefs.userEmail;
          _userPassController.text = _userPass = prefs.userPass;
          _apiUrlController.text = _apiUrl = prefs.apiUrl;
        } else {
          _apiUrlController.text = _apiUrl = 'http://35.209.244.193/api/data';
        }
      }),
    );
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final settings = SettingsDto(
        wifiSSID: _wifiSSID,
        wifiPass: _wifiPass,
        userEmail: _userEmail,
        userPass: _userPass,
        apiUrl: _apiUrl,
      );

      await context.read<StationCubit>().applySettings(settings, widget.device);

      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('Dados atualizados com sucesso!'),
          ));

        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.route,
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      builder: (context) => Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: _buildForm(),
              ),
            ),
          ),
          BlocBuilder<StationCubit, bool>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                label: 'Enviar configuração',
                loading: state,
                onPressed: () => _submit(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Configurações do dispositivo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 28.0),
          AppInput(
            label: 'Dispositivo',
            placeholder: widget.device.name,
            enabled: false,
          ),
          const SizedBox(height: 20.0),
          AppInput(
            controller: _wifiSSIDController,
            label: 'WiFi SSID',
            placeholder: 'Nome da rede WiFi',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
            onChanged: (value) => setState(() {
              _wifiSSID = value;
            }),
          ),
          const SizedBox(height: 20.0),
          AppInput(
            controller: _wifiPassController,
            label: 'Senha WiFi',
            placeholder: 'Senha da rede WiFi',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
            onChanged: (value) => setState(() {
              _wifiPass = value;
            }),
          ),
          const SizedBox(height: 20.0),
          AppInput(
            controller: _userEmailController,
            label: 'E-mail usuário',
            placeholder: 'E-mail de acesso',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              } else if (!EmailValidator.validate(value)) {
                return 'E-mail inválido';
              }
              return null;
            },
            onChanged: (value) => setState(() {
              _userEmail = value;
            }),
          ),
          const SizedBox(height: 20.0),
          AppInput(
            controller: _userPassController,
            label: 'Senha usuário',
            placeholder: 'Senha de acesso',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
            onChanged: (value) => setState(() {
              _userPass = value;
            }),
          ),
          const SizedBox(height: 20.0),
          AppInput(
            controller: _apiUrlController,
            label: 'API Url',
            placeholder: 'URL da API de serviço',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
            onChanged: (value) => setState(() {
              _apiUrl = value;
            }),
          ),
        ],
      ),
    );
  }
}
