module RedmineContactAssigner
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
              partial: 'hooks/redmine_contact_assigner/view_issues_form_details_bottom'

    def controller_issues_new_before_save(context = {})
      assign_contact_cf(context)
    end

    def controller_issues_edit_before_save(context = {})
      assign_contact_cf(context)
    end

    private

    def assign_contact_cf(context)
      cf_id = Setting.plugin_redmine_contact_assigner['assigned_contact_custom_field_id']
      return if cf_id.blank?

      issue = context[:issue]
      params = context[:params]
      return if issue.nil? || params.nil?

      values = params.dig(:issue, :custom_field_values)
      return if values.nil?

      val = values[cf_id.to_s]
      return if val.nil?

      current = issue.custom_field_values
      if current.is_a?(Hash)
        current[cf_id.to_s] = val
        issue.custom_field_values = current
      elsif current.respond_to?(:each)
        cv = current.find { |c| (c.respond_to?(:custom_field_id) && c.custom_field_id.to_s == cf_id.to_s) || (c.respond_to?(:custom_field) && c.custom_field.id.to_s == cf_id.to_s) }
        cv.value = val if cv && cv.respond_to?(:value=)
      end
    end
  end
end
