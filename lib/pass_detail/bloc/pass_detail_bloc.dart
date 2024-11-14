import 'package:apple_passkit/apple_passkit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passkit/passkit.dart';

part 'pass_detail_event.dart';
part 'pass_detail_state.dart';

class PassDetailBloc extends Bloc<PassDetailEvent, PassDetailState> {
  PassDetailBloc({
    ApplePassKit? passKit,
  })  : _passKit = passKit ?? ApplePassKit(),
        super(const PassDetailState()) {
    on<PassDetailPassAdded>(_onPassAdded);
  }

  final ApplePassKit _passKit;

  Future<void> _onPassAdded(
    PassDetailPassAdded event,
    Emitter<PassDetailState> emit,
  ) async {
    final conditions = await Future.wait([
      _passKit.isPassLibraryAvailable(),
      _passKit.canAddPasses(),
    ]);

    if (conditions.every((condition) => condition)) {
      await _passKit.addPass(event.pass.sourceData!);
    }
  }
}
