require 'redmine'
require_dependency 'redmine_contact_assigner/hooks'
require_dependency 'redmine_contact_assigner/issue_patch'

Redmine::Plugin.register :redmine_contact_assigner do
  name 'Redmine Contact Assigner'
  author 'Leander Kretschmer'
  author_url 'https://github.com/leanderkretschmer/redmine_contact_assigner'
  description 'Fügt ein Feld "Zugewiesener Kontakt" zu Tickets hinzu und zeigt die Spalte in Listen an.'
  version '0.0.1'
  requires_redmine version_or_higher: '6.0.0'
end

# Issue model patch
Issue.send(:include, RedmineContactAssigner::IssuePatch) unless Issue.included_modules.include?(RedmineContactAssigner::IssuePatch)

# Add column to issue list
if defined?(IssueQuery)
  unless IssueQuery.available_columns.any? { |c| c.name == :assigned_contact }
    IssueQuery.available_columns << QueryAssociationColumn.new(
      :assigned_contact,
      caption: :field_assigned_contact,
      sortable: "#{Contact.table_name}.last_name, #{Contact.table_name}.first_name"
    )
  end

  # Add filter for assigned_contact_id
  unless IssueQuery.instance_methods(false).include?(:initialize_available_filters_with_assigned_contact)
    IssueQuery.class_eval do
      alias_method :initialize_available_filters_without_assigned_contact, :initialize_available_filters
      def initialize_available_filters_with_assigned_contact
        initialize_available_filters_without_assigned_contact
        add_available_filter 'assigned_contact_id', type: :list_optional, values: Contact.order(:last_name, :first_name).map { |c| [c.name, c.id.to_s] }
      end
      alias_method :initialize_available_filters, :initialize_available_filters_with_assigned_contact
    end
  end
end

