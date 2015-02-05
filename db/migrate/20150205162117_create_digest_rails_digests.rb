class CreateDigestRailsDigests < ActiveRecord::Migration
  def change
    create_table :digest_rails_digests do |t|
      t.string :name

      t.timestamps
    end
  end
end
