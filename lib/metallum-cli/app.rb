require 'thor'
require 'metallum-cli/helpers/client'
require 'metallum-cli/helpers/url'
require 'base64'
require 'nokogiri'

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

    desc "album", "Busca por um album"
    def album(album)
      result = Client.get "SysRebootRpm.htm?Reboot=Reboot"
      puts result.status
    end

    desc "artist", "Busca por um artista"
    def artist(artist)
      result = Client.get "SysRebootRpm.htm?Reboot=Reboot"
      puts result.status
    end

    desc "band", "Search for a band"
    option :discography
    option :members
    option :similar, :type => :boolean
    option :links, :type => :boolean
    def band(band)
      result = Client.get_json Url.BAND band
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
          Client.show_band_page(Client.get_url(link['href']), options[:discography], options[:members], options[:similar], options[:links])
        }
        # Client.get_url band
      elsif result["aaData"].length == 1
        band = Nokogiri::HTML(result["aaData"][0][0]).css('a')
        band.map{ |link|
          Client.show_band_page(Client.get_url(link['href']), options[:discography], options[:members], options[:similar], options[:links])
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
