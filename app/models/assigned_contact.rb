class AssignedContact < ActiveRecord::Base
  self.table_name = 'assigned_contacts'

  belongs_to :issue
  belongs_to :contact, class_name: 'Contact'

  validates :issue_id, presence: true
  validates :contact_id, presence: true
end

