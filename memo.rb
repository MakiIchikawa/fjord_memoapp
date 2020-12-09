# frozen_string_literal: true

require 'pg'
require 'dotenv/load'
# Class that handles memo information
class Memo
  attr_reader :id

  def initialize(id = nil)
    if id
      @id = format('%04d', id)
    else
      memo = Memo.read_all.transpose
      max_number = memo[0] ? memo[0].map(&:to_i).max : 0
      @id = format('%04d', max_number + 1)
    end
  end

  def self.exec_sql(sql, params)
    connection = PG.connect(host: ENV['PS_HOST'],
                            user: ENV['PS_USER'],
                            password: ENV['PS_PASSWORD'],
                            dbname: ENV['PS_DBNAME'],
                            port: ENV['PS_PORT'])
    response = connection.exec_params(sql, params)
    connection.close
    response
  end

  def read
    sql = 'SELECT title, content FROM Memo WHERE id=$1;'
    params = [@id]
    Memo.exec_sql(sql, params).values
  end

  def insert(title, content)
    sql = 'INSERT INTO Memo (id, title, content) VALUES ($1, $2, $3);'
    params = [@id, title, content]
    Memo.exec_sql(sql, params)
  end

  def update(title, content)
    sql = 'UPDATE Memo SET title=$1, content=$2 WHERE id=$3;'
    params = [title, content, @id]
    Memo.exec_sql(sql, params)
  end

  def delete
    sql = 'DELETE FROM Memo WHERE id=$1;'
    params = [@id]
    Memo.exec_sql(sql, params)
  end

  def self.read_all
    sql = 'SELECT id, title FROM Memo'
    params = nil
    Memo.exec_sql(sql, params).values.sort_by { |ary| ary[0] }
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS Memo
          (id     CHAR(4)    NOT NULL,
          title   TEXT,
          content TEXT,
          PRIMARY KEY (id));"
    params = nil
    Memo.exec_sql(sql, params)
  end
end
