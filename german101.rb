require 'open-uri'
#### this program is intended to help me learn german, only properly handling one word inputs at a time
stay="done" ### place holder variable for infinite loop, must ctrl+c to get out of program
until stay=="go" ### infinite loop wrapper
usedGerman = Hash.new ### place holder for german to english definitions found
puts 'Special Characters: A = ä , O = ö, U = ü, B = ß'
puts 'Enter your german word: '
germanW = gets.chomp ### recieve german word that user wants to translate
germanW.sub!(" ", '+') ### URI does not allow spaces
wordWithSpecial = germanW ### place holder for german word with special character, needed because URI does not allow passing of special character
urlSpecial = germanW;### URI used to grab html

wordWithSpecial = germanW.gsub(/[ABOU]/, 'A' => 'ä', 'B' =>'ß', 'O' => 'ö', 'U' =>'ü')
urlSpecial = germanW.gsub(/[ABOU]/, 'A'=>'%C3%A4', 'B'=>'%C3%9F', 'O'=>'%C3%B6', 'U'=>'%C3%BC')

puts "English Translations for #{wordWithSpecial}: "
puts " "
open("http://www.linguee.com/english-german/search?source=german&query=#{urlSpecial}").each_line do |line| ### URI used to scrape html code from site

english = line.match(/english-german\/translation\/\w*.*\w*' class='dictLink featured'>(\w*\s*\w*)<\/a> /)### translated english word
german = line.match(/href='\/german-english\/translation\/\w*.html'>(\w*\s*\w*)<\/a>/)### german word being translated

type = line.match(/<span class='tag_type' title='(\w*\s*\w*)'>\w*\s*\w*<\/span>/)### words grammatical usage
breakWord = line.match(/Examples:/)### combined with the if above to prevent unnecessary results
if !breakWord.nil?
break
end
if !german.nil?
    puts ""
    german=german[1]
    if !usedGerman.key? ("#{german}")
        usedGerman[german]=1;
        puts german   
    end
    puts " "
end  
if !english.nil?
    english=english[1]

    if !english.include? "<"   
        p english

        if !type.nil?
            type = type[1]
            puts type
            
        end
    end
end
end
puts ""
### *** English to German ***
puts "Did you find what you were looking for? (Y/N)" ### y asks for another german word, n asks for an english word
answer = gets.chomp.upcase

if(answer=="N")

puts 'Enter the English word you were looking for: '
englishW = gets.chomp
englishW.sub!(" ", '+')
puts "German Translations of #{englishW}: "
open("https://www.collinsdictionary.com/dictionary/english-german/#{englishW}").each_line do |line|
  germanTrans = line.scan(/<q>(\w*)\s*<em/)

    germanTrans.each do |defs|
        defs=defs.to_s
      puts "German def : #{defs} "
      puts " "
    end  
end
end
end

