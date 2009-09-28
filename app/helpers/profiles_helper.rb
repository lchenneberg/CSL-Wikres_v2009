module ProfilesHelper

  def pagination_links_remote(paginator)
    page_options = {:window_size => 1}
    pagination_links_each(paginator, page_options) do |n|
      options = {
        :url => {:action => 'live_search', :params => params.merge({:page => n})},
        :update => 'table',
        :before => "Element.show('spinner')",
        :success => "Element.hide('spinner')"
      }
      html_options = {:href => url_for(:action => 'live_search', :params => params.merge({:page => n}))}
      link_to_remote(n.to_s, options, html_options)
    end
  end

  def get_friendship(user, friend)

    return "" if user.id == friend.id
    friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
    return "No friend ( #{ link_to "Request", { :controller => :friendships, :action => :create,
                :id => friend.username } , :confirm => "Are you sure?" } )" if friendship.nil?

    case friendship.status
    when 'requested'
      "Wants ( #{link_to "Accept", :controller => :friendships, :action => :accept,
              :id => friend.username } |
          #{link_to "Decline", { :controller => :friendships, :action => :decline,
              :id => friend.username }, :confirm => "Are you sure?" } )"
    when 'pending'
      "Pending ( #{ link_to "Cancel request", { :controller => :friendships, :action => :cancel,
                :id => friend.username } , :confirm => "Are you sure?" } )"
    when 'accepted'
      "Friend"
    end
  end


end
