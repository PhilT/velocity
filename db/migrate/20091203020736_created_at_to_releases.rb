class CreatedAtToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :created_at, :datetime
    Release.all.each do |release|
      datetime = release.tasks.first(:order => 'started_on', :conditions => "started_on IS NOT NULL").started_on rescue Time.now
      puts "Setting created_at to #{datetime} for release #{release.id}"
      release.update_attribute(:created_at, datetime)
    end
  end

  def self.down
    remove_column :releases, :created_at
  end
end

