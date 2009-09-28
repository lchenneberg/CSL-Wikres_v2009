# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def tab_nav
    
  end
  def tab_yield(name, options = {})
    #url = url_for(:action => options, :only_path => false)
    #url_for(options.merge({:only_path => false}))
    url = options
    
    cur_url = url_for(:action => controller.action_name, :only_path => false)
    if(url == cur_url)
      link_to name, options, :class => "active"
    else
      link_to name, options
    end
  end

  def on_title(title = nil)
    
    title.nil? ? title = controller.action_name.capitalize.humanize+" "+controller.controller_name.capitalize.humanize : ""
    
    "<h3>#{title}</h3><br/>"
  end

  def on_minimizable()
  end

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
