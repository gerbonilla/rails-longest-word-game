Rails.application.routes.draw do
  get 'game', to: 'game#home'

  get 'score', to: 'game#score'

  get 'startAgain', to: 'game#startAgain'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
