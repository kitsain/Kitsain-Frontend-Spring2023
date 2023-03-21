import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class LoginController extends GetxController {
  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;
  var googleUser = Rx<GoogleSignInAccount?>(null);

  var taskApi = Rx<TasksApi?>(null);
  var taskLists = Rx<TaskLists?>(null);

  Future googleLogin() async {
    final googleSignIn = GoogleSignIn(scopes: [TasksApi.tasksScope]);
    googleUser.value = await googleSignIn.signIn();

    var httpClient = (await googleSignIn.authenticatedClient())!;

    TasksApi taskapi = TasksApi(httpClient);

    var tskList = await taskapi.tasklists.list();
    taskLists.value = tskList;

    print('ok');

    // print(tskList.items!.last.title);
    // print(tskList.items!.last.id);

    // await taskapi.tasklists
    //     .insert(TaskList(title: 'task12', id: 'task12id'), $fields: '');
    print(tskList.items!.last.title);
    print(tskList.items!.last.id);
    taskApi.value = taskapi;

    // final googleUser = await googleSignIn.signIn();

    // if (googleUser == null) return;
    // _user = googleUser;

    // final googleAuth = await googleUser.authentication;

    // final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
