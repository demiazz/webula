Webula::Application.routes.draw do

  # ProfileMaster Controller
  get "master/step/1" => "profile_master#main_edit"
  put "master/step/1" => "profile_master#main_save"
  get "master/step/2" => "profile_master#organization_edit"
  put "master/step/2" => "profile_master#organization_save"
  get "master/step/3" => "profile_master#contacts_edit"
  put "master/step/3" => "profile_master#contacts_save"
  get "master/step/4" => "profile_master#avatar_edit"
  put "master/step/4" => "profile_master#avatar_save"
  get "master/step/finish" => "profile_master#finish"

  devise_for :admins, :path => "admin/auth"

  devise_for :users, :path => "auth"

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end