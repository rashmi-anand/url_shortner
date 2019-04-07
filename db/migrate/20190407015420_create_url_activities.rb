class CreateUrlActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :url_activities do |t|
    	t.references :shortened_url, foreign_key: true
    	t.inet :ip_addr, null: false
    	t.string :country

      t.timestamps
    end
  end
end
