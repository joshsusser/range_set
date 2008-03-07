class Range
  
  def to_set
    RangeSet.new(self)
  end
  
  def contains?(rng)
    self === rng.first && self === rng.last
  end
  
# alias :old_include? :include?
# def include?(rng_or_obj)
#   if rng_or_obj.is_a? Enumerable
#     old_include(rng_or_obj.min) && old_include(rng_or_obj.max)
#   else
#     old_include(rng_or_obj)
#   end
# end
  
  # intersect
  def &(rng)
    return nil unless rng
    return RangeSet.new(self) & rng if rng.is_a?(RangeSet)
    lower = [self.first, rng.first].max
    upper = [self.last, rng.last].min
    if lower < upper
      lower..upper
    else
      nil
    end
  end
  
  # union
  def |(rng)
    return self unless rng
    return RangeSet.new(self) | rng if rng.is_a?(RangeSet)
    if self.first < rng.first
      lower, upper = self, rng
    else
      lower, upper = rng, self
    end
    if upper.first <= lower.last
      lower.first..([lower.last, upper.last].max)
    else
      RangeSet.new(lower, upper)
    end
  end
  
  # subtract
  def -(rng)
    return self unless rng
    return RangeSet.new(self) - rng if rng.is_a?(RangeSet)
    if rng.contains?(self)
      nil
    elsif self.contains?(rng)
      RangeSet.new((self.first..rng.first), (rng.last..self.last))
    elsif self.first < rng.first
      self.first..rng.first
    else
      rng.last..self.last
    end
  end
  
end # class Range


class RangeSet < Object
  # include Enumerable
  
  attr_reader :ranges
  
  def initialize(*args)
    @ranges = self.normalize(args.flatten).freeze
  end
  
  def to_set
    self
  end
  
  def ==(rset)
    if rset.nil?
      false
    elsif rset.is_a?(Range)
      @ranges.length == 1 && @ranges.first == rset
    else
      @ranges == rset.ranges
    end
  end
  
  def ===(object)
    @ranges.any? { |r| r === object }
  end
  
  def contains?(rng)
    @ranges.any? { |r| r.contains?(rng) }
  end
  
  def first
    @ranges.first.first
  end
  alias :begin :first
  
  def last
    @ranges.last.last
  end
  alias :end :last

  # --- set operations ---
  
  # intersect
  def &(range_or_set)
    return nil unless range_or_set
    rset = range_or_set.to_set
    return nil if self.last <= rset.first || self.first >= rset.last
    others = rset.ranges
    working = []
    min, max = 0, others.length - 1
    
    @ranges.each do |r|
      min.upto(max) do |i|
        break if r.last <= others[i].first
        if r.first >= others[i].last
          min = i + 1
        else
          working << (r & others[i])
          min = i
        end
      end
    end
    
    if working.empty?
      nil
    elsif working.length == 1
      working.first
    else
      RangeSet.new(working)
    end
  end
  
  # subtract
  def -(range_or_set)
    return self unless range_or_set
    rset = range_or_set.to_set
    return self if self.last <= rset.first || self.first >= rset.last
    others = rset.ranges
    working = []
    min, max = 0, others.length - 1
    
    @ranges.each do |r|
      t = r
      min.upto(max) do |i|
        if t.last <= others[i].first
          # working << t
          break
        elsif others[i].last <= r.first
          min = i + 1
        else
          t = t - others[i]
          break unless t
          if t.is_a?(RangeSet)
            # assume exactly 2 ranges in set
            working << t.ranges.first
            t = t.ranges.last
          end
        end
      end
      working << t if t
    end
    
    if working.empty?
      nil
    elsif working.length == 1
      working.first
    else
      RangeSet.new(working)
    end
  end
  
  #union
  def |(range_or_set)
    return self unless range_or_set
    rset = range_or_set.to_set
    self.class.new(@ranges + rset.ranges)
  end
  
protected
  
  # clean up range array - sort, merge overlaps
  def normalize(arr)
    rs = arr.sort do |r1, r2|
      r1.first == r2.first ? r2.last <=> r1.last : r1.first <=> r2.first
    end
    imax = rs.length - 1
    0.upto(imax - 1) do |i|
      next unless rs[i]     # skip holes left by previous iterations
      (i + 1).upto(imax) do |j|
        next unless rs[j]   # skip holes left by previous iterations
        if rs[i].last < rs[j].first   # no overlap
          break
        elsif rs[i].last == rs[j].first   # merge abutting ranges
          rs[i] = rs[i].first..rs[j].last
          rs[j] = nil
        elsif rs[i].contains?(rs[j])  # sort guarantees rs[j] never contains rs[i]
          rs[j] = nil
        else  # overlap but not contained
          rs[i] = rs[i].first..rs[j].last
          rs[j] = nil
        end
      end
    end
    rs.compact
  end
  
end # class RangeSet