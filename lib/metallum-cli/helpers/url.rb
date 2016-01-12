module MetallumCli
  class Url
    
    def self.CREATED
      "archives/ajax-band-list/selection/#{Time.now.year}-#{Time.now.month.to_s.rjust(2,'0')}/by/created//json/1?sEcho=1&iColumns=6&sColumns=&iDisplayStart=0&iDisplayLength=200&mDataProp_0=0&mDataProp_1=1&mDataProp_2=2&mDataProp_3=3&mDataProp_4=4&mDataProp_5=5&iSortCol_0=4&sSortDir_0=desc&iSortingCols=1&bSortable_0=true&bSortable_1=true&bSortable_2=true&bSortable_3=true&bSortable_4=true&bSortable_5=true"
    end
    
    def self.BAND(band)
      "search/ajax-band-search/?field=name&query=#{band}&sEcho=1&iColumns=3&sColumns=&iDisplayStart=0&iDisplayLength=200&mDataProp_0=0&mDataProp_1=1&mDataProp_2=2"
    end
    
    def self.ARTIST(artist)
      "search/ajax-artist-search/?field=alias&query=#{artist}&sEcho=1&iColumns=4&sColumns=&iDisplayStart=0"
    end
    
    def self.ALBUM(album)
      "search/ajax-album-search/?field=title&query=#{album}&sEcho=1&iColumns=4&sColumns=&iDisplayStart=0"
    end
  end
end