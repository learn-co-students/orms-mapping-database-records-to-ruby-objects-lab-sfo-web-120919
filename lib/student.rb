class Student
  attr_accessor :name, :grade, :id

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * 
      FROM students
    SQL

  students = DB[:conn].execute(sql)
  students.map{ |student| self.new_from_db(student) }      
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end 

  def self.all_students_in_grade_X(x)
      sql = <<-SQL
        SELECT * 
        FROM students
        WHERE grade = ?
      SQL

    students = DB[:conn].execute(sql, x)
    students.map{ |student| self.new_from_db(student) }      
     
  end 

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

  students = DB[:conn].execute(sql, x)
  students.map{ |student| self.new_from_db(student) }      
    
  end 

  def self.find_by_name(student_name)
    # find the student in the database given a name
    # return a new instance of the Student class

    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ?
    SQL

    student_info = DB[:conn].execute(sql, student_name)
    self.new_from_db(student_info.flatten)
  end

  def self.all_students_in_grade_9

    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade = 9
    SQL

    students = DB[:conn].execute(sql)
    students.map{ |student| self.new_from_db(student) }      
    
  end 

  def self.students_below_12th_grade


    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade < 12
    SQL

    students = DB[:conn].execute(sql)
    students.map{ |student| self.new_from_db(student) } 
    

  end 

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.new_from_db(student_info)
    new_student = self.new
    new_student.id = student_info[0]
    new_student.name = student_info[1]
    new_student.grade = student_info[2]
    new_student
  end

  def get_id
    if !@id
      retrieve_id_command = <<-SQL
        SELECT *
        FROM students
        ORDER BY id DESC
        LIMIT 1
      SQL

      DB[:conn].execute(retrieve_id_command)
    else
      id
    end
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
