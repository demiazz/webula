class FriendshipController < ApplicationController

  before_filter :current_stat, :only => [:index, :requests_to, :requests_from]
  before_filter :other_stat, :only => [:show, :mutual_friends, :not_mutual_friends]

  def index
    @friends = User.where(:_id.in => current_user.friend_ids)
  end

  def requests_to
    @requests = User.where(:_id.in => current_user.requests_to_ids)
  end

  def requests_from
    @requests = User.where(:_id.in => current_user.requests_from_ids)
  end

  def show
    @friends = User.where(:_id.in => @user.friend_ids)
  end

  def mutual_friends
    @friends = User.where(:_id.in => current_user.friend_ids & @user.friend_ids)
  end

  def not_mutual_friends
    @friends = User.where(:_id.in => @user.friend_ids - current_user.friend_ids - [current_user.id, @user.id])
  end

  def add_friend
    @friend = User.where(:username => params[:username]).first
    unless current_user.friend_ids.include?(@friend.id)
      unless current_user.requests_to_ids.include?(@friend.id)
        current_user.push(:requests_from_ids, @friend.id)
        @friend.push(:requests_to_ids, current_user.id)
        current_user.save
        @friend.save
      end
    end
    redirect_to :back
  end

  def confirm_friend
    @friend = User.where(:username => params[:username]).first
    unless current_user.friend_ids.include?(@friend.id)
      if current_user.requests_to_ids.include?(@friend.id)
        current_user.pull_all(:requests_to_ids, [@friend.id])
        @friend.pull_all(:requests_from_ids, [current_user.id])
        current_user.push(:friend_ids, @friend.id)
        @friend.push(:friend_ids, current_user.id)
        current_user.save
        @friend.save
      end
    end
    redirect_to :back
  end

  def refuse_friend
    @friend = User.where(:username => params[:username]).first
    unless current_user.friend_ids.include?(@friend.id)
      if current_user.requests_to_ids.include?(@friend.id)
        current_user.pull_all(:requests_to_ids, [@friend.id])
        @friend.pull_all(:requests_from_ids, [current_user.id])
        current_user.save
        @friend.save
      end
    end
    redirect_to :back
  end

  def remove_friend
    @friend = User.where(:username => params[:username]).first
    if current_user.friend_ids.include?(@friend.id)
      current_user.pull_all(:friend_ids, [@friend.id])
      @friend.pull_all(:friend_ids, [current_user.id])
      current_user.save
      @friend.save
    end
    redirect_to :back
  end

  protected

    def current_stat
      @friends_count = current_user.friend_ids.size
      @requests_to_count = current_user.requests_to_ids.size
      @requests_from_count = current_user.requests_from_ids.size
    end

    def other_stat
      @friedns_count = @user.friend_ids.size
      @mutual_friends_count = (current_user.friend_ids & @user.friend_ids).size
      @not_mutual_friends_count = (@user.friend_ids - current_user.friend_ids - [current_user.id, @user.id]).size
    end

end
