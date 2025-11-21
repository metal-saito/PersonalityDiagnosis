# frozen_string_literal: true

require_relative "questions"
require_relative "persona_catalog"

module PersonalityDiagnosis
  class Calculator
    class InsufficientAnswersError < StandardError; end

    def initialize(questions: Questions.all, personas: PersonaCatalog)
      @questions = questions
      @personas = personas
    end

    def call(raw_answers)
      answers = raw_answers.transform_keys(&:to_s)
      validate_answers!(answers)

      scores = initialize_scores

      answers.each do |question_id, option_value|
        question = fetch_question(question_id)
        option = question[:options].find { |opt| opt[:value] == option_value }
        raise ArgumentError, "unknown option #{option_value} for #{question_id}" unless option

        accumulate_scores(scores, option[:weights])
      end

      dominant_trait, dominant_score = scores.max_by { |_trait, score| score }
      persona = @personas.find(dominant_trait)

      {
        summary: {
          persona: persona[:name],
          headline: persona[:headline],
          description: persona[:description]
        },
        breakdown: format_scores(scores),
        meta: {
          dominant_trait: dominant_trait,
          dominant_score: dominant_score,
          total_questions: @questions.count,
          answered: answers.count
        },
        suggestions: persona[:suggestions]
      }
    end

    private

    def validate_answers!(answers)
      raise InsufficientAnswersError, "answers must be provided" if answers.empty?

      incomplete = answers.any? { |_key, value| value.nil? || value.to_s.strip.empty? }
      raise InsufficientAnswersError, "all questions must be answered" if incomplete
    end

    def initialize_scores
      Questions::TRAITS.each_with_object({}) do |trait, acc|
        acc[trait] = 0
      end
    end

    def fetch_question(id)
      @questions.find { |question| question[:id] == id } ||
        (raise ArgumentError, "unknown question id: #{id}")
    end

    def accumulate_scores(scores, weights)
      weights.each do |trait, value|
        scores[trait] ||= 0
        scores[trait] += value
      end
    end

    def format_scores(scores)
      total = scores.values.sum.to_f
      scores.transform_values do |value|
        {
          raw: value,
          ratio: total.positive? ? (value / total).round(3) : 0.0
        }
      end
    end
  end
end

