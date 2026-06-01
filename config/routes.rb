Rails.application.routes.draw do
  get 'profile/index'
  get 'profile/update'

  devise_for :users

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root "home#index"

  get "home/index"

  get "pages/login"

  get "dashboard/index"

  get "campaigns/index"

  post "campaigns/create"

  get "campaigns/delete/:id", to: "campaigns#delete"

  get "inventory/index"

  get "ai/index"
  get "profile/index"
post "profile/update"
post "ai/generate"
post "ai/analyze_image"
post "ai/export_product"
get "inventory/index"
post "inventory/sold"
post "inventory/sold_out"
post "inventory/delete"
end