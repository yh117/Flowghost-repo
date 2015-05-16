Flowghost::Application.routes.draw do

	# set the route for omniauth
	post '/auth/:provider/callback', to: 'sessions#create'

	#new csv feature
	match '/courses/viewCourseInfo', to: 'courses#viewCourseInfo',  via: 'get'
	match '/courses/editStudentRecord', to: 'courses#editStudentRecord',  via: 'post'
	match '/courses/submitStudentRecord', to: 'courses#submitStudentRecord',  via: 'get'
	match '/courses/uploadCsvCreateCourse', to: 'courses#uploadCsvCreateCourse',  via: 'get'
	match '/courses/storeUploadedFile', to: 'courses#storeUploadedFile',  via: 'post'
	match '/courses/addInfoForNewCourse', to: 'courses#addInfoForNewCourse',  via: 'get'
	match '/courses/addTagForCourse', to: 'courses#addTagForCourse',  via: 'get'
	#new flowchart view list
	match '/students/viewFlowChart', to: 'students#viewFlowChart',  via: 'get'

	#new csv feature
	get "courses/mail", as: 'course_mail'
	get "courses/download", as: 'course_download'
	post "courses/upload", as: 'course_upload'


	match "sessions/destroy" => "sessions#destroy", via: [:get], as: 'signout'

	get "sessions/new", as: 'signin'

	get "students/view", as: 'gradeview'


	get "users/new", as: 'signup'

	resources :sessions 

	resources :users
	  resources :student_users
	  resources :instructor_users


	resources :courses 
	resources :assignments 
	resources :tags
	resources :students
	resources :tagassignments

	get "home/index"
	get "home/about"
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"
	root 'home#index'

	

	# Example of regular route:
	#   get 'products/:id' => 'catalog#view'

	# Example of named route that can be invoked with purchase_url(id: product.id)
	#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Example resource route with options:
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

	# Example resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Example resource route with more complex sub-resources:
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', on: :collection
	#     end
	#   end

	# Example resource route with concerns:
	#   concern :toggleable do
	#     post 'toggle'
	#   end
	#   resources :posts, concerns: :toggleable
	#   resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end
end
