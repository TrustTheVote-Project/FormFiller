#!/usr/bin/env ruby

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
puts "FieldName,FieldType,RockyFieldName"
parsed.each do |f|
  puts "#{f['FieldName'].first},#{f['FieldType'].first},"
end

