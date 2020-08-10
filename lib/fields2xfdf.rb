#!/usr/bin/env ruby

require "nokogiri"

def parse_file
  in_field = false
  field = Hash.new { |h,k| h[k]=[] }
  fields = []
  ARGF.each do |line|
    if line.match? /^---$/
      if in_field
        fields << field
        field = Hash.new { |h,k| h[k]=[] }
      end
      in_field = true
      next
    end
    m = line.match /^(.*?):\s+(.*)$/
    field[m[1]] << m[2]
    next
  end
  fields << field
  fields
end

parsed = parse_file

builder = Nokogiri::XML::Builder.new do |xml|
  xml.xfdf(xmlns: "http://ns.adobe.com/xfdf/") do
    xml.fields do
      parsed.each.with_index do |f, i|
        xml.field(name: f["FieldName"].first) do
          case f['FieldType'].first
          when "Button"
            xml.value "On"
          when "Text"
            xml.value  "#{f['FieldName'].first}"
          else
            xml.value "default"
          end
        end
      end
    end
  end
end

puts builder.to_xml

