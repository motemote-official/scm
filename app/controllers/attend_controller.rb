class AttendController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'watir'

  def index
    @member = ["more_than_bright_", "sun19_", "99_2900"]

    browser = Watir::Browser.new
    @img = []
    @url = []
    @member.each_with_index do |m, index|
      browser.goto 'https://www.instagram.com/' + m + '/'
      doc = Nokogiri::HTML.parse(browser.html)

      item = []
      href = []
      doc.css('img').each do |i|
        if item.count < 5
          # Index 이미지
          # item << i.attr('src')

          # Show 이미지
          img = i.attr('src').split('/')
          if img.count == 9
            item << "#{img[0]}/#{img[1]}/#{img[2]}/#{img[3]}/#{img[6]}/#{img[8]}"
          else
            item << "#{img[0]}/#{img[1]}/#{img[2]}/#{img[3]}/#{img[6]}/#{img[7]}"
          end

          url = i.parent.parent.parent.attr('href')
          href << url
        end
      end

      # 프로필 이미지 정보 제외
      item -= [item[0]]
      href -= [href[0]]

      @img << item
      @url << href
    end
    browser.close if browser

    p @url

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @model_class_names }
    end
  end

  def check
  end
end
