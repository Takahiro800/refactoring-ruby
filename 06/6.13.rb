# frozen_string_literal: true

#                                   ╔════════════════════════════╗
#                                   ║ Introduce Class Annotation ║
#                                   ╚════════════════════════════╝
#  ╓                                                                                                  ╖
#  ║ 実装の手順がごく一般的なので、安全に隠してしまえるようなメソッドがある                           ║
#  ║ クラス定義からクラスメソッドを呼び出して振る舞いを宣言する                                       ║
#  ╙                                                                                                  ╜

class IntroduceClassAnnotation
  class Examaple
    class Before
      def initialize(hash)
        @author_id = hash[:author_id]
        @publisher_id = hash[:plublisher_id]
        @isbn = hash[:isbn]
      end
    end

    class After
      hash_initializer :author_id, :plublisher_id, :isbn
    end
  end

  #  ╓                                                                                                  ╖
  #  ║   Reason                                                                                         ║
  #  ║   宣言的な構文でコードの目的が明確に掴める場合に                                                 ║
  #  ║   「クラスアノテーションの導入」を使うと、コードの意図を明確にできる                             ║
  #  ╙                                                                                                  ╜

  class Sample
    class Before
      def initialize(hash)
        @author_id = hash[:author_id]
        @publisher_id = hash[:plublisher_id]
        @isbn = hash[:isbn]
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       ここでは、初期化を行おうとしているので、メソッドをクラススコープにする                     ║
      #  ║       initializeメソッドを動的に定義できるようにして、任意のキー名リストを処理できるようにする   ║
      #  ╙                                                                                                  ╜
      class Step1
        def self.hash_initializer(*attribute_names)
          define_method(:initialize) do |*args|
            data = args.first || {}
            attribute_names.each do |attribute_name|
              instance_variable_set "@#{attribute_name}", data[attribute_name]
            end
          end
        end

        hash_initializer :author_id, :plublisher_id, :isbn
      end

      #  ╓                                                                                                  ╖
      #  ║       hash_initializerはさまざまなクラスで使っていくことになるはずなので、                       ║
      #  ║       モジュールとして抽出し、Classに移した方が良い                                              ║
      #  ╙                                                                                                  ╜
      module CustomeInitializers
        def hash_initializer(*attribute_names)
          define_method(:initialize) do |*args|
            data = args.first || {}
            attribute_names.each do |attribute_name|
              instance_variable_set "@#{attribute_name}", data[attribute_name]
            end
          end
        end
      end

      Class.include CustomeInitializers

      class SearchCriteria
        hash_initializer :author_id, :plublisher_id, :isbn
      end
    end
  end
end
