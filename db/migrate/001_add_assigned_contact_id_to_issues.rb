class AddAssignedContactIdToIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :assigned_contact_id, :integer
    add_index :issues, :assigned_contact_id
  end
end

