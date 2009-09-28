class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.string :name
      t.string :sgltype #Single type
      t.text :description

      t.references :user
      t.references :collectionable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
