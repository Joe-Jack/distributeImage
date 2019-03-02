Rails.application.routes.draw do
  

  # devise_scope :user do
  #   get '/users/sign_in' => 'devise/sessions#new'
  # end
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'indices#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  resources :users do
    resources :indices, except: [:show] do
      post 'pictures/canvasurl' => 'pictures#canvasurl'
      post 'pictures/imagecopy' => 'pictures#imagecopy'
      get 'downloads' => 'indices#downloads', on: :collection
      get 'download' => 'indices#download', on: :member
      # importルートを追加20190125
      collection {post :import}
      collection {get :index_csv}
      # post 'import' => 'indices#import', on: :member
        resources :pictures, only: [:create, :new, :edit]
          post 'dropnew' => 'pictures#dropnew'
          post 'uploadtoaws' => 'pictures#uploadtoaws'
          post 'uploadToAwsCsv' => 'pictures#uploadToAwsCsv'
  end
  
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

 