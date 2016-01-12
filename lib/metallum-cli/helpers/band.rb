module MetallumCli
  class Band

    def self.show_band_page(html, discography, members, similar, links)
      # File.write 'out.html', html
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
      if similar
        page.css("div#band_tab_discography").map do |prev_elem|
          prev_elem.previous_element.css('li:eq(4) a').map do |link|
            show_similar_bands "#{link['href']}?showMoreSimilar=1#Similar_artists"
          end
        end
      end
      if links
        sel = ''
        case links
          when 'official' then sel = 'Official'
          when 'merchandise' then sel = 'Official_merchandise'
          when 'unofficial' then sel = 'Unofficial'
          when 'labels' then sel = 'Labels'
          when 'tablatures' then sel = 'Tablatures'
        end
        page.css("div#band_tab_discography").map do |prev_elem|
          prev_elem.previous_element.css('li:eq(5) a').map do |link|
            show_band_links link['href'], sel
          end
        end
      end
    end

    def self.show_band_discography(url)
      res = Nokogiri::HTML Client.get_url url
      discography = []
      discog_keys = {0 => "Name", 1 => "Type", 2 => "Year", 3 => "Reviews"}
      res.css('tbody tr').each do |album|
        album.css('td').map.with_index do |item, index|
          discography.push "#{discog_keys[index]}: #{item.content.strip.split.join " "}"
        end
      end
      puts "\n\n////Albums\\\\\\\\"
      discography = Client.format_array discography, discog_keys
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
      members = Client.format_array members, member_keys
      members.each do |member|
        puts member
      end
    end
    
    def self.show_similar_bands(url)
      res = Nokogiri::HTML Client.get_url url
      bands = []
      band_keys = {0 => "Name", 1 => "Country", 2 => "Genre"}
      res.css('tbody tr td').each do |band|
        bands.push band.content.strip.split.join " "
      end
      puts "\n\n////Similar bands\\\\\\\\"
      bands = Client.format_array bands, band_keys
      bands.each do |band|
        puts band
      end
    end
    
    def self.show_band_links(url, param)
      res = Nokogiri::HTML Client.get_url url
      links = []
      link_keys = {0 => "Name", 1 => "Country", 2 => "Genre"}
      if param.eql? ""
        res.css("table tr td a").each do |link|
          links.push "#{link['title'].sub("Go to: ","")}: #{link['href']}"
        end
      else
        res.css("table#linksTable#{param.capitalize} tr td a").each do |link|
          links.push "#{link['title'].sub("Go to: ","")}: #{link['href']}"
        end
      end
      puts "\n\n////Links\\\\\\\\"
      links = Client.format_array links, link_keys
      links.each do |link|
        puts link
      end
    end
    
  end
end