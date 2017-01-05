# frozen_string_literal: true

# Add new instance of Reaction to database
class AddNewReaction
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_type, lambda { |params|
    body_params = JSON.parse params[:request]
    reaction_type = body_params['type']
    reaction_emoji = body_params['emoji']

    if reaction_type
      Right(type: reaction_type, emoji: reaction_emoji)
    else
      Left(
        Error.new(
          :unprocessable_entity,
          'Type content is empty'
        )
      )
    end
  }

  register :check_type_not_duplicated, lambda { |params|
    reaction_type = params[:type]
    results = Reaction.where(type: reaction_type).all

    if results.count > 0
      Left(
        Error.new(
          :unprocessable_entity,
          'An instance of Reaction with the same type already exists'
        )
      )
    else
      Right(params)
    end
  }

  register :create_reaction, lambda { |params|
    begin
      Reaction.create(
        type: params[:type],
        emoji: params[:emoji]
      )

      Right('Successfully create a new instance of Reaction')
    rescue
      Left(Error.new(:bad_request, 'Failed to create reaction'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_type
      step :check_type_not_duplicated
      step :create_reaction
    end.call(params)
  end
end
