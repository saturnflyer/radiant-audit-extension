class CreateAudits < ActiveRecord::Migration
  def self.up
    create_table :audit_events do |t|
      t.string :auditable_type
      t.integer :auditable_id
      t.integer :user_id
      t.string :ip_address
      t.integer :event_type
      t.text :log_message
      t.timestamps
    end
  end

  def self.down
    drop_table :audit_events
  end
end
