import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_list_cubit/user_list/cubit/user_list_cubit.dart';
import 'package:flutter_user_list_cubit/user_list/view/user_list_detail.dart';
// import 'package:futter_user_list_cubit/user_list/cubit/user_list_cubit.dart';
// import 'package:futter_user_list_cubit/user_list/cubit/user_list_state.dart';
// import 'package:futter_user_list_cubit/user_list/model/user.dart';
// import 'package:futter_user_list_cubit/user_list/view/user_detail_page.dart';

class UserListView extends StatelessWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Kata Mutiara Lorem Ipsum by Radafk",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: BlocBuilder<UserListCubit, UserListState>(
        builder: (context, state) {
          if (state is UserListSuccess) {
            return Scaffold(
              body: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  // Ambil teks body maksimal 55 karakter atau kurang
                  String bodyText = state.users[index].body.length > 55
                      ? state.users[index].body.substring(0, 55) + '...'
                      : state.users[index].body;

                  return Dismissible(
                    key: UniqueKey(), // Unique key for each item
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Hapus"),
                            content: const Text(
                                "Sayang loh, betulan mau dihapus nih?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Mikir lagi deh"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("Iya!"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (DismissDirection direction) {
                      // Call your cubit to delete the item
                      context
                          .read<UserListCubit>()
                          .deleteUser(state.users[index].id);
                    },
                    child: ListTile(
                      title: Text(state.users[index].title),
                      subtitle: Text(bodyText),
                      leading: const CircleAvatar(
                        backgroundColor: Color.fromRGBO(187, 111, 190, 1),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserDetailPage(user: state.users[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.read<UserListCubit>().fetchUser();
                },
                child: const Icon(Icons.refresh),
              ),
            );
          }

          if (state is UserListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UserListError) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<UserListCubit>().fetchUser();
              },
              child: const Text("Refresh"),
            ),
          );
        },
      ),
    );
  }
}