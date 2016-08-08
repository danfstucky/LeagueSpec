Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root    'sessions#new'
  get     'login'         =>  'sessions#new'
  post    'login'         =>  'sessions#create'
  delete  'logout'        =>  'sessions#destroy'
  resources :profiles
  get 'invite_user', to: 'profiles#invite'
  get 'send_invitation', to: 'profiles#send_invitation'
  resources :champions, only: [:show]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  get 'search_summoner', to: 'search#search'
  get 'search_to_invite', to: 'search#search_to_invite'
  resources :friendships, only: [:new, :edit, :index, :destroy]
  get 'decide_friendships', to: 'friendships#decide'
end
