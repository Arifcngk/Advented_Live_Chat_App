import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _switchController = ValueNotifier<bool>(false);
  bool _checked = false;
  // kullanıcı ilk kez kayıt olacaksa

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
  Future<void> _emailAndPasswordLogin(BuildContext context) async {
    print("Girilen Email: ${_emailController.text}");
    print("Girilen Şifre: ${_passwordController.text}");

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    try {
      if (_switchController.value == false) {
        // Giriş yap
        print("Giriş yapılıyor...");
        UserModel? _signinUser = await userViewModel.sigInEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        if (_signinUser != null) {
          print("Başarıyla giriş yapıldı: ${_signinUser.userID}");
        } else {
          print("Giriş başarısız.");
        }
      } else {
        // Yeni kullanıcı oluştur
        print("Yeni kullanıcı oluşturuluyor...");
        UserModel? _creatingUser = await userViewModel.createEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        if (_creatingUser != null) {
          print(
            "Başarıyla yeni kullanıcı oluşturuldu: ${_creatingUser.userID}",
          );
        } else {
          print("Kullanıcı oluşturma başarısız.");
        }
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.text;
    _emailController.text;
    _switchController.addListener(() {
      setState(() {}); // Switch değiştikçe UI güncellensin
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          child: AppBar(title: Text("Live Chat"), elevation: 0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Image.asset("assets/images/ss-1.png", height: 320),
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "İlk kez Giriş Yapıyorum?",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AdvancedSwitch(
                    controller: _switchController,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              SizedBox(height: 16),

              // email ve pasword ile giriş yap
              GestureDetector(
                onTap:
                    () => _emailAndPasswordLogin(
                      context,
                    ), // Butona tıklama işlevi
                child: CustomButtonWidget(
                  imgPath: "assets/icons/send.png",
                  imagePath: false,

                  cardColor: Theme.of(context).colorScheme.secondary,
                  txt: "Giriş Yap",
                  txtColor: Color(0xFFF8FAFC),
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
                onTap: () => _anonymousLogin(context), // Butona tıklama işlevi
                child: CustomButtonWidget(
                  imgPath: "assets/icons/hacker.png",
                  cardColor: Colors.black26,
                  txt: "Anonim olarak devam et",
                  txtColor: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
