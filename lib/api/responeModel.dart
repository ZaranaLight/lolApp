class ResponseModel {
  bool _isSuccess;
  String _message;
  Map<String, dynamic> _responceData;
  ResponseModel(this._isSuccess, this._message, this._responceData);

  String get message => _message;
  bool get isSuccess => _isSuccess;
  Map<String, dynamic> get responceData => _responceData;
}
