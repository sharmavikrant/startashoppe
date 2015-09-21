Startashop::Application.routes.draw do
	
	 
  resources :high_scores


  get "sitemap/site"

  get "c_shop6/xyz"

  get "c_shop7/xyz"

  get "c_shop4/test"

  get "c_shop3/all"

  get "c_shop5/all"
get ':controller/catlog', to: ':controller#view_all' 
  get ':controller/Get_in_touch', to: ':controller#contact' 
  get ':controller/cart', to: ':controller#add_to_cart' 
post':controller/Get_in_touch', to: ':controller#contact'
 match "/:title/:category/:sub_category/:controller/:product"=>":controller#product_detail", as: 'patient'
	 match "/" => "first#start",:constraints => {:subdomain => "www",:domain => "startashoppe.com"}
 match "/" => "c_shop#shop_search",:constraints => {:subdomain => /.+/}
 match "/sms" => "metawing#sms",:constraints => {:subdomain => "metawing"}		 
			match "/" => "first#start"
# match "/sitemap.xml" => "first#sitemap.xml"		
get "/sitemap.xml" => "sitemap#site", :as => "sitemap", :defaults => { :format => "xml" }
	  match "/" => "c_shop#fst"
	  match "admin/" => "admin_home#adminlogin"
	  #match ":session_url/home/" => "c_shop#home"

	  
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
   match ':controller(/:action(/:id))(.:format)'
end
