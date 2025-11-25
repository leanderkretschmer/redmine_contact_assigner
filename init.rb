require 'redmine'
if defined?(Rails) && Rails.respond_to?(:autoloaders) && Rails.autoloaders.respond_to?(:main)
  Rails.autoloaders.main.push_dir(File.join(__dir__, 'lib'))
end
require_relative 'lib/redmine_contact_assigner/hooks'
require_relative 'lib/redmine_contact_assigner/issue_patch'

Redmine::Plugin.register :redmine_contact_assigner do
  name 'Redmine Contact Assigner'
  author 'Leander Kretschmer'
  author_url 'https://github.com/leanderkretschmer/redmine_contact_assigner'
  description 'Fügt ein Feld "Zugewiesener Kontakt" zu Tickets hinzu und zeigt die Spalte in Listen an.'
  version '0.0.1'
  requires_redmine version_or_higher: '6.0.0'
  settings default: { 'assigned_contact_custom_field_id' => nil }, partial: 'settings/redmine_contact_assigner'
end

Issue.send(:include, RedmineContactAssigner::IssuePatch) unless Issue.included_modules.include?(RedmineContactAssigner::IssuePatch)

if defined?(IssueQuery)
  unless IssueQuery.available_columns.any? { |c| c.name == :assigned_contact_name }
    IssueQuery.available_columns << QueryColumn.new(
      :assigned_contact_name,
      caption: :field_assigned_contact
    )
  end
end
