# frozen_string_literal: true

class ShowPrerequisiteReactions
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_prerequisite, lambda { |params|
    prerequisite_id = params[:prerequisite_id]
    prerequisite = Prerequisite.find(id: prerequisite_id)

    if prerequisite
      Right(prerequisite_id)
    else
      Left(Error.new(:not_found, 'Prerequisite not found' ))
    end
  }

  register :validate_prerequisite_reactions, lambda { |prerequisite_id|
    prerequisite_reaction = CoursePrerequisiteReaction.where(prerequisite_id: prerequisite_id).all
    if prerequisite_reaction
      Right(prerequisite_reaction)
    else
      Left(Error.new(:not_found, 'Reacion of this prerequisite not found' ))
    end
  }

  register :get_prerequisite_reactions, lambda { |prerequisite_reaction|
    counts = Hash.new(0)
    prerequisite_reaction.each do |data|
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
      step :validate_prerequisite
      step :validate_prerequisite_reactions
      step :get_prerequisite_reactions
    end.call(params)
  end
end
