class RemoveSphinxCols < ActiveRecord::Migration
  def self.up
    remove_column :audit_events, :delta
  end

  def self.down
    add_column :audit_events, :delta, :boolean, :default => false
  end
end
