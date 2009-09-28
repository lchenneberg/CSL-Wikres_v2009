class FriendshipsController < ApplicationController
  before_filter :login_required
  before_filter :set_friends

  def index
  end

  def show
  end

  def create
    Friendship.request(@user, @friend)
    #Notifier.deliver_friend_request_notification(
     # :user => @user, :friend => @friend,
     # :user_url => profile_url(@user),
     # :accept_url => url_for(:action => "accept", :id => @user.username),
     # :decline_url => url_for(:action => "decline", :id => @user.username)
    #)
    flash[:notice] = "Your request has been sent...#{@friend.username}"
    redirect_to :back
  end

  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.username} accepted!"
    else
      flash[:error] = "No friendship request from #{@friend.username}."
    end
    redirect_to :back
  end

  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:error] = "No friendship request from #{@friend.username}."
    end
    redirect_to :back
  end

  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:error] = "No request for friendship with #{@friend.username}"
    end
    redirect_to :back
  end

  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.username} has been deleted."
    else
      flash[:error] = "You aren't friends with #{@friend.username}."
    end
    redirect_to :back
  end

  private
    def set_friends
      @user = User.find(logged_in_user.id)
      @friend = User.find_by_username(params[:id])
    end

end
