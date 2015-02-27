require 'net/http'
require 'uri'

require 'nokogiri'
require 'open-uri'

module Jekyll
  class BibleRef < Liquid::Tag
    def initialize(tag_name, passage, tokens)
      super

      passage = passage.rstrip

      fileNameEn = 'cached-references/bible/en/' + passage +'.txt';
      if (File.exists?(fileNameEn))
        @textEn = File.open(fileNameEn, 'r'){|file| file.read}
      else
        url = URI.encode('https://www.biblegateway.com/passage/?version=NKJV&search=' + passage + '&interface=print')
        doc = Nokogiri::HTML(open(url))
        @textEn = ''
        doc.css('.passage-content > div.text-html p').each do |paragraph|
          @textEn += paragraph.content
        end
        @linkEn = URI.encode('https://www.biblegateway.com/passage/?version=NKJV&search=' + passage)

        # Store to cache
        File.open('cached-references/bible/en/' + passage +'.txt', 'w') do |fo|
          fo.puts @textEn
        end
      end

      fileNameAr = 'cached-references/bible/ar/' + passage +'.txt';
      if (File.exists?(fileNameAr))
        @textAr = @textAr = File.open(fileNameAr, 'r'){|file| file.read}
      else
        url = URI.encode('https://www.biblegateway.com/passage/?version=ERV-AR&search=' + passage + '&interface=print')
        doc = Nokogiri::HTML(open(url))
        @textAr = ''
        doc.css('.passage-content > div.text-html p').each do |paragraph|
          @textAr += paragraph.content
        end
        @linkAr = URI.encode('https://www.biblegateway.com/passage/?version=ERV-AR&search=' + passage)

        # Store to cache
        File.open('cached-references/bible/ar/' + passage +'.txt', 'w') do |fo|
          fo.puts @textAr
        end

      end

      @passage = passage

    end

    def render(context)
      %|<blockquote>
        <div class="passage-text en">#{@textEn}<br>-<a href="#{@linkEn}">#{@passage}</a></div>

        <div class="passage-text ar">#{@textAr}<br>-<a href="#{@linkAr}">#{@passage}</a></div></blockquote>|
    end
  end
end

Liquid::Template.register_tag('bible', Jekyll::BibleRef)
