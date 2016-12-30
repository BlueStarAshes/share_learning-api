# frozen_string_literal: true

# Loads all course data from database
class FindAllReactions
  extend Dry::Monads::Either::Mixin

  def self.call(_)
    if (reactions = AllReactions.new(Reaction.all)).nil?
      Left(Error.new(:not_found, 'Reactions not found'))
    else
      Right(reactions)
    end
  end
end
