import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_app/l10n/l10n.dart';
import 'package:pass_app/pass_detail/pass_detail.dart';
import 'package:passkit/passkit.dart';
import 'package:passkit_ui/passkit_ui.dart';

class PassDetailPage extends StatelessWidget {
  const PassDetailPage({
    required this.pass,
    super.key,
  });

  static Route<void> route({required PkPass pass}) {
    return CupertinoPageRoute(
      builder: (context) => PassDetailPage(pass: pass),
      settings: const RouteSettings(name: routeName),
    );
  }

  static const routeName = '/pass_detail';

  final PkPass pass;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PassDetailBloc(pass: pass),
      child: const PassDetailView(),
    );
  }
}

class PassDetailView extends StatelessWidget {
  const PassDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pass = context.select((PassDetailBloc bloc) => bloc.state.pass);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            previousPageTitle: l10n.homePageNavigationBarTitle,
            largeTitle: Text(l10n.passDetailPageNavigationBarTitle),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: PkPassWidget(pass: pass),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton.filled(
                child: Text(l10n.passDetailPageAddToWalletButtonLabel),
                onPressed: () => context.read<PassDetailBloc>().add(
                  PassDetailPassAdded(pass),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
