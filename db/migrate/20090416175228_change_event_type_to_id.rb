class ChangeEventTypeToId < ActiveRecord::Migration
  def self.up
    rename_column :audit_events, :event_type, :audit_type_id
  end

  def self.down
    rename_column :audit_events, :audit_type_id, :event_type
  end
end
