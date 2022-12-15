import 'package:admin_app/data/models/user_model.dart';
import 'package:admin_app/data/repositories/users_repository.dart';
import 'package:flutter/cupertino.dart';

class UsersViewModel extends ChangeNotifier{
 final UsersRepository usersRepository;

 UsersViewModel({required this.usersRepository});

 Stream<List<UserModel>> listenUsers() => usersRepository.getUsers();

 deleteUser(String docId) =>
      usersRepository.deleteUser(docId: docId);
}