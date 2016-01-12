module MetallumCli
  class Album
    
    def self.show_album_page(html, reviews)
      # File.write 'out.html', html
      page = Nokogiri::HTML(html)
      album_values = {}
      album_keys = {0 => "Type", 1 => "Release date", 2 => "Catalog ID", 3 => "Label", 4 => "Format", 5 => "Reviews"}
      page.css('div#album_info dd').each_with_index do |item, index|
        album_values[album_keys[index]] = item.content.strip.split.join " "
      end
      puts "\n\n////#{page.css('h1.album_name').first.content}\\\\\\\\"
      album_values.each do |k, v|
        puts "#{k}: #{v}"
      end
      if reviews
        show_album_reviews page.css('table#review_list')
      end
    end

    def self.show_album_reviews(res)
      reviews = []
      single_review = []
      links = []
      album_keys = {0 => "Year", 1 => "Name", 2 => "Role"}
      a = 0
      res.css("td[nowrap=nowrap] a").each do |link|
        links.push link['href']
      end
      res.css("td[nowrap=nowrap]").remove
      res.css("td").each_with_index do |review, index|
        i = (index + 4) % 4
        single_review.push review.content.strip.split.join " "
        if i == 3
          reviews.push single_review
          single_review = []
        end
      end
      p reviews
      puts "\n\n////Bands\\\\\\\\"
      reviews.each_with_index do |review,i|
        puts "#{i + 1} -> #{review.join " - "}"
      end
      print "Select the review of your choice, or press any other key to exit: "
      choice = STDIN.gets.chomp
      if choice.to_i > 0
        show_album_review links[choice.to_i - 1]
      end
    end
    
    def self.show_album_review(url)
      page = Nokogiri::HTML Client.get_url url
      puts "\n"
      puts page.css('h3.reviewTitle').first.content.strip.split.join " "
      puts "\n"
      puts page.css('a.profileMenu').first.parent.content.strip.split.join " "
      puts "\n"
      puts page.css('div.reviewContent').first.content.strip.split.join " "
      puts "\n"
    end
  end
  
end