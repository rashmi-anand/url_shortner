class ShortenedUrlsController < ApplicationController
	def generate_url
		@shortened_url = ShortenedUrl.new
	end

	def create
		@shortened_url = ShortenedUrl.new(shortened_url_params)
		@dup_url = ShortenedUrl.find_by_original_url(@shortened_url.original_url)
		
		respond_to do |format|
			if @dup_url.nil?
				if @shortened_url.save
					flash.now[:success] = "A short URL has been successfully generated"
					format.js				
				else
					flash.now[:error] = @shortened_url.errors.full_messages.join(", ")
					format.js
				end
			else
				flash.now[:success] = "A short URL for the URL already exists"
				format.js
			end
		end
	end

	def get_original_url
		@shortened_url = ShortenedUrl.find_by_short_url(params[:short_url])
		if @shortened_url.expires_on < Time.now
			render :file => "#{Rails.root}/public/404.html",  layout: false, status: 404
		else
			if Rails.env.production?
				@ip_addr = request.ip
				@country = request.location.country
			else

				rqst = Geocoder.search("50.78.167.161").first
				@ip_addr = rqst.ip
				@country = rqst.country
			end
			@shortened_url.url_activities.create(ip_addr: @ip_addr, country: @country)
			redirect_to @shortened_url.original_url
		end
	end

	def index
		@shortened_urls = ShortenedUrl.preload(:url_activities).active
	end

	private

	def shortened_url_params
		params.require(:shortened_url).permit(:original_url)
	end

end
