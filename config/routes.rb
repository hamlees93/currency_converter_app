Rails.application.routes.draw do
  get '/', to: 'rates#index', as: 'rates'
  post '/', to: 'rates#create'
  delete '/:id', to: 'rates#destroy', as: 'destroy_rate'
end
