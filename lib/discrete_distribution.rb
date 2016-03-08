require 'discrete_distribution/version'
require 'discrete_distribution/alias_table'

# Convenience wrapper around DiscreteDistribution::AliasTable
#
# 1. Provides same interface as Array to obtain random element (i.e.,
# `#sample`)
#
# 2. Normalizes observation counts into set of probabilities. I.e.,
# allows user to specify
# - US: 50
# - CA: 20
# - FR: 15
# - RU: 10
# instead of
# - US: Rational(10, 19)
# - CA: Rational( 4, 19)
# - FR: Rational( 3, 19)
# - RU: Rational( 2, 19)
#
# 3. Initializer takes a hash of `observed_object => num_observation`
# pairs instead of separate arrays of objects and associated
# probabilities
class DiscreteDistribution
  ##
  # @param hash [Hash{Object => Numeric}]
  #   Map of observed objects to the number of observations
  def initialize(hash)
    @original_observations = hash.dup

    probabilities = self.class.normalize(original_observations.values)
    @alias_table = AliasTable.new(original_observations.keys, probabilities)
  end

  ##
  # TODO: Add the separate argument cases mimicking Array#sample
  # TODO: Add ability to provide own random number generator
  def sample(*args)
    if args.empty?
      @alias_table.generate
    else
      Array.new(args.first) { @alias_table.generate }
    end
  end

  ##
  # @param sample_set [Hash{Object=>Numeric},DiscreteDistribution]
  #
  # @return [DiscreteDistribution]
  def merge(sample_set)
    hash = sample_set.kind_of?(self.class) ? sample_set.original_observations : sample_set
    self.class.new(@original_observations.merge(hash))
  end

  ##
  # @return [Hash]
  def original_observations
    @original_observations
  end
  protected :original_observations

  ##
  # @param observations [Array<Numeric>]
  #
  # @return [Array<Rational>]
  def self.normalize(observations)
    rationals = observations.map(&:to_r)
    divisor = rationals.inject(:+)
    rationals.map { |r| r / divisor }
  end
end
