# frozen_string_literal: true

require 'http'
require 'scraperwiki'

response = HTTP.get('https://data.parliament.scot/api/members')

JSON.parse(response.to_s, symbolize_names: true).each do |person|
  parsed_name = person[:ParliamentaryName].split(', ').reverse.join(' ')
  parsed_name.sub!(/(?:Mr|Mrs|Ms|Dr|Lord) /, '')
  ScraperWiki.save_sqlite([:identifier__scotparl],
                          identifier__scotparl: person[:PersonID],
                          image: person[:PhotoURL],
                          name: parsed_name)
end
