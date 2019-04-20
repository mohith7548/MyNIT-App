import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validate/validate.dart';

String validateEmail(String value) {
  if (value.isEmpty) {
    return 'please enter email address';
  }
  try {
    Validate.isEmail(value);
  } catch (e) {
    return 'The E-mail Address must be a valid email address.';
  }
  return null;
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return 'please enter password';
  }
  if (value.length < 6) {
    return 'please enter more than 6 characters';
  }
  return null;
}

String validateRegNo(String value) {
  // TODO: Set Bounds for the Registration Number
  if (value.trim().isEmpty) {
    return 'please enter registration number';
  }
  return null;
}

dynamic getPrefs({@required String saveInName}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get(saveInName);
}

savePrefs({@required String saveInName, @required dynamic data}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (data.runtimeType) {
    case String:
      prefs.setString(saveInName, data);
      break;

    case bool:
      prefs.setBool(saveInName, data);
      break;

    case int:
      prefs.setInt(saveInName, data);
      break;

    default:
      throw Exception('Invalid Type Data');
      break;
  }
}

showSnackbar({
  @required dynamic scaffoldState,
  @required String msg,
  int milliSeconds: 0,
  int seconds: 0,
}) {
  /// Always specify duration in seconds or milliseconds!
  SnackBar snackbar = SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: milliSeconds, seconds: seconds),
  );
  scaffoldState.showSnackBar(snackbar);
}

sendTo(
    {@required BuildContext context,
    @required Widget page,
    @required AppState appState}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AppState(
            firebaseUser: appState.firebaseUser,
            user: appState.user,
            changeTheme: appState.changeTheme,
            isDarkThemeEnabled: appState.isDarkThemeEnabled,
            child: page,
          ),
    ),
  );
}

String validateName(String value) {
  if (value.isEmpty || value == "") {
    return 'FullName is required.';
  }
  final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
  if (!nameExp.hasMatch(value)) {
    return 'Please enter only alphabetical characters.';
  }
  return null;
}

String getDurationString(Duration duration) {
  String timeAgo = '';
  if (duration.inDays >= 1) {
    String d = (duration.inDays == 1) ? 'day' : 'days';
    timeAgo = '${duration.inDays} $d';
    duration = duration - Duration(days: duration.inDays);
  }
  if (duration.inHours >= 1) {
    String h = (duration.inHours == 1) ? 'hr' : 'hrs';
    timeAgo = '$timeAgo ${duration.inHours} $h';
    duration = duration - Duration(days: duration.inHours);
  }
  if (duration.inMinutes >= 1) {
    String m = (duration.inMinutes == 1) ? 'min' : 'mins';
    timeAgo = '$timeAgo ${duration.inMinutes} $m';
    duration = duration - Duration(days: duration.inMinutes);
  }
  if (duration.inSeconds >= 1) {
    timeAgo = '$timeAgo ${duration.inSeconds} sec';
  }
  return timeAgo;
}
