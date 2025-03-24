import 'package:flutter/material.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/screen/auth/widgets/custom_btn_widget.dart';
import 'package:live_chat/screen/auth/widgets/custom_txtfield_widget.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreenView extends StatefulWidget {
  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Anonim giriş methodu
  Future<void> _anonymousLogin(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel? user = await userViewModel.signInAnonymously();
    print("oturum acan user id: ${user?.toString()}");
  }

  // Google ile giriş methodu
  Future<void> _signinWithGoogle(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel? user = await userViewModel.signInGoogle();
    print("google oturum acan user id: ${user?.userID.toString()}");
  }

  // email ve parola ile giriş
  Future<void> _emailAndPasswordLogin() async {
    print(_emailController.text);
    print(_passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    _emailController.text;
    _emailController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
          child: AppBar(title: Text("Live Chat"), elevation: 0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFieldCardWidget(
                  controller: _emailController,
                  hintText: "Email Adresin",
                  onTap: () {},
                ),
                SizedBox(height: 12),
                CustomTextFieldCardWidget(
                  controller: _passwordController,
                  hintText: "Şifreniz",
                  obscureText: true,
                  onTap: () {},
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap:
                      () => _emailAndPasswordLogin(), // Butona tıklama işlevi
                  child: CustomButtonWidget(
                    imgPath: "assets/icons/send.png",
                    cardColor: Theme.of(context).colorScheme.secondary,
                    txt: "Giriş Yap",
                    txtColor: Colors.black87,
                  ),
                ),
                SizedBox(height: 40),

                // Google ile giriş butonu
                GestureDetector(
                  onTap:
                      () => _signinWithGoogle(context), // Butona tıklama işlevi
                  child: CustomButtonWidget(
                    imgPath: "assets/icons/google.png",
                    cardColor: Colors.white,
                    txt: "Google ile devam et",
                    txtColor: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                // Anonim ile Giriş Yap
                GestureDetector(
                  onTap:
                      () => _anonymousLogin(context), // Butona tıklama işlevi
                  child: CustomButtonWidget(
                    imgPath: "assets/icons/bitcoin.png",
                    cardColor: Colors.grey.shade300,
                    txt: "Anonim olarak devam et",
                    txtColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
