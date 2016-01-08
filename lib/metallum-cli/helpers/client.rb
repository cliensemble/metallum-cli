require 'metallum-cli/configuration'
require 'net/http'
require 'json'

module MetallumCli
  class Client
    SITE_URL = "http://www.metal-archives.com"

    def self.lang
      Configuration.instance.lang
    end

    def self.get(path)
      uri = URI("#{SITE_URL}/#{path}")
      req = Net::HTTP::Get.new(uri)

      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }

      res
    end

    def self.get_url(path)
      uri = URI(path)
      req = Net::HTTP::Get.new(uri)

      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }

      res.body
    end

    def self.get_json(path)
      # puts "#{SITE_URL}/#{path}"
      json_results "#{SITE_URL}/#{path}"
    end

    def self.json_results(url)
      response = Net::HTTP.get_response(URI.parse(url))
      data = response.body
      JSON.parse(data)
    end

    def self.show_band_page(html, discography, members, similar, links)
      File.write 'out.html', html
      page = Nokogiri::HTML(html)
      band_values = {}
      band_keys = {0 => "Country", 1 => "Location", 2 => "Status", 3 => "Active since", 4 => "Genre", 5 => "Theme", 6 => "Label", 7 => "Years active"}
      page.css('div#band_stats dd').each_with_index do |item, index|
        band_values[band_keys[index]] = item.content.strip.split.join " "
      end
      puts "\n\n////#{page.css('h1.band_name').first.content}\\\\\\\\"
      band_values.each do |k, v|
        puts "#{k}: #{v}"
      end
      if discography
        sel = 0
        case discography
          when 'all' then sel = 1
          when 'main' then sel = 2
          when 'lives' then sel = 3
          when 'demos' then sel = 4
          when 'misc' then sel = 5
        end
        page.css("div#band_disco ul li:eq(#{sel}) a").map { |link|
          show_band_discography link['href']
        }
      end
      if members
        show_band_members page, members
      end
    end

    def self.show_band_discography(url)
      res = Nokogiri::HTML get_url url
      discography = []
      discog_keys = {0 => "Name", 1 => "Type", 2 => "Year", 3 => "Reviews"}
      res.css('tbody tr').each do |album|
        album.css('td').map.with_index do |item, index|
          discography.push "#{discog_keys[index]}: #{item.content.strip.split.join " "}"
        end
      end
      puts "\n\n////Albums\\\\\\\\"
      discography = format_array discography, discog_keys
      discography.each do |album|
        puts album
      end
      # discography.each_with_index do |album, i|
      #   i += 1
      #   puts "#{album}"
      #   puts "\n" if i % 4 == 0
      # end
    end

    def self.show_band_members(page, param)
      members = [[],[],[]]
      member_keys = {0 => "Name", 1 => "Instrument", 2 => "Bands"}
      page.css("div#band_tab_members_#{param} div table tr td").each_with_index do |member, i|
        members[i] = member.content.strip.split.join " "
      end
      puts "\n\n////Members\\\\\\\\"
      members = format_array members, member_keys
      members.each do |member|
        puts member
      end
    end
    
    def self.format_array(arr, indexes)
      unique = indexes.length
      formatted = []
      aux = []
      arr.each_with_index do |e, i|
        aux.push e
        if(i > 0 && i % unique == unique-1)
          # aux[-1] += "\n\n"
          formatted.push aux
          aux = []
        end
      end
      formatted
    end

  end
end
