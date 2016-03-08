# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'discrete_distribution/version'

Gem::Specification.new do |spec|
  spec.name          = 'discrete_distribution'
  spec.version       = DiscreteDistribution::VERSION
  spec.authors       = ['Scott Steele']
  spec.email         = 'ScottLSteele@gmail.com'

  spec.summary       = 'Efficiently generate random outcomes from an arbitrary categorical distribution.'
  spec.description   = 'Fork of aliastable by Paul J Sanchez. If a categorical distribution has k distinct values, traditional approaches will require O(k) work to pick an outcome with the correct probabilities.  This algorithm uses conditional probability to construct a table which will yield outcomes with the correct probabilities, but in O(1) time.'
  spec.homepage      = 'https://github.com/scooter-dangle/discrete_distribution'
  spec.license       = 'LGPL-2.1'

  spec.files         = %x{git ls-files}.split($/)
  spec.require_paths = ['lib']

  spec.cert_chain    = ['certs/scottlsteele@gmail.com.pem']
  spec.signing_key   = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
end
