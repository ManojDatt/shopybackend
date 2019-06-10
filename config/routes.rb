Rails.application.routes.draw do

namespace :api do
		namespace :v1 do
			  scope module: :services , defaults: { format: :json } do
			  	devise_for :users, only: [:sessions]
			  	devise_scope :api_v1_user do
					delete   'users/logout' => 'sessions#logout'
					put   'users/update' => 'sessions#update'
				end

				resources :products, only: [:index, :show] do
				  	collection do
					  	get "search" => "products#search_products"
					end
				end
			
			  end


		end
	end  

end
