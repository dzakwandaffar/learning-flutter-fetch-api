import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_user_list_cubit/user_list/model/user.dart';

part "user_list_state.dart";

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(const UserListState.initial());

  fetchUser() async {
    try {
      emit(const UserListState.loading());
      Dio dio = Dio();

      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        final List<User> users = res.data.map<User>((d) {
          return User.fromJson(d);
        }).toList();

        emit(UserListState.success(users));
      } else {
        emit(UserListState.error("error loading data: ${res.data.toString()}"));
      }
    } catch (e) {
      emit(UserListState.error("error loading data: ${e.toString()}"));
    }
  }
  deleteUser(int userId) {
    state.maybeWhen(
      success: (List<User> users) {
        final updatedUsers = users.where((user) => user.id != userId).toList();
        emit(UserListState.success(updatedUsers));
      },
      error: (String message) {
        emit(UserListState.error(
            "Cannot delete user, state status is error: $message"));
      },
      orElse: () {
        // Handle cases where state is not success or error
      },
    );
  }
}


// String adjustText(String text){
//   var lengthText = text.length;
//   if(lengthText > 40){
//     return text;
//   }
//   else if (lengthText < 55) {
//     return text;
//   }
// }
