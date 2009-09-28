ActionController::Routing::Routes.draw do |map|
  map.resources :pictures

  map.resources :messages, :only => [:create, :update, :destroy]
  map.resources :collections, :only => [:create, :update, :destroy]
  map.resources :posts, :has_many => :comments

  #map.resources :skills
  #map.resources :comments
  #map.resources :users, :has_and_belongs_to_many => :roles
  #map.resources :users, :has_many => :posts
  #map.resources :weblogs, :member => {:create => :put, :destroy => :put}

  map.resources :profiles do |profile|
    profile.resources :posts, :path_prefix => "profiles/:user_id",:requirements => { :user_id => /[a-zA-Z0-9.@:%+;:?&=_+-]+/ },
      :only => [:show, :index], :member => {:destroy_comment => :delete, :create_comment => :post}
  end

  map.resource :account, :collection => { :login => :get, :retrieve => :get, :profile => :get,
                                          :profile_update => :put, :set_avatar => :put, :unset_avatar => :put,
                                          :authenticate => :post, :logout => :post, :retrieve_action => :post }
                                        
  map.resource :account do |account|
    account.resources :collections
    account.resources :messages, :controller => 'accounts/messages', :member => {:send_message => :put, :reply => :get, :reply_action => :post},
      :collection => {:inbox => :get, :outbox => :get, :sent => :get}
    account.resources :pictures, :controller => 'accounts/pictures'
    account.resources :skills
    account.resources :weblogs, :member => {:enable => :put} do |weblogs|
      weblogs.resources :posts, :controller => "weblogs/posts", :member => {:destroy_comment => :delete, :create_comment => :post} do |posts|
        posts.resources :comments, :controller => :post_comments
      end
    end
    account.resources :friendships, :collection => {:create => :post, :accept => :post, :cancel => :post,
                                                    :decline => :post, :delete => :post}
  end
  
  map.resources :users do |users|
    users.resources :weblogs, :member => {:enable => :put} do |weblogs|
      weblogs.resources :posts, :controller => "weblogs/posts"
    end
  end
  map.resources :users, :member => { :enable => :put, :manage => :get } do |users|
    users.resources :roles
  end

  map.namespace :wsapi do |ws|
    ws.resources :users
    ws.resources :messages
    ws.resources :weblogs
    ws.resources :posts
    ws.resources :collections
    ws.resources :pictures
  end


  map.show_user '/user/:username', :controller => 'users', :action => 'show_by_username'

  map.root :controller => 'generals'
  map.index '/', :controller => 'generals', :action => 'index'

  map.admin '/admin', :controller => 'admin', :action => 'index'
  map.connect '/admin/:action/:model/:id', :controller => 'admin'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
