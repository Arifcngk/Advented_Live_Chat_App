import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/screen/widgets/bottom_bar_control.dart';
import 'package:live_chat/screen/chat_room_view_screen.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersViewScreen extends StatefulWidget {
  @override
  _UsersViewScreenState createState() => _UsersViewScreenState();
}

class _UsersViewScreenState extends State<UsersViewScreen> {
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _usersFuture = userViewModel.getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kullanıcılar',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
        centerTitle: false,
        backgroundColor: Color(0xFFF8FAFC),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Kullanıcı bulunamadı.'));
          } else {
            var users = snapshot.data!;
            final userViewModel = Provider.of<UserViewModel>(context);

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];

                if (userViewModel.user != null &&
                    user.userID == userViewModel.user!.userID) {
                  return SizedBox.shrink();
                }

                return InkWell(
                  onTap: () async {
                    // Bottom bar’ı gizle
                    final bottomBarControl = InheritedBottomBarControl.of(
                      context,
                    );
                    bottomBarControl?.toggleBottomBar(false);

                    // ChatRoomViewScreen’e geçiş ve geri dönüşü bekle
                    await Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder:
                            (context) => ChatRoomViewScreen(
                              currentUser: userViewModel.user,
                              chatUser: user,
                              onPop: () {
                                bottomBarControl?.toggleBottomBar(true);
                              },
                            ),
                      ),
                    );

                    // Geri dönüldüğünde tab bar’ı kesinlikle göster
                    bottomBarControl?.toggleBottomBar(true);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          user.profileURL != null
                              ? NetworkImage(user.profileURL!)
                              : null,
                      child:
                          user.profileURL == null ? Icon(Icons.person) : null,
                    ),
                    title: Text(
                      user.userName ?? "Kullanıcı adı yok",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      user.email ?? "Email adresi yok",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
