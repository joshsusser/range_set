RangeSet
========

The RangeSet library provides the ability to do set operations on ranges.  It comprises an extension to the Range class and a new RangeSet class.  Supported set operations are union, intersection and subtraction.  Does not work well with ranges with excluded endpoints.

    # union:
    (1..4) | (3..6)   # => 1..6
    (1..2) | (3..4)   # => [1..2, 3..4]
    
    # intersection:
    (1..2) & (3..4)   # => nil
    (1..4) & (3..6)   # => 3..4
    RangeSet.new(2..4, 7..9) & (3..8) # => [3..4, 7..8]
    
    # subtraction:
    (2..3) - (1..4)   # => nil
    (1..4) - (3..5)   # => 1..3
    (1..6) - (3..4)   # => [1..3, 4..6]

## Source Code

Main repository is at [https://github.com/joshsusser/range_set](https://github.com/joshsusser/range_set)

## Contributors
  * [Josh Susser](http://github.com/joshsusser)
  * [Tim Connor](http://github.com/timocratic)

