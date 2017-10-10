require 'tty-screen'

class Framer

  def self.colorize(color, text)
    return "\e[#{color}m#{text}\e[0m"
  end

  def self.frame(text, vertical_char, horizontal_char, color)
    console_width = TTY::Screen.width-2
    last_whitespace = -1
    for i in 1..text.length/console_width
      text[i*console_width]="\n"
    end
    split_text = text.split("\n")
    max = 0
    split_text.each do |line|
      if line.length > max
        if line.length < console_width
          max = line.length
        else
          max = console_width
        end
      end
    end
    puts colorize(color, horizontal_char*(max + 2))
    split_text.each do |line|
      puts colorize(color, vertical_char+line+' '*(max-line.length)+vertical_char)
    end
    puts colorize(color, horizontal_char*(max + 2))
  end
end