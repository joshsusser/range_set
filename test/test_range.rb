require File.join(File.dirname(__FILE__), 'helper')

class RangeTest < Test::Unit::TestCase

  def test_contains
    assert(  (1..9).contains?(1..6) )
    assert(  (1..9).contains?(4..9) )
    assert(  (1..9).contains?(4..6) )
    assert( !(4..6).contains?(1..9) )
    assert( !(1..7).contains?(3..9) )
    assert( !(3..9).contains?(1..7) )
    assert( !(1..3).contains?(7..9) )
    assert( !(7..9).contains?(1..3) )
  end
  
  def test_intersect
    assert_nil( (1..5) & nil )
    assert_nil( (1..5) & (5..9) )
    assert_nil( (5..9) & (1..5) )
    assert_nil( (1..4) & (6..9) )
    assert_nil( (6..9) & (1..4) )
    assert_equal( (1..7) & (3..9), (3..7) )
    assert_equal( (3..9) & (1..7), (3..7) )
    assert_equal( (1..9) & (4..6), (4..6) )
    assert_equal( (4..6) & (1..9), (4..6) )
  end
  
  def test_intersect_with_set
    assert_nil( (1..5) & RangeSet.new(5..9, 10..15) )
    assert_nil( (5..9) & RangeSet.new(1..5, 10..15) )
    assert_nil( (1..4) & RangeSet.new(6..9, 10..15) )
    assert_nil( (6..9) & RangeSet.new(1..4, 10..15) )
    assert_equal( (1..7) & RangeSet.new(3..9, 10..15), (3..7) )
    assert_equal( (3..9) & RangeSet.new(1..7, 10..15), (3..7) )
    assert_equal( (1..9) & RangeSet.new(4..6, 10..15), (4..6) )
    assert_equal( (4..6) & RangeSet.new(1..9, 10..15), (4..6) )
    assert_equal( (1..20) & RangeSet.new(3..9, 10..15), RangeSet.new(3..9, 10..15) )
    assert_equal( (5..12) & RangeSet.new(3..9, 10..15), RangeSet.new(5..9, 10..12) )
  end
  
  def test_subtract
    assert_nil( (3..7) - (1..9) )
    assert_nil( (3..7) - (3..9) )
    assert_nil( (3..7) - (1..7) )
    assert_nil( (3..7) - (3..7) )
    assert_equal( (3..7) - nil, (3..7) )
    assert_equal( (3..7) - (1..4), (4..7) )
    assert_equal( (3..7) - (6..9), (3..6) )
    assert_equal( (1..9) - (3..7), RangeSet.new((1..3), (7..9)) )
  end
  
  def test_subtract_with_set
    assert_nil( (3..7) - RangeSet.new(1..9, 10..15) )
    assert_nil( (3..7) - RangeSet.new(3..9, 10..15) )
    assert_nil( (3..7) - RangeSet.new(1..7, 10..15) )
    assert_nil( (3..7) - RangeSet.new(3..7, 10..15) )
    assert_equal( (3..7) - RangeSet.new(1..4, 10..15), (4..7) )
    assert_equal( (3..7) - RangeSet.new(6..9, 10..15), (3..6) )
    assert_equal( (10..20) - RangeSet.new(1..12, 18..25), (12..18) )
    assert_equal( (10..20) - RangeSet.new(1..12, 16..25), (12..16) )
  end
  
  def test_union
    assert_equal( (3..7) | nil, (3..7) )
    assert_equal( (1..7) | (3..9), (1..9) )
    assert_equal( (3..9) | (1..7), (1..9) )
    assert_equal( (1..9) | (4..6), (1..9) )
    assert_equal( (1..9) | (4..9), (1..9) )
    assert_equal( (1..9) | (1..6), (1..9) )
    assert_equal( (4..6) | (1..9), (1..9) )
    assert_equal( (4..9) | (1..9), (1..9) )
    assert_equal( (1..6) | (1..9), (1..9) )
    assert_equal( (1..6) | (6..9), (1..9) )
    assert_equal( (6..9) | (1..6), (1..9) )
    assert_equal( (1..4) | (6..9), RangeSet.new((1..4), (6..9)) )
    assert_equal( (6..9) | (1..4), RangeSet.new((1..4), (6..9)) )
  end
  
  def test_union_with_set
    assert_equal( (1..9) | RangeSet.new(2..4, 6..8), (1..9) )
    assert_equal( (3..7) | RangeSet.new(1..4, 6..9), (1..9) )
    assert_equal( (1..4) | RangeSet.new(2..5, 7..9), RangeSet.new(1..5, 7..9) )
    assert_equal( (1..5) | RangeSet.new(10..15, 20..25), RangeSet.new(1..5, 10..15, 20..25) )
  end
  
  def test_lt
    assert (2..3) < 4
    assert !((2..3) < 3)
  end
  
  def test_gt
    assert (2..3) > 1
    assert !((2..3) > 2)
  end
  
  def test_lte
    assert (2..3) <= 4
    assert (2..3) <= 3
    assert !((2..3) <= 1)
  end
  
  def test_lte
    assert (2..3) <= 1
    assert (2..3) <= 2
    assert !((2..3) <= 4)
  end
  
  def test_lte
    assert (2..3) >= 1
    assert (2..3) >= 2
    assert !((2..3) >= 4)
  end
  
  def test_assemble
    assert_equal (2..5), Range.assemble([5,3,2])
  end
  
  def test_assemble_single_value
    assert_equal (1..1), Range.assemble([1])
  end
  
  def test_assemble_returns_nil_for_empty_array
    assert_nil Range.assemble([])
  end
end
