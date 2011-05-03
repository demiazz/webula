Webula::Application.routes.draw do

  #=============================================================================
  # Microblog Controller
  #=============================================================================

  #== Microblog Feeds ==========================================================

  get "microblog/feeds/global", 
          :to => "microblog#global_feed", 
          :default => {:page => 1},
          :as => :microblog__global_feed

  get "((:username)/)microblog/feeds/local",
          :to => "microblog#local_feed", 
          :default => {:page => 1},
          :as => :microblog__local_feed

  get "((:username)/)microblog/feeds/personal",
          :to => "microblog#personal_feed",
          :default => {:page => 1},
          :as => :microblog__personal_feed

  get "((:username)/)microblog/feeds/followings",
          :to => "microblog#followings_feed",
          :default => {:page => 1},
          :as => :microblog__followings_feed

  get "((:username)/)microblog/feeds/followers",
          :to => "microblog#followers_feed",
          :default => {:page => 1},
          :as => :microblog__followers_feed

  #== Microblog Subscribes =====================================================

  get "((:username)/)microblog/subscribes/followings",
          :to => "microblog#followings",
          :default => {:page => 1},
          :as => :microblog__followings

  get "((:username)/)microblog/subscribes/followers", 
          :to => "microblog#followers", 
          :default => {:page => 1},
          :as => :microblog__followers

  #== Posts manage =============================================================

  put "microblog/create_post",
          :to => "microblog#create_post",
          :as => :microblog__create_post

  put "microblog/delete_post/:id",
          :to => "microblog#delete_post",
          :as => :microblog__delete_post

  #== Subscribes manage ========================================================

  put "microblog/subscribes/followings/add/:following", 
          :to => "microblog#add_following",
          :as => :microblog__add_following

  put "microblog/subscribes/followings/remove/:following", 
          :to => "microblog#remove_following",
          :as => :microblog__remove_following

  #=============================================================================
  # Friendship Controller
  #=============================================================================

  #== Списки друзей ============================================================

  get "((:username)/)friends",
          :to => "friendship#friends",
          :default => {:page => 1},
          :as => :friendship__friends

  get ":username/friends/mutual",
          :to => "friendship#mutual_friends",
          :default => {:page => 1},
          :as => :friendship__mutual_friends

  get ":username/friends/not/mutual",
          :to => "friendship#not_mutual_friends",
          :default => {:page => 1},
          :as => :friendship__not_mutual_friends

  #== Запросы на добавление в список друзей ====================================

  get "friends/requests/to",
          :to => "friendship#requests_to",
          :default => {:page => 1},
          :as => :friendship__requests_to

  get "friends/requests/from",
          :to => "friendship#requests_from",
          :default => {:page => 1},
          :as => :friendship__requests_from

  #== Управление списком друзей ================================================

  put "friends/add/friend/:friend",
          :to => "friendship#add_friend",
          :as => :friendship__add_friend

  put "friends/confirm/request/:friend",
          :to => "friendship#confirm_friend",
          :as => :friendship__confirm_friend

  put "friends/refuse/request/:friend",
          :to => "friendship#refuse_friend",
          :as => :friendship__refuse_friend

  put "friends/remove/:friend",
          :to => "friendship#remove_friend",
          :as => :friendship__remove_friend

  #=============================================================================
  # Mail Controller
  #=============================================================================

  #== Ящики сообщений ==========================================================

  get "mail/inbox",
          :to => "mail#inbox",
          :default => {:page => 1},
          :as => :mail__inbox

  get "mail/inbox/read",
          :to => "mail#inbox_read",
          :default => {:page => 1},
          :as => :mail__inbox_read

  get "mail/inbox/unread",
          :to => "mail#inbox_unread",
          :default => {:page => 1},
          :as => :mail__inbox_unread
  
  get "mail/outbox",
          :to => "mail#outbox",
          :default => {:page => 1},
          :as => :mail__outbox

  get "mail/outbox/read",
          :to => "mail#outbox_read",
          :default => {:page => 1},
          :as => :mail__outbox_read

  get "mail/outbox/unread",
          :to => "mail#outbox_unread",
          :default => {:page => 1},
          :as => :mail__outbox_unread

  #== История сообщений ========================================================

  get "mail/history/with/:other_username",
          :to => "mail#history",
          :default => {:page => 1},
          :as => :mail__history

  #== Просмотр сообщений =======================================================

  get "mail/inbox/show/message/:id",
          :to => "mail#show_inbox_message",
          :as => :mail__show_inbox_message

  get "mail/outbox/show/message/:id",
          :to => "mail#show_outbox_message",
          :as => :mail__show_outbox_message

  #== Управление сообщениями ===================================================

  get "mail/new/message/:for",
          :to => "mail#new_message",
          :as => :mail__new_message

  put "mail/create/message",
          :to => "mail#create_message",
          :as => :mail__create_message

  delete "mail/delete/message/:id",
          :to => "mail#delete_message",
          :as => :mail__delete_message

  #=============================================================================
  # Settings Controller
  #=============================================================================

  #== Редактирование профиля ===================================================

  get "settings/profile", 
          :to => "settings#profile_edit",
          :as => :settings__profile_edit

  put "settings/profile",
          :to => "settings#profile_update",
          :as => :settings__profile_update

  #== Редактирование аватара ===================================================

  get "settings/avatar",
          :to => "settings#avatar_edit",
          :as => :settings__avatar_edit

  put "settings/avatar",
          :to => "settings#avatar_update",
          :as => :settings__avatar_update

  #=============================================================================
  # Profiles Controller
  #=============================================================================

  get "index",
          :to => "profiles#index",
          :as => :profiles__index

  get ":username",
          :to => "profiles#show",
          :as => :profiles__show

  #=============================================================================
  # ProfileMaster Controller
  #=============================================================================

  #== Шаг 1 ====================================================================

  get "master/step/1",
          :to => "profile_master#main_edit",
          :as => :profile_master__main_edit

  put "master/step/1",
          :to => "profile_master#main_save",
          :as => :profile_master__main_save

  #== Шаг 2 ====================================================================

  get "master/step/2",
          :to => "profile_master#organization_edit",
          :as => :profile_master__organization_edit

  put "master/step/2",
          :to => "profile_master#organization_save",
          :as => :profile_master__organization_save

  #== Шаг 3 ====================================================================

  get "master/step/3",
          :to => "profile_master#contacts_edit",
          :as => :profile_master__contacts_edit

  put "master/step/3",
          :to => "profile_master#contacts_save",
          :as => :profile_master__contacts_save

  #== Шаг 4 ====================================================================

  get "master/step/4",
          :to => "profile_master#avatar_edit",
          :as => :profile_master__avatar_edit

  put "master/step/4",
          :to => "profile_master#avatar_save",
          :as => :profile_master__avatar_save

  #== Шаг 5 ====================================================================

  get "master/step/finish",
          :to => "profile_master#finish",
          :as => :profile_master__finish

  #=============================================================================
  # Devise for Admin
  #=============================================================================
  
  devise_for :admins, :path => "admin/auth"

  #=============================================================================
  # Devise for User
  #=============================================================================

  devise_for :users, :path => "auth", 
                     :controllers => { :registrations => "users/registrations" } do

    get "settings/account",
            :to => "users/registrations#edit",
            :as => :settings__account_edit
            
    put "settings/account",
            :to => "users/registrations#update",
            :as => :settings__account_update

  end

  #=============================================================================
  # Root path (index)
  #=============================================================================

  root :to => "profiles#index"

end