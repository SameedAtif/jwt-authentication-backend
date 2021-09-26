Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource :session, only: %i[create destroy] 
      resources :users, only: %i[show create]
    end
  end
end
