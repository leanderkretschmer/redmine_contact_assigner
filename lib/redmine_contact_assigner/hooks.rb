module RedmineContactAssigner
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_form_details_bottom(context = {})
      return '' unless context[:f]
      context[:controller].send(:render_to_string, partial: 'hooks/redmine_contact_assigner/view_issues_form_details_bottom', locals: context)
    end

    def view_issues_show_details_bottom(context = {})
      context[:controller].send(:render_to_string, partial: 'hooks/redmine_contact_assigner/view_issues_show_details_bottom', locals: context)
    end

    def controller_issues_new_before_save(context = {})
      upsert_assigned_contact(context)
    end

    def controller_issues_edit_before_save(context = {})
      upsert_assigned_contact(context)
    end

    private

    def upsert_assigned_contact(context)
      issue = context[:issue]
      params = context[:params]
      return if issue.nil? || params.nil?

      ac_id = params[:assigned_contact_id]
      if ac_id.present?
        rec = AssignedContact.where(issue_id: issue.id).first_or_initialize
        rec.contact_id = ac_id.to_i
        rec.save
      else
        AssignedContact.where(issue_id: issue.id).delete_all
      end
    end
  end
end
