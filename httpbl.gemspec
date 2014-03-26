Gem::Specification.new do |s|
  s.name = 'httpbl'
  s.version = '0.1.6'
  s.date = '2009-05-28'
  s.homepage = "http://bpalmen.github.com/httpbl/"   
  s.authors = ["Brandon Palmen"]
  s.email = "brandon.palmen@gmail.com"
  s.rubyforge_project = 'httpbl'   
  s.summary = "HttpBL is a Rack middleware filter that blocks requests from suspicious IP addresses."
  s.description = "HttpBL is a Rack middleware filter that blocks requests from suspicious IP addresses."
  s.test_files = Dir.glob("spec/**/*")
  
  s.files = %w[ 
    README
    CHANGELOG
    LICENSE
    lib/httpbl.rb
    ]
  
  s.extra_rdoc_files = %w[README]
  s.require_paths = %w[lib]

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'rack'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'activesupport', '>= 3.0.0'
  s.add_development_dependency 'dalli'
  s.add_development_dependency 'echoe'  
end 
