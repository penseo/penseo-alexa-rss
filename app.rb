require 'rss'
require 'open-uri'

get '/' do
  content_type 'application/rss+xml'
  url = params['url'] || 'https://www.penseo.de/post/rss.xml'
  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.id      = url
      maker.channel.author  = url
      maker.channel.pubDate = feed.channel.pubDate
      maker.channel.title   = feed.channel.title

      feed.items.each do |item|
        maker.items.new_item do |i|
          i.link         = item.link
          i.title        = item.title
          i.updated      = item.pubDate
          i.description  = item.description
        end
      end
    end
    return rss.to_s
  end
end
