class RemoveEnums < ActiveRecord::Migration
  def self.up
    drop_table :enums
    drop_table :enum_values
  end

  def self.down
  end
end

