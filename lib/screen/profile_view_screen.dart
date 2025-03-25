import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_chat/screen/auth/widgets/custom_btn_widget.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final TextEditingController _controllerUserName = TextEditingController();
  File? userProfilePhoto;
  final ImagePicker picker = ImagePicker();

  // Galeriden fotoğraf seçme
  void _chooseGallerySelected(BuildContext context) async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        Navigator.of(context).pop();
        userProfilePhoto = File(pickedImage.path);
      });
    }
  }

  // Kameradan fotoğraf seçme
  void _chooseCameraSelected(BuildContext context) async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        Navigator.of(context).pop();
        userProfilePhoto = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      _controllerUserName.text = userViewModel.user?.userName ?? "";
    });
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    Future<bool?> signOut(BuildContext context) async {
      bool? result = await userViewModel.signOut();
      return result;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFF8FAFC),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              onPressed: () => signOut(context),
              icon: const Icon(Icons.logout_sharp),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _userCircleImages(userViewModel, context),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    userViewModel.user?.email ?? "user email yok",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _controllerUserName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    label: const Text("Kullanıcı Adı"),
                    hintText: "Kullanıcı Adını Gir",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    await _updateProfile(userViewModel);
                  },
                  child: const CustomButtonWidget(
                    txt: "Güncelle",
                    imagePath: false,
                    txtColor: Colors.white,
                    cardColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack _userCircleImages(UserViewModel userViewModel, BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (userProfilePhoto != null)
          CircleAvatar(
            radius: 70,
            backgroundImage: FileImage(userProfilePhoto!),
          )
        else if (userViewModel.user?.profileURL != null)
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(userViewModel.user!.profileURL!),
          )
        else
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 50),
          ),
        Positioned(
          height: 40,
          width: 40,
          bottom: 4,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text("Galeriden Seç"),
                            onTap: () => _chooseGallerySelected(context),
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text("Kameradan Seç"),
                            onTap: () => _chooseCameraSelected(context),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateProfile(UserViewModel userViewModel) async {
    try {
      // Null kontrolü
      if (userViewModel.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kullanıcı bulunamadı"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Kullanıcı adı güncelleme
      if (_controllerUserName.text.isNotEmpty &&
          userViewModel.user!.userName != _controllerUserName.text) {
        bool result = await userViewModel.updateUserName(
          userViewModel.user!.userID,
          _controllerUserName.text,
        );
        if (result) {
          setState(() {
            userViewModel.user!.userName = _controllerUserName.text;
          });
          print("Kullanıcı adı güncellendi: ${_controllerUserName.text}");
        } else {
          print("Kullanıcı adı güncellenemedi.");
        }
      }

      // Fotoğraf güncelleme
      if (userProfilePhoto != null) {
        String downloadURL = await userViewModel.uploadFile(
          // uploadClouderaFile yerine uploadFile kullanıldı
          userViewModel.user!.userID,
          "profile_photo",
          userProfilePhoto!,
        );
        if (downloadURL.isNotEmpty) {
          setState(() {
            userViewModel.user!.profileURL =
                downloadURL; // Profil URL’sini güncelle
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Fotoğraf başarıyla güncellendi"),
              backgroundColor: Colors.green,
            ),
          );
          print("Fotoğraf yüklendi: $downloadURL");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Fotoğraf yüklenemedi"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Profil güncelleme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
