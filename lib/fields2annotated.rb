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
parsed.each do |field|
  puts "---"
  puts "\# #{field['FieldNameAlt'].first}"
  if field['FieldType'].first == "Text"
    puts "\"#{field['FieldName'].first}\": {}"
  else
    puts "\"#{field['FieldName'].first}\": \{ options: #{field['FieldStateOption']} \}"
  end
  puts "FieldType: #{field['FieldType'].first}"
  puts "FieldName: #{field['FieldName'].first}"
  puts "FieldNameAlt: #{field['FieldNameAlt'].first}"
  puts "FieldFlags: #{field['FieldFlags'].first}"
  puts "FieldJustification: #{field['FieldJustification'].first}"
end
