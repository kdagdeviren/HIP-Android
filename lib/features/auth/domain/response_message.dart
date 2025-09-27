class ResponseMessage {
  final bool status;
  final String message;
  final String? docId;

  ResponseMessage({required this.status, required this.message, this.docId});
}
