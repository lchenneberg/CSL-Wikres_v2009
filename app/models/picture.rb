class Picture < ActiveRecord::Base
  belongs_to :user
  has_many :avatars, :dependent => :destroy

  has_attachment :content_type => :image,
                  :storage => :file_system,
                  :path_prefix => '/public/assets/pictures/',
                  :max_size => 2500.kilobytes,
                  :resize_to => '640x480>',
                  :thumbnails => {
                    :macro => '220x220>',
                    :large => '96x96>',
                    :medium => '64x64>',
                    :small => '48x48>',
                  }
  validates_as_attachment
  

  def display_name
    self.title || self.filename

  end


end
