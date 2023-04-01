import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';

class LoginController extends GetxController {
  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;
  var googleUser = Rx<GoogleSignInAccount?>(null);
  var googleSignInUser = Rx<GoogleSignIn?>(null);

  var taskApiAuthenticated = Rx<TasksApi?>(null);

  Future googleLogin() async {
    final googleSignIn = GoogleSignIn(scopes: [TasksApi.tasksScope]);
    googleUser.value = await googleSignIn.signIn();

    googleSignInUser.value = googleSignIn;

    var httpClient = (await googleSignIn.authenticatedClient())!;

    TasksApi taskapi = TasksApi(httpClient);

    taskApiAuthenticated.value = taskapi;

    // var tstlistCount = await taskApiAuthenticated.value?.tasklists.list();

    print(taskApiAuthenticated.value?.tasklists.list());
    print(taskapi.tasklists.list());
    var tskList = await taskApiAuthenticated.value?.tasklists.list();
    // taskLists.value = tskList;

    print('ok');
    print(tskList?.items!.last.title);
    // print(tskList.items!.last.id);

    // await taskapi.tasklists
    //     .insert(TaskList(title: 'task12', id: 'task12id'), $fields: '');

    // final googleUser = await googleSignIn.signIn();

    // if (googleUser == null) return;
    // _user = googleUser;

    // final googleAuth = await googleUser.authentication;

    // final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
