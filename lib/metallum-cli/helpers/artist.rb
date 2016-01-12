module MetallumCli
  class Artist

    def self.show_artist_page(html, band)
      # File.write 'out.html', html
      page = Nokogiri::HTML(html)
      artist_values = {}
      biography = []
      artist_keys = {0 => "Location", 1 => "Age", 2 => "Place of origin", 3 => "Gender"}
      page.css('div#member_info dl dd').each_with_index do |item, index|
        artist_values[artist_keys[index]] = item.content.strip.split.join " "
      end
      page.css('div.band_comment').css(".title_comment").remove
      page.css('div.band_comment').each do |item|
        biography.push item.content.strip.split.join " "
      end
      puts "\n\n////#{page.css('h1.band_member_name').first.content}\\\\\\\\"
      artist_values.each do |k, v|
        puts "#{k}: #{v}"
      end
      biography.each do |bio|
        puts bio
      end
      if band
        show_artist_bands page, band
      end
    end

    def self.show_artist_bands(res, param)
      bands = []
      album = []
      album_keys = {0 => "Year", 1 => "Name", 2 => "Role"}
      a = 0
      res.css("div#artist_tab_#{param} div.ui-tabs-panel-content div.member_in_band").each do |band|
        bands.push band.css("h3.member_in_band_name").inner_text
        band.css('table tr td').each_with_index do |item, index|
          i = (index + 3) % 3
          album.push "#{album_keys[i]}: #{item.content.strip.split.join " "}"
          if i == 2
            bands.push album
            album = []
            a += 1
          end
        end
      end
      puts "\n\n////Bands\\\\\\\\"
      bands.each do |band|
        puts band
        puts "\n"
      end
    end
    
  end
end