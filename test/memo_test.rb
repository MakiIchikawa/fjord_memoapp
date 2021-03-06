# frozen_string_literal: true

require 'minitest/autorun'
require './memo'
require 'pg'

# Class to test Directory
class MemoTest < Minitest::Test
  # def test_new
  #   # memo = Memo.new(22)
  #   # assert_equal '0022', memo.id
  #   memo = Memo.new
  #   assert_equal '0023', memo.id
  # end

  # def test_read
  #   memo = Memo.new(1)
  #   assert_equal %W[memomemo1 me\r\nmo\r\n1], memo.read
  #   memo = Memo.new(2)
  #   assert_equal %W[めもめも２ め\r\nも], memo.read
  # end

  # def test_write
  #   memo = Memo.new
  #   memo.insert('memomemo1', 'memo1')
  #   assert_equal [%w[memomemo1 memo1]], memo.read
  #   memo = Memo.new
  #   memo.insert('めもめも２', 'めも')
  #   assert_equal [%w[めもめも２ めも]], memo.read
  #   memo = Memo.new
  #   memo.insert('memo3', 'memo3')
  #   assert_equal [%w[memo3 memo3]], memo.read
  # end

  def test_read_all
    assert_equal [%w['0001' memomemo1], %w['0002' めもめも２], %w['0003' memo3]], Memo.read_all
  end

  # def test_create_table
  #   assert Memo.create_table
  # end
end
