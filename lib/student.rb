class Student

  attr_accessor :name, :twitter, :linkedin,
                :github, :website

  attr_reader :id

  @@all_students = []
  @@current_id = 0

  def initialize(data)
    data.each do |key, value|
      self.send("#{key}=",value)
    end unless data.nil?

    @@all_students << self
    @id = Student.get_next_id
    @name = data[:name]
    @twitter = data[:twitter]
    @linkedin = data[:linkedin]
    @github = data[:github]
    @website = data[:website]
  end

  def self.get_next_id
    @@current_id += 1
  end
  
  def self.get_id
    @@current_id
  end

  def self.all
    @@all_students
  end

  def self.reset_all
    @@all_students.clear
    @@current_id = 0
  end

  def self.delete(id)
    @@all_students.delete(Student.find(id))
  end

  def self.find_by_name(search_name)
    @@all_students.select { |s| s.name.downcase.strip.include?(search_name.downcase.strip) }
  end

  def self.find(id)
    @@all_students.find { |s| s.id == id }
  end

  def self.import(hash)
    hash.each do |student|
      Student.new(student)
    end
  end

end