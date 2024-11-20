import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listenWhen: (previous, current) =>
              previous.status != current.status && current.status.isSuccess,
          listener: (context, state) {
            context.read<AppBloc>().add(AppSignUpCompleted(state.user!));
            Navigator.of(context).pop();
          },
        ),
        BlocListener<SignUpBloc, SignUpState>(
          listenWhen: (previous, current) =>
              previous.status != current.status && current.status.isFailure,
          listener: (context, state) async {
            await showCupertinoDialog<void>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text(l10n.signUpPageFailureDialogTitle),
                content: Text(l10n.signUpPageFailureDialogContent),
                actions: [
                  CupertinoDialogAction(
                    onPressed: Navigator.of(context).pop,
                    child: Text(l10n.signUpPageFailureDialogActionLabel),
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
    final l10n = context.l10n;
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            previousPageTitle: l10n.signInPageNavigationBarTitle,
            largeTitle: Text(l10n.signUpPageNavigationBarTitle),
            middle: Text(l10n.eventName),
            stretch: true,
            alwaysShowMiddle: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                CupertinoTextField(
                  placeholder: l10n.signUpPageUsernameTextFieldPlaceholder,
                  onChanged: (username) {
                    context
                        .read<SignUpBloc>()
                        .add(SignUpUsernameChanged(username));
                  },
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  placeholder: l10n.signUpPagePasswordTextFieldPlaceholder,
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
      child: Text(context.l10n.signUpPageSubmitButtonLabel),
    );
  }
}
