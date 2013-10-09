require_relative './student_scraper'
require_relative './student'
# CLIStudent.new(students)
# Where students are a bunch of student instances.
# CLIStudent.call
# The CLIStudent should have a browse (which lists
# all students), a help, an exit, and a show
# (by ID or name), which will show all the data of a student.

class CLIStudent

  def initialize(students)
    @students = students
    @on = true
  end

  def on?
    @on
  end

  def input
    gets.downcase.strip
  end

  def call
    system('clear')
    puts "#{Student.all.size} students loaded."
    print "Type a command ('help' for help): "
    while self.on?
      self.process(input)
    end
  end

  def browse
    system('clear')
    puts "STUDENTS".center(Student.all.first.name.length + 4, " ")
    #puts "----------------------------------------".center(40, ' ')
    puts ""
    print "id.".ljust(13, ' ')
    puts "name"
    print "--- "
    print "-"*Student.all.first.name.length
    puts ""
    Student.all.each do |student|
      puts "#{(student.id.to_s + '.').rjust(3, ' ')} #{student.name}"
    end
    puts ""
    print "Enter a command: "
  end

  def process(command)
    if [:help, :browse, :exit].include?(command.strip.downcase.to_sym)
      self.send(command)
    elsif command.strip.downcase.include?("show")
      if command.split('show').size > 0
        self.show(command.split('show').last.strip)
      else
        puts "Please enter a student's name or ID after 'show'"
        puts "Loading students..."
        sleep(1.5)
        self.browse
      end
    else
      system('clear')
      puts "Sorry, I don't understand. Please try again."
      puts "Loading help..."
      sleep(1.5)
      self.help
    end
  end

  def help
    system('clear')
    puts "Here's how you get around"
    puts "-------------------------"
    puts "<'help'> to see this list of commands"
    puts "<'browse'> to list the students you can view"
    puts "<'show student_name/id'> to see a student's info"
    puts "<'exit'> to exit."
    puts "-------------------------"
    puts ""
    print "Enter a command: "
  end

  def exit
    puts "Bye!"
    @on = false
  end

  def make_array(student)
    if student.is_a?(Array)
      return student
    else
      [student]
    end
  end

  def display(student)
    system('clear')
    if make_array(student).size == 0
      puts "Sorry, I can't find that student. Please try again."
      puts "Loading students..."
      sleep(1.5)
      self.browse
    else
      make_array(student).each do |student|
        puts "Viewing Student"
        puts "---------------"
        puts ""
        puts "Name: #{student.name}"
        puts "Twitter: #{student.twitter}"
        puts "Linkedin: #{student.linkedin}"
        puts "Githhub: #{student.github}"
        puts "Website: #{student.website}"
        puts ""
      end
    end
    print "Enter a command: "
  end

  def show(name)
    if name.to_i.to_s == name
      if name.to_i.between?(1, Student.get_id)
        self.display(Student.find(name.to_i))
      else
        puts "Sorry, I can't find that student. Please try again."
        puts "Loading students..."
        sleep(1.5)
        self.browse
      end
    else
      self.display(Student.find_by_name(name))
    end
  end

end

# main_index_url = "http://students.flatironschool.com"
# student_scrape = StudentScraper.new(main_index_url)
# student_hashes = student_scrape.call
# Student.import(student_hashes)
# command_line = CLIStudent.new(Student.all)
# command_line.call