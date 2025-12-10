class AssignedContact < ActiveRecord::Base
  self.table_name = 'assigned_contacts'

  belongs_to :issue
  # Defensive: Prüfe ob Contact-Modell verfügbar ist
  if defined?(Contact)
    belongs_to :contact, class_name: 'Contact', optional: true
  else
    # Fallback wenn Contact-Plugin nicht verfügbar ist
    belongs_to :contact, class_name: 'Contact', optional: true, foreign_key: 'contact_id'
  end

  validates :issue_id, presence: true
  validates :contact_id, presence: true, if: -> { defined?(Contact) }
  
  # Prüfe ob Contact existiert, wenn Contact-Plugin verfügbar ist
  validate :contact_exists, if: -> { defined?(Contact) && contact_id.present? }
  
  private
  
  def contact_exists
    unless Contact.exists?(contact_id)
      errors.add(:contact_id, :invalid)
    end
  rescue NameError, LoadError
    # Contact-Plugin nicht verfügbar - ignoriere Validierung
  end
end

