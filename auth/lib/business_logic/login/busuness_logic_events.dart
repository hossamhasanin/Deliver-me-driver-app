import 'package:equatable/equatable.dart';

abstract class BusinessLogicEvents extends Equatable {
  const BusinessLogicEvents();
  @override
  List<Object?> get props => [];
}

class ShowLoadingDialog extends BusinessLogicEvents{}
class ShowErrorDialog extends BusinessLogicEvents{
  final String error;

  const ShowErrorDialog(this.error);
  @override
  List<Object?> get props => [error];
}
class ShowSuccessFullLoginDialog extends BusinessLogicEvents{}
class ShowGoToFillAccountDataDialog extends BusinessLogicEvents{}
