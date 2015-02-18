class DropDigestsTable < ActiveRecord::Migration
  def up
    drop_table :digest_rails_digests
  end

  def down
    create_table :digest_rails_digests do |t|
    end
  end
end
