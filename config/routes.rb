Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'shortened_urls#generate_url'

  resources :shortened_urls do
  	collection do
  		get 'generate_url'
  		get 'get_original_url'
  	end
  end
  
	get "/stats", to: "shortened_urls#index"
	get "/:short_url", to: "shortened_urls#get_original_url"  

  
end
