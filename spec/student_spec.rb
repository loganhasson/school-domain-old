require_relative 'spec_helper'
require_relative '../lib/student'

describe "Student" do

  it "can be instantiated" do
    Student.new.should be_an_instance_of(Student)
  end

  describe "student properties" do
    let(:student) { Student.new }

    it "has a name" do
      student.name = "Paul"
      student.name.should eq("Paul")
    end

    it "has social media links" do
      student.twitter = "paulissupercool"
      student.twitter.should eq("paulissupercool")
      student.linkedin = "paulhateslinkedin"
      student.linkedin.should eq("paulhateslinkedin")
      student.github = "whoisthisguypaulanyway"
      student.github.should eq("whoisthisguypaulanyway")
    end

    it "has a website" do
      student.website = "http://websitesarecool.com"
      student.website.should eq("http://websitesarecool.com")
    end
  end

  describe "::all" do

    it "keeps track of the students that have been created" do
      Student.reset_all

      ('a'..'c').each do |l|
        s = Student.new
        s.name = l
      end

      Student.all.count.should eq(3)
      Student.all.collect { |s| s.name }.should include('a')
    end

  end

  describe "::reset_all" do

    it "resets the set of created students" do
      10.times do
        Student.new
      end

      Student.reset_all
      Student.all.count.should eq(0)
    end

  end

  describe "::find_by_name" do

    let(:scott) { Student.new }
    let(:avi) { Student.new }

    it "can find a student by name" do
      scott.name = "Scott"
      avi.name = "Avi"

      Student.find_by_name("Scott").first.name.should eq("Scott")
      Student.find_by_name("Avi").first.should eq(avi)
    end

  end

  describe "::import" do

    let(:student_hash) do
                          [
                            {:name => "Logan",
                            :twitter => "http://twitter.com/loganhasson",
                            :linkedin => "http://linkedin.com/loganhasson",
                            :github => "http://github.com/loganhasson",
                            :website => "http://loganhasson.github.io"}
                          ]
                       end


    it "should create a new student instance with appropriate attributes" do
      Student.reset_all
      Student.import(student_hash)
      student = Student.all.first
      student.name.should eq("Logan")
      student.twitter.should eq("http://twitter.com/loganhasson")
      student.linkedin.should eq("http://linkedin.com/loganhasson")
      student.github.should eq("http://github.com/loganhasson")
      student.website.should eq("http://loganhasson.github.io")
    end

  end

  #BONUS ROUND! Implement an ID system
  context "with an ID" do

    let(:student) { Student.new }

    before(:each) do
      Student.reset_all
    end

    it "has an ID" do
      student.should respond_to(:id)
    end

    it "doesn't allow ID to be changed" do
      student.should_not respond_to(:id=)
    end

    it "auto-assigns an id" do
      student.name = "Becky"
      student.id.should eq(1)

      s2 = Student.new
      s2.id.should eq(2)
    end

    it "can find a student by ID" do
      student.name = "Steve"
      10.times do
        Student.new
      end

      Student.find(student.id).name.should eq("Steve")
      Student.find(student.id).should eq(student)
    end

    describe "::delete" do

      it "can be deleted" do
        student.name = "Steve"
        5.times do
          Student.new.tap { |s| s.name = "Clara" }
        end

        Student.delete(student.id)
        Student.all.collect { |s| s.name }.should_not include("Steve")
      end

    end
  end
end
