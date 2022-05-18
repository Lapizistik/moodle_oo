
Gem::Specification.new do |spec|
  spec.name          = "moodle_oo"
  spec.version       = File.read('VERSION')
  spec.date          = Time.now.strftime('%Y-%m-%d')
  spec.authors       = ["Klaus Stein"]
  spec.email         = ["apps@istik.de"]

  spec.summary       = 'OO wrapper for moodle_rb'
  spec.description   = 'moodle_rb allows to access the moodle api.
It returns '
  spec.homepage      = "https://github.com/Lapizistik/moodle_oo"
  spec.license       = "MIT"
  spec.files         = Dir['lib/**/*.rb'] + 
                       ['README.md', 'LICENSE.txt', 'VERSION', 'Gemfile']

end
