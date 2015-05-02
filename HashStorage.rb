########################################################################################
# Author: Manuel Stephan
# Contact: ms-elektronik@gmx.net
# Date: 02.05.2015
#----------------------------------------------------------
# Purpose:  
#			class HashStorage, permanently store Hashtables {key,value} in files
# Parameters: 
#			name:string:filename
#			path:string:path to file 
# Example: 
# 			s = HashStorage.new("waldo.sto") # instanziating
# 			s.push("a","hello") # adding a new key, value pair to the hash
#			puts s.get("a") # get the value to the key
# 			s.delete("a") # delete a key value pair 
# Note: 
#			The Hashtable will be written to file on destruction of the HashStorage object, so if your program exits on error the Hashtable might not be wirtten to file.
class HashStorage

	def initialize(name,path = false)

		@name = name
		if !(path == false)
			@path = path
		else
			@path = Dir.pwd # the current directory is the default path
		end

		@storage = Hash.new
		@pathToFile = @path + "/" + @name

	    if File.file?(@pathToFile)
		f = File.open(@pathToFile,"r")
			f.each_line do |line|
				line = line.delete("\n") # remove linebreak
				line = line.delete(" ") # remove whitespaces
				line = line.split(',')
				@storage[line[0]]=line[1]
			end
		f.close
		else 
			puts "HashStorage Instance has invalid file-path!"
		end
		puts @storage

		ObjectSpace.define_finalizer( self, self.class.finalize(@pathToFile,@storage) )

	end

    def push(key,value)
		@storage[key] = value
	end
	
	def get(key)
		return @storage[key] if @storage.has_key?(key)
		return false
	end
	
	def delete(key)
		if @storage.has_key?(key)
			@storage.delete(key) 
			return true
		else
			return false 
		end 
	end
	
	def self.finalize(pathToFile,storage)
	proc {
		f = File.open(pathToFile,"w")
		storage.each do |key,value|
			f.puts "#{key},#{value}"
		end
	   f.close
	}
	end
	
end # end class HashStorage
