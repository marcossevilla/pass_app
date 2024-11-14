import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:passkit/passkit.dart';

part 'create_pass_event.dart';
part 'create_pass_state.dart';

class CreatePassBloc extends Bloc<CreatePassEvent, CreatePassState> {
  CreatePassBloc({
    required PassRepository passRepository,
  })  : _passRepository = passRepository,
        super(const CreatePassState()) {
    on<PassNameChanged>(_onNameChanged);
    on<PassTitleChanged>(_onTitleChanged);
    on<PassCompanyChanged>(_onCompanyChanged);
    on<PassRequested>(_onPassRequested);
  }

  final PassRepository _passRepository;

  void _onNameChanged(
    PassNameChanged event,
    Emitter<CreatePassState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
      ),
    );
  }

  void _onTitleChanged(
    PassTitleChanged event,
    Emitter<CreatePassState> emit,
  ) {
    emit(
      state.copyWith(
        title: event.title,
      ),
    );
  }

  void _onCompanyChanged(
    PassCompanyChanged event,
    Emitter<CreatePassState> emit,
  ) {
    emit(
      state.copyWith(
        company: event.company,
      ),
    );
  }

  Future<void> _onPassRequested(
    PassRequested event,
    Emitter<CreatePassState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      final pass = await _passRepository.create(
        userId: event.userId,
        passData: EventPassRequest(
          name: state.name ?? '',
          title: state.title ?? '',
          company: state.company ?? '',
        ).toPassData(),
      );

      emit(
        state.copyWith(
          pass: pass,
          status: FormzSubmissionStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
