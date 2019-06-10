class Api::V1::Services::ProductsController < ApplicationController
	before_action :authenticate_user_with_token!

	def index
		@products = Product.all.paginate(page: params[:page], per_page: 20)
		render json: {
			message: "Product list fetched !!", 
			code: 200, 
			data: {products: @products},
			meta: {
				:current_page => @products.current_page,
      			:per_page => @products.per_page,
      			:total_entries => @products.total_entries
      			}
      		}
	end

	def search_products
		t = Product.arel_table
		@products = Product.where(t[:name].eq(params[:q]).or(t[:model].matches("%#{params[:q]}%")))
		@results = @products.paginate(page: params[:page], per_page: 25)
		render json: {
			message: "Product list fetched !!", 
			code: 200, 
			data: {products: @results},
			meta: {
				:current_page => @results.current_page,
      			:per_page => @results.per_page,
      			:total_entries => @results.total_entries
      			}
      		}
	end
	def show
		@product = Product.find_by(id:params[:id])
		render json: {
			message: "Product details fetched !!", 
			code: 200, 
			data: {product: @product}
      		}
	end

	private
	def authenticate_user_with_token!
	    customer_auth_token = request.headers['HTTP_AUTHORIZATION'].presence
	    @user = User.find_by_authentication_token(request.headers['HTTP_AUTHORIZATION'])

	    if @user && Devise.secure_compare(@user.authentication_token, customer_auth_token)
	        @user
	        return
	    else
	      render json: {message: "Invalid access token passed !", code: 403}
	    end
	  end
end