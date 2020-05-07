Rails.application.routes.draw do
  root to: 'searchs#index'#"/"に対するルーティング
  get 'searchs_url', to: 'searchs#index'
  get 'youtube', to: 'searchs#csv'
  resources :searchs
end
