import '../../../inner_headers.dart';

/// Default gift page controller
class DefaultGiftPageController extends ChatroomGiftPageController {
  @override
  final String title;

  @override
  final List<GiftEntityProtocol> gifts;

  DefaultGiftPageController({
    required this.title,
    required this.gifts,
  });
}
