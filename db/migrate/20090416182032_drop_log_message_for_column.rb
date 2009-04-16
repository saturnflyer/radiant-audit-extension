class DropLogMessageForColumn < ActiveRecord::Migration
  def self.up
    remove_column :audit_types, :log_message_format
  end

  def self.down
    add_column :audit_types, :log_message_format, :string
  end
end
