class CreateEnums < ActiveRecord::Migration
  def self.up
    create_table :enums do |t|
      t.string :name
    end

    create_table :enum_values do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.integer :enum_id
    end
  end

  def self.down
    drop_table :enums
  end
end

