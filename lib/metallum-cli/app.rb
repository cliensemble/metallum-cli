require 'base64'
require 'metallum-cli/helpers/album'
require 'metallum-cli/helpers/artist'
require 'metallum-cli/helpers/band'
require 'metallum-cli/helpers/client'
require 'metallum-cli/helpers/url'
require 'nokogiri'
require 'thor'

module MetallumCli
  class App < Thor
		package_name 'metallum-cli'

    desc "config", "Create config and edit with $EDITOR"
    def config
      Configuration.save
      if !ENV['EDITOR'].to_s.empty? && !ENV['EDITOR'].nil?
        exec "$EDITOR #{ENV['HOME']}/.metallumcli"
      else
        puts "$EDITOR is not set. Please type your editor:"
        editor = STDIN.gets.chomp
        exec "#{editor} #{ENV['HOME']}/.metallumcli"
      end
    end

    desc "album", "Search for an album"
    option :reviews, :type => :boolean
    def album(*album)
      result = Client.get_json Url.ALBUM album.join "_"
      if result["aaData"].length > 1
        puts "Your search returned the following albums:\n"
        result["aaData"].each_with_index do |r, i|
          album = Nokogiri::HTML(r[0]).css('a').inner_html
          puts "#{i+1} -> #{album} | #{r[2]}\n"
        end
        puts "Select a album number:"
        choice = STDIN.gets.chomp
        album = Nokogiri::HTML(result["aaData"][choice.to_i - 1][1]).css('a')
        album.map{ |link|
          Album.show_album_page(Client.get_url(link['href']), options[:reviews])
        }
        # Client.get_url album
      elsif result["aaData"].length == 1
        album = Nokogiri::HTML(result["aaData"][0][1]).css('a')
        album.map{ |link|
          Album.show_album_page(Client.get_url(link['href']), options[:reviews])
        }
      else
        puts "No reults found"
      end
    end

    desc "artist", "Search for an artist"
    option :band
    def artist(*artist)
      result = Client.get_json Url.ARTIST artist.join "_"
      if result["aaData"].length > 1
        puts "Your search returned the following artists:\n"
        result["aaData"].each_with_index do |r, i|
          artist = Nokogiri::HTML(r[0]).css('a').inner_html
          puts "#{i+1} -> #{artist} | #{r[2]} | #{r[1]}\n"
        end
        puts "Select a artist number:"
        choice = STDIN.gets.chomp
        artist = Nokogiri::HTML(result["aaData"][choice.to_i - 1][0]).css('a')
        artist.map{ |link|
          Artist.show_artist_page(Client.get_url(link['href']), options[:band])
        }
        # Client.get_url artist
      elsif result["aaData"].length == 1
        artist = Nokogiri::HTML(result["aaData"][0][0]).css('a')
        artist.map{ |link|
          Artist.show_artist_page(Client.get_url(link['href']), options[:band])
        }
      else
        puts "No reults found"
      end
    end

    desc "band BAND NAME", "Search for a band"
    option :discography
    option :members
    option :similar, :type => :boolean
    option :links
    def band(*band)
      result = Client.get_json Url.BAND band.join "_"
      if result["aaData"].length > 1
        puts "Your search returned the following bands:\n"
        result["aaData"].each_with_index do |r, i|
          band = Nokogiri::HTML(r[0]).css('a').inner_html
          puts "#{i+1} -> #{band} | #{r[2]} | #{r[1]}\n"
        end
        puts "Select a band number:"
        choice = STDIN.gets.chomp
        band = Nokogiri::HTML(result["aaData"][choice.to_i - 1][0]).css('a')
        band.map{ |link|
          Band.show_band_page(Client.get_url(link['href']), options[:discography], options[:members], options[:similar], options[:links])
        }
        # Client.get_url band
      elsif result["aaData"].length == 1
        band = Nokogiri::HTML(result["aaData"][0][0]).css('a')
        band.map{ |link|
          Band.show_band_page(Client.get_url(link['href']), options[:discography], options[:members], options[:similar], options[:links])
        }
      else
        puts "No reults found"
      end
    end

    desc "additions", "Latest additions"
    def created
      result = Client.get_json Url.CREATED
      # File.write "out.json", result
      result["aaData"].each do |r|
        band = Nokogiri::HTML(r[1]).css('a').inner_html
        country = Nokogiri::HTML(r[2]).css('a').inner_html
        user = Nokogiri::HTML(r[5]).css('a').inner_html
        puts "Band: #{band}"
        puts "Country: #{country}"
        puts "Genre: #{r[3]}"
        puts "Added by user #{user} at #{r[4]}"
        puts "\n"
      end
      puts "Total results: #{result["iTotalDisplayRecords"]}"
    end

  end
end
