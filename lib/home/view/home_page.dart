import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FlutterLogo;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';
import 'package:pass_app/home/passes.dart';
import 'package:pass_app/pass_detail/pass_detail.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:passkit/passkit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() {
    return const CupertinoPage<void>(
      child: HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.select(
      (AppBloc bloc) => switch (bloc.state) {
        AppUnauthenticated() => null,
        AppAuthenticated(user: final user) => user.id,
      },
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(
            passRepository: context.read<PassRepository>(),
          )..add(HomePassesRequested(userId!)),
        ),
        BlocProvider(
          create: (context) => CreatePassBloc(
            passRepository: context.read<PassRepository>(),
          ),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select(
      (AppBloc bloc) => switch (bloc.state) {
        AppUnauthenticated() => null,
        AppAuthenticated(user: final user) => user.id,
      },
    );

    return BlocListener<CreatePassBloc, CreatePassState>(
      listenWhen: (previous, current) {
        final didPassChange = previous.pass != current.pass;
        final isPassNull = current.pass == null;
        return didPassChange && !isPassNull;
      },
      listener: (context, state) {
        context.read<HomeBloc>().add(HomePassesRequested(userId!));
      },
      child: const HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            alwaysShowMiddle: false,
            stretch: true,
            leading: const FlutterLogo(),
            largeTitle: const Text('My passes'),
            trailing: CupertinoButton(
              onPressed: () => showCupertinoModalBottomSheet<void>(
                context: context,
                useRootNavigator: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<CreatePassBloc>(),
                  child: const CreatePassPage(),
                ),
              ),
              child: const Icon(CupertinoIcons.add_circled),
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => switch (state.status) {
              HomeStatus.initial ||
              HomeStatus.loading =>
                const SliverFillRemaining(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              HomeStatus.failure => const SliverFillRemaining(
                  child: Center(
                    child: Text('Something went wrong!'),
                  ),
                ),
              HomeStatus.success => PassList(passes: state.passes),
            },
          ),
        ],
      ),
    );
  }
}

class PassList extends StatelessWidget {
  const PassList({
    required this.passes,
    super.key,
  });

  final List<PkPass> passes;

  @override
  Widget build(BuildContext context) {
    if (passes.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text('You do not have passes yet...'),
        ),
      );
    }

    return SliverList.list(
      children: [
        ...passes.map(
          (pass) {
            final ticket = pass.pass.eventTicket;
            return CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
              leading: const Icon(CupertinoIcons.person_fill),
              title: Text(
                ticket?.auxiliaryFields?.first.value.toString() ?? '',
              ),
              subtitle: Text(
                ticket?.auxiliaryFields?[1].value.toString() ?? '',
              ),
              onTap: () => Navigator.of(context).push(
                PassDetailPage.route(pass: pass),
              ),
            );
          },
        ),
      ],
    );
  }
}
