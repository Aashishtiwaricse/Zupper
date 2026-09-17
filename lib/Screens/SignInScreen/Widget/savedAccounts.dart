import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuperr/Models/SavedAccount/savedAccount.dart';

Future<void> saveRememberedAccount(
    String email,
    String password,
) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> list =
      prefs.getStringList("saved_accounts") ?? [];

  List<SavedAccount> accounts = list
      .map((e) => SavedAccount.fromJson(jsonDecode(e)))
      .toList();

  // Remove duplicate email
  accounts.removeWhere((e) => e.email == email);

  accounts.insert(
      0,
      SavedAccount(
        email: email,
        password: password,
      ));

  await prefs.setStringList(
    "saved_accounts",
    accounts.map((e) => jsonEncode(e.toJson())).toList(),
  );
}