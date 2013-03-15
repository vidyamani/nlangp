require 'test/unit'

TRAINING_SENTENCES = [
  {:word => 'the', :two_ago => :*, :one_ago => :*, :probability => 1},
  {:word => 'dog', :two_ago => :*, :one_ago => 'the', :probability => 0.5},
  {:word => 'cat', :two_ago => :*, :one_ago => 'the', :probability => 0.5},
  {:word => 'walks', :two_ago => 'the', :one_ago => 'cat', :probability => 1},
  {:word => :STOP, :two_ago => 'cat', :one_ago => 'walks', :probability => 1},
  {:word => 'runs', :two_ago => 'the', :one_ago => 'dog', :probability => 1},
  {:word => :STOP, :two_ago => 'dog', :one_ago => 'runs', :probability => 1}
  ]

TEST_CORPUS = [
  ['the', 'dog', 'runs', :STOP],
  ['the', 'cat', 'walks', :STOP],
  ['the', 'dog', 'runs', :STOP]
]

def perplexity
  m = TEST_CORPUS.flatten.size
  l = log_probability / m
  p = (2**(-l)).round(3)
end

def log_probability
  TEST_CORPUS.inject(0) do |sum, sentence|
    sum += Math.log2(probability(sentence))
  end
end

def probability(sentence)
  one_ago = two_ago = :*
  sentence.map do |word|
    q = TRAINING_SENTENCES.detect { |train| train[:word] == word && train[:two_ago] == two_ago && train[:one_ago] == one_ago }
    two_ago = one_ago
    one_ago = word
    q && q[:probability]
  end.compact.inject(:*)
end

class PerplexityTest < Test::Unit::TestCase
  def test_probability
    assert_equal 0.5, probability(TEST_CORPUS[0])
  end
  def test_perplexity
    assert_equal 1.189, perplexity
  end
end