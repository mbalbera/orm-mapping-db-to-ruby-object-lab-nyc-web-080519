class Student
  attr_accessor :id, :name, :grade
  @@all = []
  def self.new_from_db(row)
    s = self.new()
    s.id = row[0]
    s.name = row[1]
    s.grade = row[2]
    s
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT
        *
      FROM
        students
    SQL
     DB[:conn].execute(sql).map{|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT
        *
      FROM
        students
      WHERE
        students.name = ?
      LIMIT 
        1
    SQL
     DB[:conn].execute(sql,name).map{|row| self.new_from_db(row)}.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT
        COUNT(*)
      FROM
        students
      WHERE
        students.grade = 9
    
    SQL
     DB[:conn].execute(sql).map{|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT
       *
      FROM
        students
      WHERE
        students.grade < 12
    SQL
     DB[:conn].execute(sql).map{|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT 
        *
      FROM 
        students
      WHERE 
        students.grade = 10
      ORDER BY 
        students.id 
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT
       *
      FROM
        students
      WHERE
        students.grade = 10
      ORDER BY
        students.id
      LIMIT
        ?
    SQL
     DB[:conn].execute(sql, x).map{|row| self.new_from_db(row)}

  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT
        *
      FROM
        students
      WHERE
        students.grade = ?
      ORDER BY
        students.id
    SQL
     DB[:conn].execute(sql, x).map{|row| self.new_from_db(row)}
  end
end
