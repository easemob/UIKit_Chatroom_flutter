/// Description Chatroom user operation events.
enum ChatroomUserOperationType {
  mute,
  unmute,
  kick,
}

/// Description Chatroom operation events.Ext,leave or join, destroyed.
enum ChatroomOperationType { join, leave, destroyed }
enum ChatroomBeKickedReason { removed, destroyed, offline }
