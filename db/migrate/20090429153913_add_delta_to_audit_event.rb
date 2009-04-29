class AddDeltaToAuditEvent < ActiveRecord::Migration
  def self.up
    add_column :audit_events, :delta, :boolean, :default => false
  end

  def self.down
    remove_column :audit_events, :delta
  end
end
