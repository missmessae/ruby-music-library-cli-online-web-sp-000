require 'pry'

class MusicLibraryController
  extend Memorable::ClassMethods

  attr_accessor :music

  def initialize(path = "./db/mp3s")
    @music = MusicImporter.new(path)
    @music.import
  end

  def sorter
    @music.files.sort
  end

  def call
    puts "Welcome to your music library!"
    puts "To list all of your songs, enter 'list songs'."
    puts "To list all of the artists in your library, enter 'list artists'."
    puts "To list all of the genres in your library, enter 'list genres'."
    puts "To list all of the songs by a particular artist, enter 'list artist'."
    puts "To list all of the songs of a particular genre, enter 'list genre'."
    puts "To play a song, enter 'play song'."
    puts "To quit, type 'exit'."
    input = ""
    while input != "exit"
      puts "What would you like to do?"
      input = gets.strip
      case input
      when "list songs"
        list_songs
      when  "list artists"
        list_artists
      when "list genres"
        list_genres
      when "play song"
        play_song
      when "list artist"
        list_songs_by_artist
      when "list genre"
        list_songs_by_genre
      end
    end
  end

  def list_songs
    @sorted_songs.sorter.each_with_index do|song, num|
      puts "#{num+1}. #{song}"
    end
  end

  def list_artists
    a_sorted = Artist.all.sort
    a_sorted.each_with_index do |artist, num|
      puts "#{num+1}. #{artist.name}"
    end
  end

  def list_genres
    Genre.all.each do |genre|
      puts genre.name
    end
  end

  def play_song
    puts "What song number would you like to play?"
    song_num = gets.chomp
    playing_song = @sorted_songs[song_num.to_i - 1]
    puts "Playing #{playing_song}"
  end

  def list_songs_by_artist
    array = @music.files.collect do |file|
      song = self.class.split_filename(file)
    end
    puts "What artist would you like to list songs for?"
    artist_input = gets.chomp
    artist = Artist.find_by_name(artist_input)
    array.each do |song|
      if song[0] == artist.name
        puts "#{song[0]} - #{song[1]} - #{song[2]}"
      end
    end
  end

  def list_songs_by_genre
    array = @music.files.collect do |file|
      song = self.class.split_filename(file)
    end
    puts "What genre would you like to list songs for?"
    genre_input = gets.chomp
    genre = Genre.find_by_name(genre_input)
    array.each do |song|
      if song[2] == genre.name
        puts "#{song[0]} - #{song[1]} - #{song[2]}"
      end
    end
  end
end
