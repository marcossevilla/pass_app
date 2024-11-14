import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      builder: (_) => PassDetailPage(pass: pass),
      settings: const RouteSettings(name: routeName),
    );
  }

  static const routeName = '/pass_detail';

  final PkPass pass;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PassDetailBloc(),
      child: PassDetailView(pass: pass),
    );
  }
}

class PassDetailView extends StatelessWidget {
  const PassDetailView({
    required this.pass,
    super.key,
  });

  final PkPass pass;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            previousPageTitle: 'My passes',
            largeTitle: Text('Pass Details'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: PkPassWidget(
                pass: pass,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton.filled(
                child: const Text('Add to Wallet'),
                onPressed: () => context
                    .read<PassDetailBloc>()
                    .add(PassDetailPassAdded(pass)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
