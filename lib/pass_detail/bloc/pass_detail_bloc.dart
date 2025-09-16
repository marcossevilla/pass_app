import 'package:apple_passkit/apple_passkit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passkit/passkit.dart';

part 'pass_detail_event.dart';
part 'pass_detail_state.dart';

class PassDetailBloc extends Bloc<PassDetailEvent, PassDetailState> {
  PassDetailBloc({
    required PkPass pass,
    ApplePassKit? passKit,
  }) : _passKit = passKit ?? ApplePassKit(),
       super(PassDetailState(pass: pass)) {
    on<PassDetailPassAdded>(_onPassAdded);
  }

  final ApplePassKit _passKit;

  Future<void> _onPassAdded(
    PassDetailPassAdded event,
    Emitter<PassDetailState> emit,
  ) async {
    try {
      final conditions = await Future.wait([
        _passKit.isPassLibraryAvailable(),
        _passKit.canAddPasses(),
      ]);

      if (conditions.every((condition) => condition)) {
        await _passKit.addPass(event.pass.sourceData!);
        emit(state.copyWith(status: PassDetailStatus.added));
      }
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: PassDetailStatus.failure));
    }
  }
}
