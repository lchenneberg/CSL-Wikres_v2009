module FriendshipsHelper

  def friendship_status(user, friend)
    friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
    return "You're not friend" if friendship.nil?

    case friendship.status
    when 'requested'
      "Would like to be friend with you."
    when 'pending'
      "You've requested friendship"
    when 'accepted'
      "You're friend"
    end
  end

end
