module AdminHelper
  def avatar_for(user, size = :small)
    begin
      if user.avatar
        return image_tag user.avatar.picture.public_filename(size)
      elsif user.gender
        return image_tag "v1.6/avatars/avt_#{user.gender}_#{size.to_s}.png"
      else
        return image_tag "v1.6/avatars/avt_1_#{size.to_s}.png"
      end
    end
  end
end
