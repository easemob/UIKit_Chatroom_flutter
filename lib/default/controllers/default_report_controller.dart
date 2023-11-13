import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/widgets.dart';

class DefaultReportController extends ChatReportController {
  @override
  List<String> reportList(BuildContext context) {
    return [
      ChatroomLocal.violationReason_1.getString(context),
      ChatroomLocal.violationReason_2.getString(context),
      ChatroomLocal.violationReason_3.getString(context),
      ChatroomLocal.violationReason_4.getString(context),
      ChatroomLocal.violationReason_5.getString(context),
      ChatroomLocal.violationReason_6.getString(context),
      ChatroomLocal.violationReason_7.getString(context),
      ChatroomLocal.violationReason_8.getString(context),
      ChatroomLocal.violationReason_9.getString(context),
    ];
  }

  @override
  String title(BuildContext context) {
    return ChatroomLocal.report.getString(context);
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
      await ChatRoomUIKitClient.instance.report(
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
