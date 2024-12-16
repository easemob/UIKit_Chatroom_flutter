mixin ChatroomLocal {
  static const String sent = 'sent';
  static const String joined = "joined";
  static const String postSuccess = "postSuccess";
  static const String postFailed = 'postFailed';
  static const String welcome = "welcome";
  static const String joinedSuccessful = "joinedSuccessful";
  static const String joinImFailed = 'joinImFailed';
  static const String noticePosted = "noticePosted";
  static const String contentProhibited = "contentProhibited";
  static const String kickedOutRoom = 'kickedOutRoom';
  static const String startChat = "startChat";
  static const String report = "report";
  static const String giftSent = "giftSent";
  static const String violationOptions = "violationOptions";
  static const String bottomSheetPrivateChat =
      'barrage_long_press_menu_private_chat';
  static const String bottomSheetTranslate =
      'barrage_long_press_menu_translate';
  static const String bottomSheetDelete = 'barrage_long_press_menu_delete';
  static const String bottomSheetMute = 'barrage_long_press_menu_mute';
  static const String bottomSheetUnmute = 'barrage_long_press_menu_unmute';
  static const String bottomSheetReport = 'barrage_long_press_menu_report';
  static const String bottomSheetPin = 'barrage_long_press_menu_pin';
  static const String bottomSheetUnpin = 'barrage_long_press_menu_unpin';
  static const String bottomSheetRemove = 'barrage_long_press_menu_remove';
  static const String bottomSheetCancel = 'barrage_long_press_menu_cancel';
  static const String reportButtonClickMenuTitle =
      'report_button_click_menu_title';
  static const String dialogCancel = 'dialogCancel';
  static const String dialogConfirm = 'Confirm';
  static const String dialogDelete = 'delete';
  static const String memberListTitle = 'participant_list_title';
  static const String muteListTitle = 'ban_list';
  static const String violationReason_1 = "violationReason_1";
  static const String violationReason_2 = "violationReason_2";
  static const String violationReason_3 = "violationReason_3";
  static const String violationReason_4 = "violationReason_4";
  static const String violationReason_5 = "violationReason_5";
  static const String violationReason_6 = "violationReason_6";
  static const String violationReason_7 = "violationReason_7";
  static const String violationReason_8 = "violationReason_8";
  static const String violationReason_9 = "violationReason_9";
  static const String search = "search";
  static const String cancel = "cancel";
  static const String memberRemove = "memberRemove";
  static const String hasBeenMuted = "hasBeenMuted";
  static const String newMessage = "newMessage";
  static const String wantRemove = "wantRemove";

  static const Map<String, dynamic> zh = {
    sent: '发送',
    giftSent: '送了',
    joined: "进入聊天室",
    postSuccess: "发布成功",
    postFailed: '发布失败',
    welcome: "欢迎来到",
    joinedSuccessful: "加入成功",
    joinImFailed: '加入聊天室失败',
    noticePosted: "公告已发布",
    contentProhibited: "内容含有敏感词",
    kickedOutRoom: '您已经被踢出聊天室',
    startChat: "发条弹幕吧~",
    report: "举报",
    violationOptions: "违规选项",
    bottomSheetPrivateChat: '私聊',
    bottomSheetTranslate: '翻译',
    bottomSheetDelete: '撤回',
    bottomSheetMute: '禁言',
    bottomSheetUnmute: '解除禁言',
    bottomSheetReport: '举报',
    bottomSheetPin: "置顶",
    bottomSheetUnpin: "取消置顶",
    bottomSheetRemove: "移除",
    bottomSheetCancel: '取消',
    reportButtonClickMenuTitle: '举报',
    dialogCancel: '取消',
    dialogConfirm: '确定',
    dialogDelete: '删除',
    memberListTitle: '成员列表',
    muteListTitle: '禁言列表',
    violationReason_1: "不受欢迎的商业内容或垃圾内容",
    violationReason_2: "色情或露骨内容",
    violationReason_3: "虐待儿童",
    violationReason_4: "仇恨言论或过于写实的暴力内容",
    violationReason_5: "宣扬恐怖主义",
    violationReason_6: "骚扰或欺凌",
    violationReason_7: "自杀或自残",
    violationReason_8: "虚假信息",
    violationReason_9: "其他",
    search: "搜索",
    cancel: "取消",
    memberRemove: "移除",
    hasBeenMuted: "已被禁言",
    newMessage: "条新消息",
    wantRemove: "移除",
  };
  static const Map<String, dynamic> en = {
    sent: 'Sent',
    joined: "Joined",
    giftSent: 'Sent',
    postSuccess: "Post Success",
    postFailed: 'Post Failed"',
    welcome: "Welcome to",
    joinedSuccessful: "Joined successful!",
    joinImFailed: 'join IM failed!',
    noticePosted: "Notice Posted",
    contentProhibited: "Content prohibited",
    kickedOutRoom: '您已经被踢出聊天室',
    startChat: "Let's chat",
    report: "Report",
    violationOptions: "Violation options",
    bottomSheetPrivateChat: 'Private Chat',
    bottomSheetTranslate: 'Translate',
    bottomSheetDelete: 'Delete',
    bottomSheetMute: 'Mute',
    bottomSheetUnmute: 'Unmute',
    bottomSheetRemove: "Remove",
    bottomSheetReport: 'Report',
    bottomSheetPin: "Pin this message",
    bottomSheetUnpin: "Unpin this message",
    bottomSheetCancel: 'Cancel',
    reportButtonClickMenuTitle: 'Report',
    dialogCancel: 'Cancel',
    dialogConfirm: 'Confirm',
    dialogDelete: 'Delete',
    memberListTitle: 'Participants',
    muteListTitle: 'Ban List',
    violationReason_1: "Unwelcome commercial content or spam",
    violationReason_2: "Pornographic or explicit content",
    violationReason_3: "Child abuse",
    violationReason_4: "Hate speech or graphic violence",
    violationReason_5: "Promote terrorism",
    violationReason_6: "Harassment or bullying",
    violationReason_7: "Suicide or self harm",
    violationReason_8: "False information",
    violationReason_9: "Others",
    search: "Search",
    cancel: "Cancel",
    memberRemove: "Remove",
    hasBeenMuted: "Your were muted!",
    newMessage: "new messages",
    wantRemove: "Want to remove",
  };
}
