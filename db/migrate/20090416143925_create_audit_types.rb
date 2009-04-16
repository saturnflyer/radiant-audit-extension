class CreateAuditTypes < ActiveRecord::Migration
  def self.up
    create_table :audit_types do |t|
      t.string :type
      t.string :log_message_format
      t.timestamps
    end
  end

  def self.down
    drop_table :audit_types
  end
end
