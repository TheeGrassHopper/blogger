Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :articles do
    resources :comments, only: %i[create new index]
  end
  resources :comments, only: %i[create show index destroy update] 
end
