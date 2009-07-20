require File.dirname(__FILE__) + '/spec_helper'

describe Hagbard::Coin do
  it "should return 0 or 1" do
    20.times {
      coin = Hagbard::Coin.throw
      coin.should satisfy { |n|
        n == 0 or n == 1
      }
    }
  end
end

describe Hagbard::FourCoin do
  it "should return 6, 7, 8 or 9" do
    20.times {
      coin = Hagbard::FourCoin.throw
      coin.should satisfy { |n|
        n >= 6 and n <= 9
      }
    }
  end
end

describe Hagbard::Line do
  it "should only accept input values of 6, 7, 8 or 9" do
    1.upto(10) { |i|
      if (i >= 1 and i <= 5) or i > 9
        lambda { Hagbard::Line.new(i) }.should raise_error(ArgumentError)
      else
        Hagbard::Line.new(i).should be_instance_of(Hagbard::Line)
      end
    }
  end

  it "yin? should return true if value is 6 or 8" do
    line = Hagbard::Line.new(6)
    line.yin?.should be_true
    line.value = 8
    line.yin?.should be_true
  end

  it "yin? should return false if value is 7 or 9" do
    line = Hagbard::Line.new(7)
    line.yin?.should be_false
    line.value = 9
    line.yin?.should be_false
  end

  it "yang? should return true if value is 7 or 9" do
    line = Hagbard::Line.new(7)
    line.yang?.should be_true
    line.value = 9
    line.yang?.should be_true
  end

  it "yang? should return false if value is 6 or 8" do
    line = Hagbard::Line.new(6)
    line.yang?.should be_false
    line.value = 8
    line.yang?.should be_false
  end
 
  it "changing? should return true if value is 6 or 9" do
    6.upto(9) { |i|
      if i == 6 or i == 9
        Hagbard::Line.new(i).changing?.should be_true
      else
        Hagbard::Line.new(i).changing?.should be_false
      end
    }
  end
 
  it "change! should turn a 6 line into a 7 and a 9 line into an 8" do
     line = Hagbard::Line.new(6)
     line.change!
     line.value.should equal(7)
     line.value=9
     line.change!
     line.value.should equal(8)
  end
end
