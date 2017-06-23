require "spec_helper"
require "./app/models/date_parser"

RSpec.describe DateParser do
#  DateParse.<classmethod>
#  DatePaprser.new.<instancemethod>

  describe ".new" do
    it "must take in a date argument" do
      expect {
        DateParser.new
      }.to raise_error ArgumentError
    end
  end


  describe "#day" do
    it "should be the day integer without leading 0s" do
      parser = DateParser.new(date: "20171004")

      expect(parser.day).to eql "4"
    end
  end

  describe "#month" do
    it "should output the full month spelled out" do
      parser = DateParser.new(date: "20171010")

      expect(parser.month).to eql "October"
    end
  end

  describe "#month_number" do
    it "should output the month number 0 padded" do
      parser = DateParser.new(date: "20170910")

      expect(parser.month_number).to eql "09"
    end
  end

  describe "#month_and_day" do
    it "should output the full spelled out month and date without 0 padding" do
      parser = DateParser.new(date: "20170909")

      expect(parser.month_and_day).to eql "September 9"
    end
  end
end
