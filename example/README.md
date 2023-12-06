# chatroom_uikit_example

项目主要为了演示 chatroom_uikit；

## 运行

### 修改 Appkey

修改 `main.dart`  文件中的 `appkey` 为你的在 [console](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html#%E5%89%8D%E6%8F%90%E6%9D%A1%E4%BB%B6) 中注册的 `appkey`。

```dart
const String appKey = '<Your appkey>';
```

### 注册 环信 id

需要在 [`console`](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html#%E5%88%9B%E5%BB%BA-im-%E7%94%A8%E6%88%B7) 中创建 `userId`,


### 创建聊天室

体验 `example` 前，需要先确定已经通过 `console` [创建聊天室](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html#%E5%88%9B%E5%BB%BA%E8%81%8A%E5%A4%A9%E5%AE%A4)。

### 登录并获取房间列表

run `example` 后，输入 [注册](#注册 环信 id) 的 `userId` 和 `password` 并点击 `chatroom_list` 按钮。

### 进入聊天室

点击 [chatroom_list](#登录并获取房间列表) 按钮后，进入聊天室列表后可以看到[创建的聊天室](#创建聊天室)， 点击列表进入。
