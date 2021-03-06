module ApplicationHelper

  #extracts urls to electronic resources
  #currently a subset of 856 links
  def electronic_resources document 
    allowed_urls = [
      /purl\.fdlp\.gov/i,
      /purl\.access\.gpo\.gov/i,
      /biodiversitylibrary\.org/i,
      /fs\.fed\.us/i
    ]
    re = Regexp.union(allowed_urls)

    #[link text, url]
    resources = []
    
    document.to_marc.find_all{|f| '856' === f.tag && f.indicator1 === '4' && f.indicator2 === '0' }.each do | eresource |   
      if eresource['u'] && eresource['u'].match(re) 
        resources << [eresource['u'], eresource['u']]
      end
    end
    return resources
  end       

  #generate links from oclc field
  #only one (last) will likely be used
  def oclcnum_links document
    oclcnum_links = []
    base = 'https://www.worldcat.org/oclc/'
    if document['oclc']
      document['oclc'].each do | oclc |
        oclcnum_links << [oclc, base+oclc.to_s]
      end
    end
    return oclcnum_links
  end
    
end
