module RedmineContactAssigner
  module IssuePatch
    def self.included(base)
      base.class_eval do
        has_one :assigned_contact_record, class_name: 'AssignedContact', foreign_key: 'issue_id', dependent: :delete
        has_one :assigned_contact_contact, through: :assigned_contact_record, source: :contact

        def assigned_contact_name
          assigned_contact_contact&.to_s
        end
      end
    end
  end
end

