Rails.application.routes.draw do
  resources :foobars do
    member do
      put :update_action
    end
  end

  root "foobars#index"
end
