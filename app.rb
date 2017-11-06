require 'byebug' rescue puts 'no byebug'
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
      maker.channel.pubDate = Time.now
      maker.channel.title   = feed.channel.title

      items = feed.items.sort_by(&:pubDate).reverse.to_enum.with_index { |item, index| item.pubDate = Time.now - index * 60 * 60 * 24 }

      items.each do |item|
        maker.items.new_item do |i|
          i.link         = item.link
          i.title        = item.title
          i.updated      = item.pubDate
          i.description  = item.description
        end
      end
    end

    rss.to_s
  end
end
