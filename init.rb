require 'redmine'
if defined?(Rails) && Rails.respond_to?(:autoloaders) && Rails.autoloaders.respond_to?(:main)
  Rails.autoloaders.main.push_dir(File.join(__dir__, 'lib'))
end
require_relative 'lib/redmine_contact_assigner/hooks'

Redmine::Plugin.register :redmine_contact_assigner do
  name 'Redmine Contact Assigner'
  author 'Leander Kretschmer'
  author_url 'https://github.com/leanderkretschmer/redmine_contact_assigner'
  description 'Fügt ein Feld "Zugewiesener Kontakt" zu Tickets hinzu und zeigt die Spalte in Listen an.'
  version '0.0.1'
  requires_redmine version_or_higher: '6.0.0'
  settings default: { 'assigned_contact_custom_field_id' => nil }, partial: 'settings/redmine_contact_assigner'
end

# Keine Schemaänderungen: Speicherung über bestehendes Issue-Custom-Field
