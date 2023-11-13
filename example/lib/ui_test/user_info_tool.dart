class UserInfoTool {
  static Future<List<String>> loadUsers(int pageSize, [int start = 0]) async {
    List<String> list = [];
    for (var i = 0; i < pageSize; i++) {
      list.add("id_${i + start}");
    }

    return Future.delayed(const Duration(milliseconds: 2000), () => list);
  }
}
