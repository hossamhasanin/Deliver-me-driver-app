class FillAccountDataViewState{
  final bool loading;
  final String error;
  final bool done;

  FillAccountDataViewState({
    required this.loading,
    required this.error,
    required this.done
  });

  FillAccountDataViewState copy({
    bool? loading,
    String? error,
    bool? done
  }){
    return FillAccountDataViewState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        done: done ?? this.done
    );
  }
}