Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :orders, only: [:new, :create] do
    collection do
      post :confirm
      get :confirm
      get :complete
    end
  end

end
