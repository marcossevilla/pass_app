import 'package:flutter/widgets.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/home/home.dart';
import 'package:pass_app/sign_in/sign_in.dart';

List<Page<void>> onGenerateAppPages(
  AppState state,
  List<Page<void>> pages,
) {
  return switch (state) {
    AppAuthenticated() => [HomePage.page()],
    AppUnauthenticated() => [SignInPage.page()],
  };
}
