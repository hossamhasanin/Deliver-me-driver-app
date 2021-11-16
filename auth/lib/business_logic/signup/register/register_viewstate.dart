class RegisterViewState{
  final bool loading;
  final String error;
  final bool done;

  RegisterViewState({
    required this.loading,
    required this.error,
    required this.done
  });

  RegisterViewState copy({
    bool? loading,
    String? error,
    bool? done
  }){
    return RegisterViewState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        done: done ?? this.done
    );
  }
}