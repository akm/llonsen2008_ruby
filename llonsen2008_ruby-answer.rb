# -*- coding: utf-8 -*-

# このファイルは 2008/11/14〜16に湯布院で開かれた
# LL温泉2008のRubyチュートリアルの資料です。
# http://groups.google.com/group/llonsen2008/files
# のllonsen-object_ruby.pdfが当日参加者に配布した資料
# をすこし訂正したもので、これはその中のtry!の問題に対する
# 秋間の回答です。
# おかしな点などありましたら、http://d.hatena.ne.jp/akm 
# あるいは akm2000(at)gmail.com にご連絡ください。

#
# p.21 try!
#
# obj = Object.new
# def obj.count_up
#   # この中身を書くだけでできるはず
# end
# obj.count_up #=> 1
# obj.count_up #=> 2
# obj.count_up #=> 3
#
# という風に動作するメソッドの中身を書いてみよう
obj = Object.new
def obj.count_up
  @count ||= 0
  @count += 1
end
obj.count_up #=> 1
obj.count_up #=> 2
obj.count_up #=> 3

obj = Object.new
def obj.count_up
  @foo = (@foo || 0) + 1
end
obj.count_up #=> 1
obj.count_up #=> 2
obj.count_up #=> 3



#
# p.29 try! #1
#
# 文字列の中から数字のみを抜き出すpickup_numberメソッド
#
def pickup_number(str)
  str.to_s.scan(/\d/)
end
pickup_number(:foo)
pickup_number(:foo123)
pickup_number("aids20dfu9d0sfzodk23ds9dso3")
pickup_number("XXX")
pickup_number("123")

#
# p.29 try! #2
#
# SymbolかStringのオブジェクトを渡すと、末尾に _onsen が付いたSymbolを返す onsenizeメソッド
#
def onsenize(str)
  "#{str.to_s}_onsen".to_sym
end
onsenize('LL')
onsenize(:ruby)

#
# p.29 try! #3
#
# s = "ABC" に対して以下の違いは何？
# s << "D"
# s += "D"

s = "ABC"
p(id1 = s.object_id)
s << "D"
p(id2 = s.object_id)
p(id1 == id2)

s = "ABC"
p(id1 = s.object_id)
s += "D"
p(id2 = s.object_id)
p(id1 == id2)

s = "ABC"
p(id1 = s.object_id)
s1 = s + "D"
p(s1.object_id)
s = s1
p(id2 = s.object_id)
p(id1 == id2)


#
# p.31 try! #1
#
# get_at([1,2,3], :first) => 1
# get_at([1,2,3], :last) => 3
# となるようなget_atメソッド
def get_at(array, position)
  case position
  when :first then array.first
  when :last then array.last
  end
end
get_at([1,2,3], :first)
get_at([1,2,3], :last)


def get_at(array, position)
  (position == :first) ?  array.first :
  (position == :last) ?  array.last : nil
end
get_at([1,2,3], :first)
get_at([1,2,3], :last)


def get_at(array, position)
  array.send(position)
end
get_at([1,2,3], :first)
get_at([1,2,3], :last)

#
# p.31 try! #2
#
# カンマ区切りの文字列をバラして、ソートするsplit_sortメソッド
def split_sort(comma_string)
  comma_string.split(',').sort
end
split_sort("1,4,2,6,2,6,3")
split_sort("KLSU,0I)WR,E+LR#R(YU,IDOJWDHL,SWIUEIO,SJDIO")

#
# p.31 try! #3
#
# 数値のみで構成される配列の要素の合計を求めるsum_arrayメソッド
def sum_array(array)
  sum = 0
  array.each{|num| sum += num}
  sum
end
sum_array([1,2,3,4,5,6,7,8,9,10])

def sum_array(array)
  array.inject(0){|sum, num| sum + num}
end
sum_array([1,2,3,4,5,6,7,8,9,10])


#
# p.33 try! #1
#
# Hashと文字列を渡すと、キーの一部がその文字列に該当する値を配列で返す、select_valuesメソッド
language_developers = { 
  "ruby" => "Matz",
  "perl" => "Larry Wall",
  "python" => "Guido van Rossum",
  "php" => "Rasmus Lerdorf?"
}
def select_values(hash, search)
  result = []
  hash.each do |key, value|
    result << value if key.include?(search)
  end
  result
end

select_values(language_developers, "p")
select_values(language_developers, "r")


def select_values(hash, search)
  hash.keys.select{|key| key.include?(search)}
  #簡単に書こうと思ったけど、むずかしい
end

#
# p.33 try! #2
#
# 複数のHashの足し算をするmerge_hashメソッド(キーが重複したら上書きね)。
# def merge_hash(*hashes) って感じで
def merge_hash(*hashes)
  result = {}
  hashes.each{|hash| result.update(hash)}
  result
end
merge_hash({:a => 1}, {:b => 2}, {:c => 3})
merge_hash({:a => 1}, {:b => 2}, {:c => 3}, {:a => 4})

def merge_hash(*hashes)
  hashes.inject({}){|result, hash| result.update(hash)}
end
merge_hash({:a => 1}, {:b => 2}, {:c => 3})
merge_hash({:a => 1}, {:b => 2}, {:c => 3}, {:a => 4})


#
# p.33 try! #3
#
# どんなHashでもJSONのオブジェクトになる文字列 "{'キー': '値'}"にしちゃう、to_jsonメソッド
tree1 = { 
  :a => 1,
  :b => { 
    :a => "AA",
    :b => [3,
      { 
        :a => "123",
        :b => 2
      }
    ]
  }
}
def to_json(obj)
  if obj.is_a?(Hash)
    '{' << obj.map{|key, value| "'#{key.to_s}': #{to_json(value)}" }.join(',') << '}'
  elsif obj.is_a?(Array)
    '[' << obj.map{|item| to_json(item)}.join(',')  << ']'
  elsif obj.is_a?(String)
    "'#{obj.to_s}'"
  else
    obj.to_s
  end
end
to_json(tree1)


#
# p.34 try!
#
# 可変引数で、最後は名前付きの引数
# これまでのテクを組み合わせればきっとできる！
# obj.foo(1, 2, 3)
#  => [1, 2, 3] {:name => "A", :no => 1}
# obj.foo(1, 2, :name => "B") 
#  => [1, 2] {:name => "B", :no => 1}
# obj.foo(:name => "B") 
#  => [] {:name => "B", :no => 1}
#
obj = Object.new
def obj.foo(*args)
  options = args.last.is_a?(Hash) ? args.pop : {}
  options = {
    :no => 1, :name => "A"
  }.update(options)
  "#{args.inspect} #{options.inspect}"
end
obj.foo(1, 2, 3)
obj.foo(1, 2, :name => "B") 
obj.foo(:no => 8)





#
# p.43 try!
# 処理の順番のログがほしい！
#
# 左のコードを実行したら、下の出力を得ることができるlogメソッド。
# {}のブロックは、do...endに置き換えた方が分かるかも。
#
# (左のコード)
# def foo
#   log("in foo"){ yield("FOO") }
# end
# def bar
#   log("in bar") do 
#     foo do |v| 
#       log("in block for foo"){ yield(v) } 
#     end
#   end
# end
# bar do |v| 
#   log("in block for bar"){ v * 3 } 
# end
#
# (下の出力)
# in bar before
# in foo before
# in block for foo before
# in block for bar before
# in block for bar after
# in block for foo after
# in foo after
# in bar after
# => "FOOFOOFOO"
#
def log(msg)
  # 本当はbegin...ensure...endで
  # どんな場合もafterを出すべきかもね。
  puts "#{msg} before"
  result = yield
  puts "#{msg} after"
  result
end

def foo
  log("in foo") do 
    yield("FOO")
  end
end
def bar
  log("in bar") do 
    foo do |v| 
      log("in block for foo") do 
        yield(v)
      end
    end
  end
end
bar do |v| 
  log("in block for bar") do 
    v * 3
  end
end


#
# p.53 try! #1
#
# 文字列の配列から各要素をn回繰り返し、それらをカンマで区切った文字列を返すrepeat_joinメソッド
def repeat_join(strings, count = 1)
  strings.map{|str| str.to_s * count}.join(',')
end
repeat_join(%w(abc erv dsio 908dshoicds sdsdasdsa))
repeat_join(%w(abc erv dsio 908dshoicds sdsdasdsa), 3)

#
# p.53 try! #2
#
# 数値のみで構成される配列の要素から奇数を抽出して合計を出すodd_sumメソッド
def odd_sum(numbers)
  numbers.select{|num| num % 2 == 1}.inject(0){|sum, num| sum + num}
end
odd_sum([1,2,3,4,5,6,7,8,9,10])
