import 'package:flutter/widgets.dart';

abstract class ChatReportController {
  String title(BuildContext context);
  List<String> reportList(BuildContext context);
  Future<void> report(
    BuildContext context,
    String roomId,
    String messageId,
    String tag,
    String reason,
  );
}
