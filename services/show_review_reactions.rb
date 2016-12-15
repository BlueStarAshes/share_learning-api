# frozen_string_literal: true

class ShowReviewReactions
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_review, lambda { |params|
    review_id = params[:review_id]
    review = Review.find(id: review_id)

    if review
      Right(review_id)
    else
      Left(Error.new(:not_found, 'Review not found' ))
    end
  }

  register :validate_review_reactions, lambda { |review_id|
    review_reaction = ReviewReaction.where(review_id: review_id).all
    if review_reaction
      Right(review_reaction)
    else
      Left(Error.new(:not_found, 'Reacion of this review not found' ))
    end
  }

  register :get_review_reactions, lambda { |review_reaction|
    counts = Hash.new(0)
    review_reaction.each do |data|
      reaction = Reaction.find(id: data.reaction_id)
      counts[reaction.type] += 1 
    end
    print counts
    all = AllReactions.new(
      counts.map do |t, c|
        Reactions.new(t, c)
      end
    )
    Right(all)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_review
      step :validate_review_reactions
      step :get_review_reactions
    end.call(params)
  end
end
