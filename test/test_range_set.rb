require 'helper'

class RangeSetTest < Test::Unit::TestCase

  def test_new
    raw =     [1..5, 4..7, 20..25, 10..15, 11..12, 3..6, 18..20]
    normal =  [1..7, 10..15, 18..25]
    assert_equal( normal, RangeSet.new(1..5, 4..7, 20..25, 10..15, 11..12, 3..6, 18..20).ranges )
    assert_equal( normal, RangeSet.new(raw).ranges )
    assert_equal( [2..5, 6..9], RangeSet.new(2..5, 2..4, 6..8, 6..9).ranges )
  end
  
  def test_equal
    assert(   RangeSet.new(1..7, 10..15, 18..25) == RangeSet.new(1..7, 10..15, 18..25) )
    assert( !(RangeSet.new(1..7, 10..15, 18..25) == RangeSet.new(1..7, 10..12, 18..25)) )
    assert( !(RangeSet.new(1..7, 10..15, 18..25) == RangeSet.new(1..7, 10..15)) )
    assert(   RangeSet.new(1..7, 10..15, 18..25) != RangeSet.new(1..7, 10..15)  )
  end
  
  def test_intersect
    assert_nil( RangeSet.new(10..15, 20..25) & nil )
    assert_nil( RangeSet.new(10..15, 20..25) & (1..5) )
    assert_nil( RangeSet.new(10..15, 20..25) & (16..18) )
    assert_nil( RangeSet.new(10..15, 20..25) & (30..35) )
    assert_equal( RangeSet.new(10..15, 20..25) & (10..15), (10..15) )
    assert_equal( RangeSet.new(10..15, 20..25) &  (8..15), (10..15) )
    assert_equal( RangeSet.new(10..15, 20..25) & (10..18), (10..15) )
    assert_equal( RangeSet.new(10..15, 20..25) &  (8..18), (10..15) )
    assert_equal( RangeSet.new(10..15, 20..25) & (12..14), (12..14) )
    assert_equal( RangeSet.new(0..5, 10..15, 20..25) & (10..15), (10..15) )
    assert_equal( RangeSet.new(0..5, 10..15, 20..25) &  (8..15), (10..15) )
    assert_equal( RangeSet.new(0..5, 10..15, 20..25) & (10..18), (10..15) )
    assert_equal( RangeSet.new(0..5, 10..15, 20..25) &  (8..18), (10..15) )
    assert_equal( RangeSet.new(0..5, 10..15, 20..25) & (12..14), (12..14) )
    assert_equal( RangeSet.new(10..15, 20..25) & RangeSet.new(12..17, 22..27),
                  RangeSet.new(12..15, 22..25) )
    assert_equal( RangeSet.new(10..15, 20..25) & RangeSet.new( 8..13, 18..23),
                  RangeSet.new(10..13, 20..23) )
  end
  
  def test_subtract
    assert_nil( RangeSet.new(10..15, 20..25) - (1..50) )
    assert_nil( RangeSet.new(10..15, 20..25) - RangeSet.new(1..16, 20..30) )
    assert_equal( RangeSet.new(10..15, 20..25) - nil, RangeSet.new(10..15, 20..25) )
    assert_equal( RangeSet.new(10..15, 20..25) - (10..15), (20..25) )
    assert_equal( RangeSet.new(10..15, 20..25) - (20..25), (10..15) )
    assert_equal( RangeSet.new(10..15, 20..25) - (13..28), (10..13) )
    assert_equal( RangeSet.new(10..15, 20..25) - (13..22), RangeSet.new(10..13, 22..25) )
    assert_equal( RangeSet.new(10..15, 20..25) - RangeSet.new(13..18, 23..28),
                  RangeSet.new(10..13, 20..23) )
  end
  
  def test_union
    assert_equal( RangeSet.new(10..15, 20..25) | nil, RangeSet.new(10..15, 20..25) )
    assert_equal( RangeSet.new(10..15, 20..25) | (30..35),
                  RangeSet.new(10..15, 20..25, 30..35) )
    assert_equal( RangeSet.new(10..15, 20..25) | RangeSet.new(30..35, 40..45),
                  RangeSet.new(10..15, 20..25, 30..35, 40..45) )
  end
  
end
