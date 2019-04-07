class ShortenedUrl < ApplicationRecord

	has_many :url_activities

	validates :original_url, presence: true, uniqueness: true
	validates :short_url, uniqueness: true
	validates_format_of :original_url, with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
	before_create :generate_short_url, :set_expire_date
	scope :active, -> { where("expires_on >= ?", Time.now) }

	# Public: Returns an array of top five countries with maximum clicks
	def top_five_countries
		countries = self.url_activities.group(:country).count
		top_countries = []
		unless countries.empty?
			countries = Hash[countries.sort_by{|k, v| v}.reverse]
			top_countries = countries.keys[0..4]
		end
		top_countries
	end

	private

		# Private: (Callback) It generates unique short URL of 5 random alpha numeric characters
		def generate_short_url
			chars = ['0'..'9','A'..'Z','a'..'z'].map{|range| range.to_a}.flatten
			self.short_url = 5.times.map{chars.sample}.join
	    # here we check the DB to make sure the generated short_url above doesn't
	    # already exist in the DB. We generate a new short_url until we are sure that
	    # it doesn't match an existing short_url
	    self.short_url = 5.times.map{chars.sample}.join until ShortenedUrl.find_by_short_url(self.short_url).nil?
		end

		# Private: (Callback) Sets the URL expiry date after 1 month of generation
		def set_expire_date
			#URL will be expired after 1 month of creation
			self.expires_on = Time.now + 1.month
		end
end
