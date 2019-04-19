# frozen_string_literal: true

require 'http'
require 'scraperwiki'

people = {}

response = HTTP.get('https://data.parliament.scot/api/members')

JSON.parse(response.to_s, symbolize_names: true).each do |person|
  parsed_name = person[:ParliamentaryName].split(', ').reverse.join(' ')
  parsed_name.sub!(/(?:Mr|Mrs|Ms|Dr|Lord) /, '')
  people[person[:PersonID]] = {
      id: person[:PersonID],
      identifier__scotparl: person[:PersonID],
      image: person[:PhotoURL],
      name: parsed_name
  }
end

emails = HTTP.get('https://data.parliament.scot/api/emailaddresses')
JSON.parse(emails.to_s, symbolize_names: true).each do |email|
  people[email[:PersonID]][:email] = email[:Address] if people[email[:PersonID]]
end

ScraperWiki.save_sqlite([:id], people.values)