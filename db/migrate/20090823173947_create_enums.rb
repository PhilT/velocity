class CreateEnums < ActiveRecord::Migration
  def self.up
    create_table :enums do |t|
      t.string :name
    end
    
    create_table :enum_values do |t|
      t.string :value
      t.text :description
      t.integer :position
      t.integer :enum_id
    end

    e = Enum.create!(:name => 'category')
    e.enum_values.create!(:value => 'Feature', :description => 'A new feature not previously implemented', :position => 1)
    e.enum_values.create!(:value => 'Bug', :description => 'A defect in the system that was not intended in the original design', :position => 2)
    e.enum_values.create!(:value => 'Change', :description => 'A change in behaviour from the original design', :position => 3)
    
    e = Enum.create!(:name => 'when')
    e.enum_values.create!(:value => 'Now', :description => 'Needs to be completed in the current release', :position => 1)
    e.enum_values.create!(:value => 'Soon', :description => 'If there is time complete in the current release', :position => 2)
    e.enum_values.create!(:value => 'Later', :description => 'Will be scheduled in a future release', :position => 3)
    
    e = Enum.create!(:name => 'effort')
    e.enum_values.create!(:value => '1', :description => 'This is a simple task', :position => 1)
    e.enum_values.create!(:value => '2', :description => 'This is task of moderate complexity', :position => 2)
    e.enum_values.create!(:value => '4', :description => 'This task is either complex or time consuming', :position => 3)
    e.enum_values.create!(:value => '8', :description => 'This task is very large and may need spliting', :position => 4)
  end

  def self.down
    drop_table :enums
  end
end
