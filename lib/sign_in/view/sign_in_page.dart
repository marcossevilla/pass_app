import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FlutterLogo;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<SignInBloc, SignInState>(
          listenWhen: (previous, current) =>
              previous.status != current.status && current.status.isSuccess,
          listener: (context, state) {
            context.read<AppBloc>().add(AppUserSignedIn(state.user!));
          },
        ),
        BlocListener<SignInBloc, SignInState>(
          listenWhen: (previous, current) =>
              previous.status != current.status && current.status.isFailure,
          listener: (context, state) async {
            await showCupertinoDialog<void>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text(l10n.signInPageFailureDialogTitle),
                content: Text(l10n.signInPageFailureDialogContent),
                actions: [
                  CupertinoDialogAction(
                    onPressed: Navigator.of(context).pop,
                    child: Text(l10n.signInPageFailureDialogActionLabel),
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
    final l10n = context.l10n;
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            leading: const FlutterLogo(),
            largeTitle: Text(l10n.signInPageNavigationBarTitle),
            middle: Text(l10n.eventName),
            stretch: true,
            alwaysShowMiddle: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                CupertinoTextField(
                  placeholder: l10n.signInPageUsernameTextFieldPlaceholder,
                  onChanged: (username) {
                    context
                        .read<SignInBloc>()
                        .add(SignInUsernameChanged(username));
                  },
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  placeholder: l10n.signInPagePasswordTextFieldPlaceholder,
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
                    child: Text(l10n.signInPageCreateAccountButtonLabel),
                    onPressed: () async {
                      await Navigator.of(context).push<void>(
                        SignUpPage.route(),
                      );
                    },
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
      child: Text(context.l10n.signInPageSubmitButtonLabel),
    );
  }
}
