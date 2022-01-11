import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/blue_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Logo(),
                _Form(),
                Text(
                  'Terminos y Condiciones de uso',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SizedBox(
        child: Column(
          children: [
            CustomInput(
              icon: Icons.account_circle_outlined,
              hint: 'Name',
              isPassword: false,
              textController: nameController,
              keyboardType: TextInputType.text,
            ),
            CustomInput(
              icon: Icons.mail_outline,
              hint: 'Email',
              isPassword: false,
              textController: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomInput(
              icon: Icons.lock_outline,
              hint: 'Password',
              isPassword: true,
              textController: passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
            BlueButton(
              title: 'Sign Up',
              onPressed: authService.onAuth
                  ? null
                  : () async {
                      print(nameController.text);
                      print(emailController.text);
                      print(passwordController.text);

                      final success = await authService.signUp(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (success) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'users');

                      } else {
                        showAlert(
                            context, 'Invalid Email', success.toString());
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
