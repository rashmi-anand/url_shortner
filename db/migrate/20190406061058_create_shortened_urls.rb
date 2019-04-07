class CreateShortenedUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_urls do |t|
    	t.text :original_url, unique: true
    	t.string :short_url, unique: true
    	t.datetime :expires_on

      t.timestamps
    end

    add_index :shortened_urls, :original_url, unique: true
  end
end
