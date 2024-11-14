import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';

class CreatePassPage extends StatelessWidget {
  const CreatePassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoTextField(
            placeholder: 'Your name',
            onChanged: (name) {
              context.read<CreatePassBloc>().add(PassNameChanged(name));
            },
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            placeholder: 'Your job title',
            onChanged: (title) {
              context.read<CreatePassBloc>().add(PassTitleChanged(title));
            },
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            placeholder: 'Your company',
            onChanged: (company) {
              context.read<CreatePassBloc>().add(PassCompanyChanged(company));
            },
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16),
            child: SubmitButton(),
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
      (CreatePassBloc bloc) => bloc.state.status.isInProgress,
    );

    if (isInProgress) {
      return const CupertinoActivityIndicator();
    }

    final isFormValid = context.select(
      (CreatePassBloc bloc) => bloc.state.isFormValid,
    );

    final userId = context.select(
      (AppBloc bloc) => switch (bloc.state) {
        AppUnauthenticated() => null,
        AppAuthenticated(user: final user) => user.id,
      },
    );

    void onPressed() {
      context.read<CreatePassBloc>().add(PassRequested(userId: userId!));
      Navigator.of(context).pop();
    }

    return CupertinoButton.filled(
      onPressed: isFormValid && userId != null ? onPressed : null,
      child: const Text('Get my ticket!'),
    );
  }
}
