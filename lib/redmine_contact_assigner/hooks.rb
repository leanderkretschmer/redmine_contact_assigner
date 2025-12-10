module RedmineContactAssigner
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
              partial: 'hooks/redmine_contact_assigner/view_issues_form_details_bottom'
    
    render_on :view_issues_index_table_cell,
              partial: 'hooks/redmine_contact_assigner/view_issues_index_table_cell'

    # Hook vor dem Speichern - setze den Parameter auf das Issue-Objekt
    def controller_issues_new_before_save(context = {})
      set_assigned_contact_param(context)
    end

    def controller_issues_edit_before_save(context = {})
      set_assigned_contact_param(context)
    end

    private

    def set_assigned_contact_param(context)
      return unless defined?(Contact)
      
      issue = context[:issue]
      params = context[:params]
      return if issue.nil? || params.nil?

      # Setze den Parameter auf das Issue-Objekt
      # Der after_save Callback im IssuePatch wird dann die eigentliche Speicherung durchführen
      if params[:assigned_contact_id].present?
        issue.assigned_contact_id_param = params[:assigned_contact_id]
      elsif params[:assigned_contact_id] == '' || params[:assigned_contact_id].nil?
        issue.assigned_contact_id_param = ''
      end
    rescue NameError, LoadError => e
      # Contact-Plugin nicht verfügbar - ignoriere
      Rails.logger.warn("RedmineContactAssigner: Contact-Plugin nicht verfügbar: #{e.message}")
    end
  end
end
