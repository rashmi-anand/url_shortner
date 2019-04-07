module ShortenedUrlsHelper
	# Returns the full URL based on the Rails enviornment
	def full_url(url)
		Rails.env.production? ? "http://www.short.com/"+url : "http://localhost:3000/"+url
	end
end
