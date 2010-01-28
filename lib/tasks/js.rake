namespace :js do
  namespace :fixtures do
    desc "Generate HTML/CSS from HAML/SASS in "
    task :generate do
      puts "Generating HTML..."
      convert("haml", "html")
      puts "Generating CSS..."
      convert("sass", "css")
    end

    def self.convert(input, output)
      src_ext = '.' + input
      dest_ext = '.' + output
      js_spec_dir = BlueRidge.find_javascript_spec_dir || (raise error_message_for_missing_spec_dir)
      fixture_src_dir = "#{js_spec_dir}/fixture_src"
      fixture_dir = "#{js_spec_dir}/fixtures"
      Dir["#{fixture_src_dir}/*#{src_ext}"].each do |file|
        system "#{input} #{file} #{fixture_dir}/#{File.basename(file, src_ext)}#{dest_ext}"
      end
    end
  end
end

