# frozen_string_literal: true

#                 ╔═════════════════════════════════════════════╗
#                 ║ Replace Loop with Collection Closure Method ║
#                 ╚═════════════════════════════════════════════╝

#  ╓                                                          ╖
#  ║ コレクションの要素をループで処理している                 ║
#  ║ ループでなく、コレクションクロージャメソッドを使う       ║
#  ╙                                                          ╜

class ReplaceLoopWithCollectionClosureMethod
  class Sample::Before
    def select_before
      managers = []
      employees.each do |e|
        managers << e.manager?
      end
    end

    def collect_before
      offices = []
      employees.each { |e| offices << e.office }
    end

    def method_chain_before
      managerOffices = []

      employees.each do |e|
        managerOffices << e.office if e.manager?
      end
    end
  end

  class Sample::After
    def select_after
      managers = employees.select(&:manager?)
    end

    def collet_after
      offices = employees.collect(&:office)
    end

    def method_chain_after
      managerOffices = employees.select(&:manager?)
                                .collect(&:office) # 行末をドットにすると、Rubyは行末を文の区切りと考えてはならないと判断する
    end

    合計の計算のように、
    ループ内でひとつの値を生み出すような処理をしなければならない時には、
    injectを検討する
  end
end
