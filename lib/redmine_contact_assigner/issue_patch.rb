module RedmineContactAssigner
  module IssuePatch
    def self.included(base)
      base.class_eval do
        belongs_to :assigned_contact, class_name: 'Contact', foreign_key: 'assigned_contact_id', optional: true

        safe_attributes 'assigned_contact_id'
      end
    end
  end
end

