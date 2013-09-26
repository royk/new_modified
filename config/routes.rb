NewModified::Application.routes.draw do
	root to: 'static_pages#home'

	match '/help', to: 'static_pages#help'

	match '/about', to: 'static_pages#about'

	match '/unauthorized', to: 'static_pages#unauthorized'

	match '/contact', to: 'static_pages#contact'

	match '/admin', to: 'static_pages#admin'

	match '/chat', to: 'static_pages#chat'

	match '/search', to: 'search#search_all'

	resources :users

	match '/user_videos', to: 'users#user_videos'
	match '/user_posts', to: 'users#user_posts'
	match '/user_articles', to: 'users#user_articles'
	match '/user_data', to: 'users#export'
	match '/who_online', to: 'users#who_online'
	match '/enable_chat', to: 'users#user_enable_chat'
	match '/timeline/:id', to: 'users#timeline'
	match '/sessions/:id', to: 'users#sessions_timeline'

	match '/signup', to: 'users#new'

	match '/clear_notifications', to: 'users#clear_notifications'

	match '/reset/:reset_code', to:'users#reset_password'

	match '/sorted_users', to:'users#sorted_index'

	resources :sessions, only: [:new, :create, :destroy]

	match '/signin',  to: 'sessions#new'
	match '/signout', to: 'sessions#destroy', via: :delete
	match '/signout', to: 'sessions#destroy'
	match '/forgotpassword', to: 'sessions#forgot_password'
	match '/resetpassword', to: 'sessions#reset_password'

	resources :feeds, only: [:index, :create, :update, :edit]

	match 'feeds/:permalink', controller: 'feeds', action: 'show', as: "feed"

	resources :achievements

	match 'new_achievement', controller: 'achievements', action: 'create'
	match 'update_achievement', controller: 'achievements', action: 'update'

	resources :training_sessions
	match 'new_training_session', controller: 'training_sessions', action: 'create'
	match 'update_training_session', controller: 'training_sessions', action: 'update'


	match 'training_drills/select', to: 'training_drills#select'
	match 'training_drills/init', to: 'training_drills#init'

	resources :training_drills

	resources :training_drill_results

	resources :posts

	resources :articles

	resources :videos do
		get 'search', on: :collection
		post 'touch'
	end

	match '/feedbacks', to: 'videos#feedback_index'

	match '/saveVideo', to: 'videos#import', via: :post

	resources :blog_posts

	resources :blogs

	match '/importblog', to:"blogs#import"
	match '/performimport', to:"blogs#perform_import"
	match '/perform_blogpost_import', to:"blogs#perform_blogpost_import"
	match '/initblog', to: "blogs#init_blog"
	match '/blogs/rename', to: "blogs#rename", via: :post

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

	resources :events
	resources :competitions, only: [:show, :update]

	match 'competition/reorder/:id', to: 'competitions#reorder', via: :put, as: "reorder"

	resources :results

	match 'static/:name', controller: 'pages', action: 'show', as: "page"

	match 'static/edit/:name', controller: 'pages', action: 'edit', as: "edit_page"

	match 'static/update/:name', controller: 'pages', action: 'update', via: :put

	resources :categories

	resources :video_categories

	resources :video_super_categories

	match 'video_tutorials/:permalink', controller: 'video_super_categories', action: 'show', as: "video_super_category"

	match '/stop_listening/:guid', to: 'listeners#remove_listener'

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