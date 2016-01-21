Rails.application.routes.draw do
  resources :responders, defaults: { format: :json }
  resources :emergencies, defaults: { format: :json }
end
