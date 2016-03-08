require 'test_helper'

class AliasTableTest < Minitest::Test
  NVARS = 1_000_000

  def test_both_array_arguments_must_be_same_size
    assert_raises ArgumentError do
      DiscreteDistribution::AliasTable.new(
        %w(yes no), [0.3, 0.3, 0.4]
      )
    end
  end

  def test_alias_table_argument_errors
    tests = [
      # No negatives
      [0.1, 0.2, -0.3, 0.4, 0.6],

      # Must add to 1
      [0.1, 0.2, 0.3, 0.3],

      # Must add to 1
      [0.333333, 0.333333, 0.333333],
    ]

    tests.each do |probs|
      assert_raises ArgumentError do
        DiscreteDistribution::AliasTable.new(
          1.upto(probs.size).to_a,
          probs
        )
      end
    end
  end

  def legacy_test(sample_set)
    x = sample_set.keys

    counts = Hash.new do |hash, key|
      assert(
        x.include?(key),
        "AliasTable generated an element not included in original sample: #{key.inspect}"
      )

      hash[key] = 0
    end

    probs = sample_set.values.map(&:to_r)

    expected_counts = sample_set.map do |elmt, prob|
      n_hat = prob * NVARS
      half_width = 2.5 * Math.sqrt(n_hat * (1.0 - prob)) if n_hat > 0
      [elmt, [n_hat, half_width]]
    end.to_h

    alias_table = DiscreteDistribution::AliasTable.new(x, probs)

    NVARS.times do
      element = alias_table.generate
      counts[element] += 1
    end

    expected_counts.each do |element, (expected_count, delta)|
      assert_in_delta(expected_count, counts[element], delta)
    end
  end

  def test_legacy
    tests = [{
      a: 1r/10,
      b: 2r/10,
      c: 3r/10,
      d: 4r/10,
    }, {
      1  => 1r/253,
      2  => 2r/253,
      3  => 3r/253,
      4  => 4r/253,
      5  => 5r/253,
      6  => 6r/253,
      7  => 7r/253,
      8  => 8r/253,
      9  => 9r/253,
      10 => 10r/253,
      11 => 1r/23,
      12 => 12r/253,
      13 => 13r/253,
      14 => 14r/253,
      15 => 15r/253,
      16 => 16r/253,
      17 => 17r/253,
      18 => 18r/253,
      19 => 19r/253,
      20 => 20r/253,
      21 => 21r/253,
      22 => 2r/23,
    }, {
      aardvark: 0.01r,
      baboon: 0.02r,
      coati: 0.07r,
      doggie: 0.9r,
    }]

    tests.each do |sample_set|
      legacy_test(sample_set)
    end
  end

  def test_one_prob_equal_to_mean_prob
    legacy_test(
      a: 0.125r,
      b: 0.125r,
      c: 0.25r,
      d: 0.5r,
    )
  end

  def test_all_probs_equal_to_mean_prob
    legacy_test(
      a: 0.25r,
      b: 0.25r,
      c: 0.25r,
      d: 0.25r,
    )
  end
end
