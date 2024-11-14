import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/sign_up/sign_up.dart';
import 'package:user_repository/user_repository.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return CupertinoPageRoute<void>(
      builder: (context) => const SignUpPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listenWhen: (previous, current) {
            return previous != current && current.status.isSuccess;
          },
          listener: (context, state) {
            context.read<AppBloc>().add(AppSignUpCompleted(state.user!));
            Navigator.of(context).pop();
          },
        ),
        BlocListener<SignUpBloc, SignUpState>(
          listenWhen: (previous, current) {
            return previous != current && current.status.isFailure;
          },
          listener: (context, state) async {
            await showCupertinoDialog<void>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Sign up failure'),
                content: const Text('Please try again later.'),
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
      child: const SignUpContent(),
    );
  }
}

class SignUpContent extends StatelessWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            previousPageTitle: 'Sign in',
            largeTitle: Text('Sign up'),
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
                        .read<SignUpBloc>()
                        .add(SignUpUsernameChanged(username));
                  },
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  placeholder: 'Your password',
                  obscureText: true,
                  onChanged: (password) {
                    context
                        .read<SignUpBloc>()
                        .add(SignUpPasswordChanged(password));
                  },
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SubmitButton(),
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
      (SignUpBloc bloc) => bloc.state.status.isInProgress,
    );

    if (isInProgress) {
      return const CupertinoActivityIndicator();
    }

    final isFormValid = context.select(
      (SignUpBloc bloc) => bloc.state.isFormValid,
    );

    return CupertinoButton.filled(
      onPressed: isFormValid
          ? () => context.read<SignUpBloc>().add(const SignUpFormSubmitted())
          : null,
      child: const Text('Create account'),
    );
  }
}
