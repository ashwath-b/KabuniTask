module DataFormat

  def self.data_formatter(records, curr_page, short_url_id = nil)
    result = []
    result << records
    pages = {}
    paging = {}
    if curr_page <= records.total_pages
      paging[:first] = generate_url(1, records.per_page, short_url_id)
      paging[:last] = generate_url(records.total_pages, records.per_page, short_url_id)
      paging[:next] = generate_url(records.next_page, records.per_page, short_url_id) if records.current_page < records.total_pages
      paging[:previous] = generate_url(records.previous_page, records.per_page, short_url_id) if records.current_page > 1
      paging[:total_pages] = records.total_pages
    else
      pages[:errors] = "Out of bound!! Total number of pages are:" #{records.total_pages}"
    end
    pages[:paging] = paging
    result << pages
  end

  def self.generate_url(page, per_page, url_id)
    if url_id.nil?
      "http://my-domain.com/short_urls?page=#{page}&per_page=#{per_page}"
    else
      "http://my-domain.com/short_urls/#{url_id}?page=#{page}&per_page=#{per_page}"
    end
  end

end
