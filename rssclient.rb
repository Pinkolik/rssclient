require 'rss'
require 'open-uri'
require '.\framer.rb'

class RSSClient
  def add_link(link, name)
    File.open('links.txt', 'r') do |linksFile|
      linksFile.each_line do |line|
        if (line.split[0].downcase == link.downcase || line.split[1].downcase == name.downcase)
          linksFile.close
          puts 'This link or name already exists!'
          return
        end
      end
    end
    File.open('links.txt', 'a') do |linksFile|
      linksFile.puts link + ' ' + name
    end
    puts name + 'was added successfully!'
  end

  def remove_link(name_to_remove)
    File.open('links.txt', 'r') do |originalFile|
      File.open('linkstmp.txt', 'w') do |newFile|
        originalFile.each_line do |line|
          name = line.split[1];
          if (name.downcase != name_to_remove.downcase)
            newFile.puts(line);
          end
        end
      end
    end
    File.delete('links.txt')
    File.rename('linkstmp.txt', 'links.txt')
    puts name_to_remove + ' was removed successfully!'
  end

  def show_channels
    File.open('links.txt', 'r') do |linksFile|
      linksFile.each_line do |line|
        Framer::frame(line.split[1], '|', '-', 32)
      end
    end
  end

  def show_news(name_to_show)
    found = false
    File.open('links.txt', 'r') do |file|
      file.each_line do |line|
        name = line.split[1]
        url = line.split[0]
        if (name.downcase == name_to_show.downcase)
          found = true
          open(url) do |rss|
            feed = RSS::Parser.parse(rss)
            Framer::frame("#{feed.channel.title}", '#', '#', 91)
            feed.items.each do |item|
              Framer::frame("#{item.title}", '#', '#', 93)
              Framer::frame("#{item.description}\n#{item.date}", '|', '-', 96)
              puts 'Press q to quit, press any key to continue'
              if (gets == "q\n")
                break
              end
            end
          end
        end
      end
    end
    if found == false
      puts "No such channel found!"
    end
  end

  def show_help
    text = ''
    File.open('help.txt', 'r') do |helpFile|
      helpFile.each_line do |line|
        text+=line
      end
    end
    puts Framer.frame(text, '#', '#', 95)
  end

  def run_command(input_string)
    system('cls')
    split_string = input_string.split
    command = split_string[0]
    case command
      when '/help'
        show_help
      when '/add'
        add_link(split_string[1], split_string[2])
      when '/remove'
        remove_link(split_string[1])
      when '/shownews'
        show_news(split_string[1])
      when '/showchannels'
        show_channels
      when '/exit'
        exit(0)
      else
        puts 'Unknown command. Type /help for more info'
    end
  end

  def initialize
    system('cls')
    Framer::frame("RSSClient v.0.0.1\nType /help for more info", '#', '#', 33)
  end
end