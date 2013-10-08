require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative './student'

class StudentScraper

  attr_accessor :students_index, :student_links, :url

  def initialize(url)
    @url = url
    @students_index = Nokogiri::HTML(open(self.url))
  end

  def call
    self.student_links = self.students_index.css('.home-blog-post').map do |student|
      student.css('a').attr('href').to_s
    end

    self.student_links.map { |student| self.scrape_student(student) }.compact
  end

  def scrape_student(student)
    begin
      student_noko = Nokogiri::HTML(open("http://students.flatironschool.com/#{student}"))
    rescue
      return nil
    end
    { 
      :name => scrape_name(student_noko),
      :twitter => scrape_twitter(student_noko),
      :linkedin => scrape_linkedin(student_noko),
      :github => scrape_github(student_noko),
      :website => "http://students.flatironschool.com/#{student}"
    }
  end

  def scrape_name(student_doc)
    if student_doc.css('h4.ib_main_header').text != ''
      student_doc.css('h4.ib_main_header').text
    else
      "No Name"
    end
  end

  def scrape_twitter(student_doc)
    if twitter_node = student_doc.at_css('.page-title .icon-twitter')
      return twitter_node.parent.attr('href')
    end
  end

  def scrape_linkedin(student_doc)
    if linkedin_node = student_doc.at_css('.page-title .icon-linkedin-sign')
      return linkedin_node.parent.attr('href')
    end
  end

  def scrape_github(student_doc)
    if github_node = student_doc.at_css('.page-title .icon-github')
      return github_node.parent.attr('href')
    end
  end

end