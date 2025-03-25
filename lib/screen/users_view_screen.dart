import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/screen/chat_room_view_screen.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getAllUser();

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
        future: userViewModel.getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var getAlluser = snapshot.data;
            if (getAlluser!.length - 1 > 0) {
              return ListView.builder(
                itemCount: getAlluser.length,
                itemBuilder: (context, index) {
                  if (snapshot.data![index].userID !=
                      userViewModel.user!.userID) {
                    var isSelectedUser = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        // rootnavigator bak
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => ChatRoomViewScreen(
                                  currentUser: userViewModel.user,
                                  chatUser: isSelectedUser,
                                ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            isSelectedUser.profileURL ?? "",
                          ),
                        ),
                        title: Text(
                          isSelectedUser.userName ?? "kullanıcı adı yok",
                        ),
                        subtitle: Text(
                          isSelectedUser.email ?? "email adresi yok",
                        ),
                      ),
                    );
                  }
                  return null;
                },
              );
            } else {
              return Center(child: Text("Upps Bir Sorun var Gibi"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
