#!/usr/bin/env ruby
# Skript zum Entfernen der doppelten "Zugewiesener Kontakt" Spalte aus gespeicherten Queries
# 
# Verwendung:
#   rails runner remove_duplicate_column.rb
#   oder
#   bundle exec rails runner remove_duplicate_column.rb

if defined?(Query)
  queries = Query.where(type: 'IssueQuery')
  updated_count = 0
  
  queries.find_each do |query|
    if query.column_names.is_a?(Array)
      # Entferne alle Vorkommen von 'assigned_contact_name'
      original_count = query.column_names.count('assigned_contact_name')
      
      if original_count > 1
        # Entferne alle Vorkommen
        query.column_names.delete('assigned_contact_name')
        # Füge die Spalte einmal hinzu
        query.column_names << 'assigned_contact_name'
        query.save(validate: false)
        updated_count += 1
        puts "Query ##{query.id} (#{query.name}) aktualisiert - #{original_count} doppelte Einträge entfernt"
      end
    end
  end
  
  puts "\nFertig! #{updated_count} Query(s) aktualisiert."
else
  puts "Query-Modell nicht gefunden. Stellen Sie sicher, dass Sie dieses Skript in der Redmine-Umgebung ausführen."
end

