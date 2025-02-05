// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/auth.dart';
import 'package:shop/execeptions/auth_exception.dart';

enum AuthMode {
  signup, login
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.login;

   Map<String, String> _authData = {
    'email': '',
    'password' : ''
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode(){
    setState(() {
      if(_isLogin()){
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg){
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop, 
            child: const Text('Fechar')
            )
        ],
      )
    );
  }

  Future<void> _submit() async{
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid) {
      return;
    }
    setState(() => _isLoading = true);
    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try{
      if(_isLogin()){
        // Login

        await auth.login(
          _authData['email']!, 
          _authData['password']!
        );
      } else {
        // register

        await auth.signup(
          _authData['email']!, 
          _authData['password']!
        );
      }
    } on AuthException catch(error){
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email){
                  final email = _email ?? '';
                  if(email.trim().isEmpty || !email.contains('@')){
                    return 'Informe um e-mail valido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password){
                  final password = _password ?? '';
                  if(password.isEmpty || password.length < 5){
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if(_isSignup())
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirmar senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin() 
                    ? null 
                    : (_password){
                      final password = _password ?? '';
                      if (_passwordController.text != password){
                        return 'Senhas não conferem.';
                      }
                      return null;
                    },
                ),
              const SizedBox(height: 20,),
              if(_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit, 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode, 
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA'
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}