Webula::Application.routes.draw do

  # Microblog Controller
  get "microblog" => "microblog#local_feed", :default => {:username => nil}, :as => :microblog__home
  get ":username/microblog" => "microblog#personal_feed",:as => :microblog__user_home
  get "microblog/feeds/global" => "microblog#global_feed", :as => :microblog__global_feed
  get "((:username)/)microblog/feeds/local" => "microblog#local_feed", :as => :microblog__local_feed
  get "((:username)/)microblog/feeds/personal" => "microblog#personal_feed", :as => :microblog__personal_feed
  get "((:username)/)microblog/feeds/followings" => "microblog#followings_feed", :as => :microblog__followings_feed
  get "((:username)/)microblog/feeds/followers" => "microblog#followers_feed", :as => :microblog__followers_feed
  get "((:username)/)microblog/subscribes/followings" => "microblog#followings", :as => :microblog__followings
  put "microblog/subscribes/followings/add/:username" => "microblog#add_following", :as => :microblog__add_following
  put "microblog/subscribes/followings/remove/:username" => "microblog#remove_following", :as => :microblog__remove_following
  get "((:username)/)microblog/subscribes/followers" => "microblog#followers", :as => :microblog__followers
  put "microblog/create_post" => "microblog#create_post", :as => :microblog__create_post
  put "microblog/delete_post/:id" => "microblog#delete_post", :as => :microblog__delete_post

  # Friendship Controller
  get "friends" => "friendship#index", :as => :friendship__index
  get "friends/requests/to" => "friendship#requests_to", :as => :friendship__requests_to
  get "friends/requests/from" => "friendship#requests_from", :as => :friendship__requests_from
  get ":username/friends" => "friendship#show", :as => :friendship__show
  get ":username/friends/mutual" => "friendship#mutual_friends", :as => :friendship__mutual_friends
  get ":username/friends/not/mutual" => "friendship#not_mutual_friends", :as => :friendship__not_mutual_friends
  put "friends/add/:username" => "friendship#add_friend", :as => :friendship__add_friend
  put "friends/confirm/:username" => "friendship#confirm_friend", :as => :friendship__confirm_friend
  put "friends/refuse/:username" => "friendship#refuse_friend", :as => :friendship__refuse_friend
  put "friends/remove/:username" => "friendship#remove_friend", :as => :friendship__remove_friend

  # Settings Controller
  get "settings/avatar" => "settings#avatar_edit", :as => :settings__avatar_edit
  put "settings/avatar" => "settings#avatar_update", :as => :settings__avatar_update

  get "settings/profile" => "settings#profile_edit", :as => :settings__profile_edit
  put "settings/profile" => "settings#profile_update", :as => :settings__profile_update

  # Profiles Controller
  get "index" => "profiles#index", :as => :profiles__index
  get ":username" => "profiles#show", :as => :profiles__show

  # ProfileMaster Controller
  get "master/step/1" => "profile_master#main_edit", :as => :profile_master__main_edit
  put "master/step/1" => "profile_master#main_save", :as => :profile_master__main_save
  get "master/step/2" => "profile_master#organization_edit", :as => :profile_master__organization_edit
  put "master/step/2" => "profile_master#organization_save", :as => :profile_master__organization_save
  get "master/step/3" => "profile_master#contacts_edit", :as => :profile_master__contacts_edit
  put "master/step/3" => "profile_master#contacts_save", :as => :profile_master__contacts_save
  get "master/step/4" => "profile_master#avatar_edit", :as => :profile_master__avatar_edit
  put "master/step/4" => "profile_master#avatar_save", :as => :profile_master__avatar_save
  get "master/step/finish" => "profile_master#finish", :as => :profile_master__finish

  devise_for :admins, :path => "admin/auth"

  devise_for :users, :path => "auth", :controllers => { :registrations => "users/registrations" } do
    get "settings/account" => "users/registrations#edit", :as => :settings__account_edit
    put "settings/account" => "users/registrations#update", :as => :settings__account_update
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  #root :to => "devise/sessions#new"

  root :to => "profiles#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end