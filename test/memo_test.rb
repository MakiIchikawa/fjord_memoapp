# frozen_string_literal: true

require 'minitest/autorun'
require './memo.rb'
require 'pg'

# Class to test Directory
class MemoTest < Minitest::Test
  def test_new
    memo = Memo.new(1)
    assert_equal '0001', memo.id
    memo = Memo.new
    assert_equal '0004', memo.id
  end

  def test_read
    memo = Memo.new(1)
    assert_equal %W[memomemo1 me\r\nmo\r\n1], *memo.read
    memo = Memo.new(2)
    assert_equal %W[めもめも２ め\r\nも], *memo.read
  end

  def test_write
    memo = Memo.new(1)
    memo.update('memomemo1', "me\r\nmo\r\n1")
    assert_equal %W[memomemo1 me\r\nmo\r\n1], *memo.read
    memo = Memo.new(2)
    memo.update('めもめも２', "め\r\nも")
    assert_equal %W[めもめも２ め\r\nも], *memo.read
    memo = Memo.new(3)
    memo.update('memo3', "me\r\nmo\r\n3")
    assert_equal %W[memo3 me\r\nmo\r\n3], *memo.read
  end

  def test_read_all
    assert_equal [%w[0001 memomemo1], %w[0002 めもめも２], %w[0003 memo3]], Memo.read_all
  end

  def test_create_table
    assert Memo.create_table
  end
end
