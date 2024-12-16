import '../../../inner_headers.dart';
import 'package:flutter/widgets.dart';

class DefaultReportController extends ChatReportController {
  @override
  Map<String, String> reportList(BuildContext context, String messageId) {
    return ChatRoomSettings.reportMap ??
        {
          'tag1': ChatroomLocal.violationReason_1.getString(context),
          'tag2': ChatroomLocal.violationReason_2.getString(context),
          'tag3': ChatroomLocal.violationReason_3.getString(context),
          'tag4': ChatroomLocal.violationReason_4.getString(context),
          'tag5': ChatroomLocal.violationReason_5.getString(context),
          'tag6': ChatroomLocal.violationReason_6.getString(context),
          'tag7': ChatroomLocal.violationReason_7.getString(context),
          'tag8': ChatroomLocal.violationReason_8.getString(context),
          'tag9': ChatroomLocal.violationReason_9.getString(context),
        };
  }

  @override
  String title(BuildContext context) {
    return ChatRoomSettings.reportTitle ??
        ChatroomLocal.report.getString(context);
  }

  @override
  Future<void> report(
    BuildContext context,
    String roomId,
    String messageId,
    String tag,
    String reason,
  ) async {
    try {
      await ChatroomUIKitClient.instance.report(
        roomId: roomId,
        messageId: messageId,
        tag: tag,
        reason: reason,
      );
    } catch (e) {
      vLog(e.toString());
    }
  }
}
