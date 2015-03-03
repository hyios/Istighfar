require 'net/http'
require 'uri'

require 'nokogiri'
require 'open-uri'

module Jekyll
  class QuranRef < Liquid::Tag
    def initialize(tag_name, passage, tokens)
      super

      passage = passage.rstrip
      chapter, verse = passage.split ':', 2

      fileNameEn = 'cached-references/quran/en/' + passage +'.txt';
      fileNameAr = 'cached-references/quran/ar/' + passage +'.txt';

      @textEn = '';
      @textAr = '';

      if (File.exists?(fileNameEn) && File.exists?(fileNameAr))
        @textEn = File.open(fileNameEn, 'r'){|file| file.read}
        @textAr = File.open(fileNameAr, 'r'){|file| file.read}
      else
        url = URI.encode('http://quran.com/' + chapter + '/' + verse);
        doc = Nokogiri::HTML(open(url))

        doc.css('#quranOutput .verse').each do |div|
          id = div['id']

          @textEn += "foo" #div.css('#' + id + "_language_6_content").first.content
          @textAr += "bar" #div.css('#' + id + "_language_2_content").first.content
        end

        @link = url

        # Store to cache
        File.open('cached-references/quran/en/' + passage +'.txt', 'w') do |fo|
          fo.puts @textEn
        end
        # Store to cache
        File.open('cached-references/quran/ar/' + passage +'.txt', 'w') do |fo|
          fo.puts @textAr
        end
      end

      @passage = passage

    end

    def render(context)
      %|<blockquote class="quran">
        <div class="passage-text en">#{@textEn}<br>-<a href="#{@link}">Quran #{@passage}</a></div>

        <div class="passage-text ar">#{@textAr}<br>-<a href="#{@link}">Quran #{@passage}</a></div></blockquote>|
    end
  end
end

Liquid::Template.register_tag('quran', Jekyll::QuranRef)
