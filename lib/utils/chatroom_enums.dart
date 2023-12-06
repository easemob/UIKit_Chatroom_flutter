/// Description Chatroom user operation events.
enum ChatroomUserOperationType { mute, unmute, kick }

/// Description Chatroom operation events.Ext,leave or join, destroyed.
enum ChatroomOperationType { join, leave, destroyed }

/// Description Chatroom leave events.
enum ChatroomBeKickedReason { removed, destroyed, offline }

/// Description corner radius.
enum CornerRadius { extraSmall, small, medium, large }
