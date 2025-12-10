module RedmineContactAssigner
  module QueryPatch
    def self.included(base)
      base.class_eval do
        # Überschreibe die issues-Methode, um eager loading hinzuzufügen
        alias_method :issues_without_assigned_contact, :issues unless method_defined?(:issues_without_assigned_contact)
        
        def issues(*args)
          result = issues_without_assigned_contact(*args)
          
          # Füge eager loading hinzu, wenn assigned_contact_name Spalte aktiv ist
          if defined?(Contact) && columns.any? { |c| c.name == :assigned_contact_name }
            result = result.includes(assigned_contact_record: :contact) if result.is_a?(ActiveRecord::Relation)
          end
          
          result
        end
      end
    end
  end
end

