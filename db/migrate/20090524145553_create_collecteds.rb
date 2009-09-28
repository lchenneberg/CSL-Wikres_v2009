class CreateCollecteds < ActiveRecord::Migration
  def self.up
    create_table :collecteds do |t|
      t.references :collectable, :polymorphic => true
      t.references :user
      t.references :collection
      t.timestamps
    end

    add_index :collecteds, [:user_id], :name => "fk_collecteds_user"
  end

  def self.down
    drop_table :collecteds
  end
end
