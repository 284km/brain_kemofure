#!/usr/bin/env ruby

class BrainKemofure
  def initialize(code)
    @tokens = code.scan(/(#{words})/).flatten
    @jumps = analyze_jumps(@tokens)
  end

  def words
      [
       # +
       'わーい',
       'すごーい',
       'たーのしー',
       'お任せなのだ',

       # -
       'またやってしまったねぇ',
       'いやーめんごめんご',
       '平気平気',
       'フレンズによって得意なこと違うから',
       'サイサイサーイ',
       'お待ちなサーイ',

       # >
       'あなたは何のフレンズさんですか？',
       # <
       'われわれはかしこいので',

         # .
       'やりますね',
       'どうもどうもありがとう',

       # [
       '食べないでください',
       # ]
       '食べないよ',

      ].join('|')
  end

  def run
    array = []
    index = 0
    now = 0

    while index < @tokens.size
      case @tokens[index]
        when 'わーい', 'すごーい', 'たーのしー'
          array[now] ||= 0
          array[now] += 1
        when 'またやってしまったねぇ'
          array[now] ||= 0
          array[now] -= 1
        when 'あなたは何のフレンズさんですか？'
          now += 1
        when 'われわれはかしこいので'
          now -= 1
        when 'やりますね'
          n = (array[now] || 0)
          print n.chr
        when ','
          array[now] = $stdin.getc
        when '食べないでください'
          index = @jumps[index] if array[now] == 0
        when '食べないよ'
          index = @jumps[index] if array[now] != 0
      end
      index += 1
    end
  end

  private

  def analyze_jumps(tokens)
    stack = []
    jumps = {}
    start_word = '食べないでください'
    end_word = '食べないよ'
    tokens.each_with_index do |v,i|
      if v == start_word
        stack.push(i)
      elsif v == end_word
        from = stack.pop
        to = i
        jumps[from] = to
        jumps[to] = from
      end
    end
    jumps
  end
end

BrainKemofure.new(ARGF.read).run
