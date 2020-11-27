# frozen_string_literal: true

require 'pg'
# Class that handles memo information
class Memo
  @connection = PG.connect(host: 'localhost',
                           user: 'ichikawa',
                           password: 'ichikawa',
                           dbname: 'memoapp',
                           port: '5432')
  attr_reader :id
  def initialize(id = nil)
    if id
      @id = format('%04d', id)
    else
      max_number = 0
      Memo.read_all.each do |memo|
        max_number = memo[0].to_i > max_number ? memo[0].to_i : max_number
      end
      @id = format('%04d', max_number + 1)
    end
  end

  def self.read_connection
    Memo.instance_variable_get(:@connection)
  end

  def read
    sql = "SELECT title, content FROM Memo WHERE id='#{@id}';"
    Memo.read_connection.exec(sql).values
  end

  def insert(title, content)
    sql = "INSERT INTO Memo (id, title, content) VALUES ('#{@id}', '#{title}', '#{content}');"
    Memo.read_connection.exec(sql)
  end

  def update(title, content)
    sql = "UPDATE Memo SET title='#{title}', content='#{content}' WHERE id='#{@id}';"
    Memo.read_connection.exec(sql)
  end

  def delete
    sql = "DELETE FROM Memo WHERE id='#{@id}';"
    Memo.read_connection.exec(sql)
  end

  def self.read_all
    sql = 'SELECT id, title FROM Memo'
    Memo.read_connection.exec(sql).values.sort_by { |ary| ary[0] }
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS Memo
          (id     CHAR(4)    NOT NULL,
          title   TEXT,
          content TEXT,
          PRIMARY KEY (id));"
    Memo.read_connection.exec(sql)
  end
end
