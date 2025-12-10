module RedmineContactAssigner
  module IssuePatch
    def self.included(base)
      base.class_eval do
        has_one :assigned_contact_record, class_name: 'AssignedContact', foreign_key: 'issue_id', dependent: :delete
        
        # Defensive: Nur wenn Contact-Plugin verfügbar ist
        if defined?(Contact)
          has_one :assigned_contact_contact, through: :assigned_contact_record, source: :contact
        end

        # Callbacks für assigned_contact_id Parameter
        attr_accessor :assigned_contact_id_param
        
        after_save :save_assigned_contact
        
        def assigned_contact_name
          return '' unless defined?(Contact)
          contact = assigned_contact_contact rescue nil
          contact&.to_s || ''
        end
        
        def assigned_contact_id
          return nil unless defined?(Contact)
          contact = assigned_contact_contact rescue nil
          contact&.id
        end
        
        private
        
        def save_assigned_contact
          return unless defined?(Contact)
          return if assigned_contact_id_param.nil?
          
          if assigned_contact_id_param.present?
            # Prüfe ob Contact existiert
            unless Contact.exists?(assigned_contact_id_param.to_i)
              Rails.logger.warn("RedmineContactAssigner: Contact ##{assigned_contact_id_param} existiert nicht")
              return
            end
            
            rec = AssignedContact.where(issue_id: id).first_or_initialize
            rec.contact_id = assigned_contact_id_param.to_i
            rec.save!
          else
            AssignedContact.where(issue_id: id).delete_all
          end
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error("RedmineContactAssigner: Fehler beim Speichern: #{e.message}")
          errors.add(:base, e.message)
          raise
        rescue NameError, LoadError => e
          Rails.logger.warn("RedmineContactAssigner: Contact-Plugin nicht verfügbar: #{e.message}")
        end
      end
    end
  end
end

