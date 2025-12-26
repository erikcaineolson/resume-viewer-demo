Rails.application.routes.draw do
  namespace :admin do
    resources :profiles do
      member do
        get :download_pdf
      end
    end
    resources :experiences
    resources :skills
    resources :experience_accomplishments

    root to: 'profiles#index'
  end

  root to: redirect('/admin')
end
