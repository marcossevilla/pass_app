import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FlutterLogo;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/sign_in/sign_in.dart';
import 'package:pass_app/sign_up/sign_up.dart';
import 'package:user_repository/user_repository.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static Page<void> page() {
    return const CupertinoPage<void>(
      child: SignInPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignInBloc, SignInState>(
          listenWhen: (previous, current) {
            return previous != current && current.status.isSuccess;
          },
          listener: (context, state) {
            context.read<AppBloc>().add(AppUserSignedIn(state.user!));
          },
        ),
        BlocListener<SignInBloc, SignInState>(
          listenWhen: (previous, current) {
            return previous != current && current.status.isFailure;
          },
          listener: (context, state) async {
            await showCupertinoDialog<void>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Sign in failure'),
                content: const Text(
                  'Please make sure your credentials are correct.',
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      child: const SignInContent(),
    );
  }
}

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            leading: FlutterLogo(),
            largeTitle: Text('Sign in'),
            middle: Text('FlutterConf Latam 2024'),
            stretch: true,
            alwaysShowMiddle: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                CupertinoTextField(
                  placeholder: 'Your username',
                  onChanged: (username) {
                    context
                        .read<SignInBloc>()
                        .add(SignInUsernameChanged(username));
                  },
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  placeholder: 'Your password',
                  obscureText: true,
                  onChanged: (password) {
                    context
                        .read<SignInBloc>()
                        .add(SignInPasswordChanged(password));
                  },
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SubmitButton(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CupertinoButton(
                    child: const Text("I don't have an account"),
                    onPressed: () => Navigator.of(context).push(
                      SignUpPage.route(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  @visibleForTesting
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (SignInBloc bloc) => bloc.state.status.isInProgress,
    );

    if (isInProgress) {
      return const CupertinoActivityIndicator();
    }

    final isFormValid = context.select(
      (SignInBloc bloc) => bloc.state.isFormValid,
    );

    return CupertinoButton.filled(
      onPressed: isFormValid
          ? () => context.read<SignInBloc>().add(const SignInFormSubmitted())
          : null,
      child: const Text('Sign in'),
    );
  }
}
