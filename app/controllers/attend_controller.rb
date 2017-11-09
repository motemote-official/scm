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
          item << i.attr('src')
          href << i.parent.parent.parent.attr('href')
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
