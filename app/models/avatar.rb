class Avatar < ActiveRecord::Base
  belongs_to :user
  belongs_to :picture

  validates_uniqueness_of :user_id
  validates_presence_of :user_id, :picture_id

  def lease
    self.destroy
  end
  def lease(user)
    avt = find_by_user_id(user.id)
    avt.destroy if avt
  end

end
