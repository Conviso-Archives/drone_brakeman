require '../lib/parse/json/brakeman'

parse = Parse::Json::Brakeman.new
json_files = Dir.glob('./sample/*.json')

total_time_start = Time.now.tv_sec
json_files.each do |f|
  puts "Parsing file #{f} ..."

  t_start = Time.now.tv_sec
  struct = parse.parse_file(f)
  t_stop = Time.now.tv_sec

  puts "Was found [#{struct[:issues].size}] issues"
  puts "This file has [#{(File.size(f)/1000.0).to_i}] KB"
  puts "The parser took [#{t_stop - t_start}] seconds"
end

total_time_stop = Time.now.tv_sec
puts "\n"
puts "* Total time: [#{total_time_stop - total_time_start}] seconds"
