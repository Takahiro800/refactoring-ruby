#                             ╔═════════════════════════════════════════╗
#                             ║ Replace Constructor with Factory Method ║
#                             ║ コンストラクタからファクトリメソッドへ  ║
#                             ╚═════════════════════════════════════════╝

class RepalceConstructorWithFactoryMethod
  class Example
    class Before
      class ProductController
        def create
          @product = if imported
                       ImportedProdct.new
                     elsif base_price > 1000
                       LuxuryProduct.new(base_price)
                     else
                       Product.new(base_price)
                     end
        end
      end
    end

    class After
      class ProductController
        def create
          @product = Product.create(base_price, imported)
        end
      end

      class Product
        def self.create(base_price, imported)
          if imported
            ImportedProduct.new(base_price)
          elsif base_price > 1000
            LuxuryProduct.new(base_price)
          else
            Product.new(base_price)
          end
        end
      end
    end
  end

  #  ╓                                                                                                  ╖
  #  ║   「コンストラクタからファクトリメソッドへ」を適用する理由として                                 ║
  #  ║   もっともはっきりといるのは、作成するオブジェクトの種類を決めるために、                         ║
  #  ║   条件分岐を使っている場合。                                                                     ║
  #  ║   このような条件分岐を複数の箇所で使う必要があれば、                                             ║
  #  ║   ファクトリメソッドの出番。                                                                     ║
  #  ║                                                                                                  ║
  #  ║   コンストラクタで制約が強く感じられる時なら、                                                   ║
  #  ║   それ以外の状況でも使える。                                                                     ║
  #  ╙                                                                                                  ╜

  class Sample
    class Before
      class ProductController
        def create
          @product = if imported
                       ImportedProduct.new
                     elsif base_price > 1000
                       LuxuryProduct.new(base_price)
                     else
                       Product.new(base_price)
                     end
        end
      end

      class Product
        def initialize(base_price)
          @base_price = base_price
        end

        def total_price
          @base_price
        end
      end

      class LuxuryProduct < Product
        def total_price
          super + 0.1 * super
        end
      end

      class ImportedProduct
        def total_price
          super + 0.25 * super
        end
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       最初のステップは、構築ロジックに対して「メソッドの抽出」を適用すること                     ║
      #  ║       抽出したメソッドは、（ファクトリメソッドに適用しやすくするために）                         ║
      #  ║       クラスメソッドにする                                                                       ║
      #  ╙                                                                                                  ╜
      class Step1
        class ProductController
          def create
            @product = create_product(base_price, imported)
          end

          def self.create_product(base_price, imported)
            if imported
              ImportedProduct.new(base_price, imported)
            elsif base_price > 1000
              LuxuryProduct.new(base_price)
            else
              Product.new(base_price)
            end
          end
        end
      end

      class Step2 < Step1
        class ProductController
          def create
            @product = Product.create(base_price, imported)
          end
        end

        class Product
          def self.create(base_price, imported)
            if imported
              ImportedProduct.new(base_price, imported)
            elsif base_price > 1000
              LuxuryProduct.new(base_price)
            else
              Product.new(base_price)
            end
          end
        end
      end
    end
  end
end
