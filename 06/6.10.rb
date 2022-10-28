# frozen_string_literal: true

#                            ╔══════════════════════╗
#                            ║ Substitute Algorithm ║
#                            ╚══════════════════════╝
#

class SubstituteAlgorithm
  class Example
    def found_friends(people)
      friends = []
      people.each do |person|
        friends << 'Don' if person == 'Don'
        friends << 'John' if person == 'John'
        friends << 'Kent' if person == 'Kent'
      end

      friends
    end

    def found_friends_refactor(people)
      people.select do |person|
        %w[Don John Kent].include? person
      end
    end
  end
end
