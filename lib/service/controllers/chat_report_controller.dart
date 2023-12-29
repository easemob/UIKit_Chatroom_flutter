import 'package:flutter/widgets.dart';

abstract class ChatReportController {
  String title(BuildContext context);
  Map<String, String> reportList(BuildContext context);
  Future<void> report(
    BuildContext context,
    String roomId,
    String messageId,
    String tag,
    String reason,
  );
}
