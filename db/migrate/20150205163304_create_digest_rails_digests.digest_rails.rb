# This migration comes from digest_rails (originally 20150205162117)
class CreateDigestRailsDigests < ActiveRecord::Migration
  def change
    create_table :digest_rails_digests do |t|
      t.string :key
      t.string :menu_name_high
      t.integer :menu_index_high
      t.string :menu_name_med
      t.integer :menu_index_med
      t.string :menu_name_low
      t.integer :menu_index_low
      t.integer :data_length
      t.string :path_repl_command
      t.string :url_subdomain
      t.binary :data, :limit => 10.megabyte
      t.timestamps
    end
  end
end

