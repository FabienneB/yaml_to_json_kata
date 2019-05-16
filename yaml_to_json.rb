#!ruby
require 'yaml'
require 'json'

def file_parsing(file_path)
  YAML.load_file(file_path)
end

def yaml_to_json(file_content)
  language = file_content.first[0]
  values = file_content.first[1]
  Hash[concatenate_keys(file_content.first[1]).map do |key|
    [key, {language => read_in_hashes(key, values)}]
  end]
end

def read_in_hashes(str_key, values)
# functional : str_key.inject{|a, v| a[v]}
  v = values
  str_key.split('.').each do |key|
    v = v[key]
  end
  v
end

def concatenate_keys(hash_content)
  return [] unless hash_content.is_a? Hash
  hash_content.map do |k, v|
    # k = key1
    # v = {'key2'=> "hello"}
    # concatenate_keys(v) = ['key2']
    conc = concatenate_keys(v)
    if conc.empty? 
      [k]
    else
      conc.map { |val| "#{k}.#{val}" } 
    end
  end.flatten
end


def file_storing(language, element)
  File.open("#{language}.json","w") do |f|
    f.write(element.to_json)
  end
end

hash_file_content = file_parsing('test_set/fr.yml')
p json_content = yaml_to_json(hash_file_content)
p file_storing(hash_file_content.first[0], hash_file_content)