class CreateAssignedContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_contacts do |t|
      t.integer :issue_id, null: false
      t.integer :contact_id, null: false
      t.timestamps null: false
    end
    add_index :assigned_contacts, :issue_id, unique: true
    add_index :assigned_contacts, :contact_id
  end
end

