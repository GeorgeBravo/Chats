
import Foundation

/// An enum representing the kind of message and its underlying kind.
public enum MessageKind {

    case text(String)

    /// A photo message.
    case asset(MediaItem)

    /// A location message.
    case location(LocationItem)

    /// An audio message.
    case audio(AudioItem)
    
    /// A contact message.
    case contact(ContactItem)
    
    /// A file message
    case fileItem(FileItem)
    
    /// Add user
    
    case addUserToChat(UserInviteModel)

}
