import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FlutterLogo;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';
import 'package:pass_app/home/home.dart';
import 'package:pass_app/l10n/l10n.dart';
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
      listenWhen: (previous, current) => previous.pass != current.pass,
      listener: (context, state) {
        if (state.pass != null) {
          context.read<HomeBloc>().add(HomePassesRequested(userId!));
        }
      },
      child: const HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  @visibleForTesting
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            alwaysShowMiddle: false,
            stretch: true,
            leading: const FlutterLogo(),
            largeTitle: Text(l10n.homePageNavigationBarTitle),
            trailing: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  CreatePassSheet.route(
                    createPassBloc: context.read<CreatePassBloc>(),
                  ),
                );
              },
              child: const Icon(CupertinoIcons.add),
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
              HomeStatus.failure => SliverFillRemaining(
                  child: Center(
                    child: Text(l10n.genericFailureText),
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
      return SliverFillRemaining(
        child: Center(
          child: Text(context.l10n.homePageEmptyPassListText),
        ),
      );
    }

    return SliverList.list(
      children: [
        ...passes.map(
          (pass) {
            final eventTicket = pass.pass.eventTicket;
            return CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
              leading: const Icon(CupertinoIcons.person_fill),
              title: Text(
                eventTicket?.auxiliaryFields?.first.value.toString() ?? '',
              ),
              subtitle: Text(
                eventTicket?.auxiliaryFields?[1].value.toString() ?? '',
              ),
              onTap: () async {
                await Navigator.of(context).push<void>(
                  PassDetailPage.route(pass: pass),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
