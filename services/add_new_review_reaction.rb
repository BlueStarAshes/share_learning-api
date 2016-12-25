# frozen_string_literal: true
require 'date'

# Add new instance of Reaction to database
class AddNewReviewReaction
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_ids, lambda { |params|
    input = ReviewReactionsRepresenter.new(ReviewReactions.new).from_json(params)
    review_id = input.review_id
    reaction_id = input.reaction_id
    if review_id && reaction_id
      Right(
        review_id: review_id,
        reaction_id: reaction_id
      )
    else
      Left(
        Error.new(
          :unprocessable_entity,
          'review_id or reaction_id not correct'
        )
      )
    end
  }

  register :check_ids_exist, lambda { |params|
    review = Review.find(id: params[:review_id])
    reaction = Reaction.find(id: params[:reaction_id])

    if review && reaction
      Right(params)
    else
      Left(
        Error.new(
          :unprocessable_entity,
          'review_id or reaction_id not correct'
        )
      )
    end
  }

  register :create_review_reaction, lambda { |params|
    begin
      current_time = DateTime.now.strftime('%F %T')

      ReviewReaction.create(
        review_id: params[:review_id],
        reaction_id: params[:reaction_id],
        time: current_time
      )

      Right('Successfully create a new instance of Reaction')
    rescue
      Left(Error.new(:bad_request, 'Failed to create reaction'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_ids
      step :check_ids_exist
      step :create_review_reaction
    end.call(params)
  end
end
