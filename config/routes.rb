NewModified::Application.routes.draw do
    root to: 'static_pages#home'

  match '/help', to: 'static_pages#help'

  match '/about', to: 'static_pages#about'

  match '/unauthorized', to: 'static_pages#unauthorized'

  match '/contact', to: 'static_pages#contact'

  resources :users

  match '/user_videos', to: 'users#user_videos'
  match '/user_posts', to: 'users#user_posts'
  match '/user_articles', to: 'users#user_articles'

  match '/signup', to: 'users#new'

  match '/clear_notifications', to: 'users#clear_notifications'

  match '/reset/:reset_code', to:'users#reset_password'

  match '/sorted_users', to:'users#sorted_index'

  resources :sessions, only: [:new, :create, :destroy]

  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/forgotpassword', to: 'sessions#forgot_password'
  match '/resetpassword', to: 'sessions#reset_password'

  resources :feeds, only: [:index, :create, :update, :edit]

  match 'feeds/:permalink', controller: 'feeds', action: 'show', as: "feed"
  
  resources :posts

  resources :articles

  resources :videos do
    get 'search', on: :collection
  end

  match '/feedbacks', to: 'videos#feedback_index'

  match '/saveVideo', to: 'videos#import', via: :post

  resources :blog_posts

  resources :blogs, only: [:create, :destroy, :show, :index]

  match '/importblog', to:"blogs#import"
  match '/performimport', to:"blogs#perform_import"

  resources :comments

  resources :messages, only: [:new, :create, :index, :show]

  match '/getmail', to: 'messages#get_latest'
  match '/markread', to: 'messages#mark_as_read'

  resources :conversations, only: [:show]

  resources :likes, only: [:new, :create, :destroy]

  match '/like', to: 'likes#create', via: :post
  match '/unlike', to: 'likes#destroy', via: :delete

  resources :notifications, only: [:index]
  match '/activities', to: 'notifications#index'
  match '/getnotifications', to: 'notifications#get_latest'

  match 'static/:name', controller: 'pages', action: 'show', as: "page"

  match 'static/edit/:name', controller: 'pages', action: 'edit', as: "edit_page"

  match 'static/update/:name', controller: 'pages', action: 'update', via: :put

  resources :categories

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end