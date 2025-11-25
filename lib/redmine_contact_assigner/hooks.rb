module RedmineContactAssigner
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
              partial: 'hooks/redmine_contact_assigner/view_issues_form_details_bottom'
  end
end

