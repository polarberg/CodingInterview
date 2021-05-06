begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Compose",version="0.9"),
			Pkg.PackageSpec(name="Colors",version="0.12"),
			Pkg.PackageSpec(name="PlutoUI",version="0.7"),
			])

	using Colors
	using PlutoUI
	using Compose
	using LinearAlgebra
    using Unicode
end
isnothing(x::Any) = x === nothing ? true : false 
alphabet = ['a':'z' ; ' ']   # includes the space character
function isinalphabet(character)
	character ∈ alphabet
end
unaccent(str) = Unicode.normalize(str, stripmark=true)
filter(isodd, [6, 7, 8, 9, -5])
isinalphabet('a'), isinalphabet('+')

"é" == Unicode.normalize("é")
function clean(text)
	# accented letters are replaced by their base characters
	# upper-case letters are converted to lower case
	return filter(isinalphabet, lowercase(unaccent(text)))
end

clean("Crème brûlée est mon plat préféré.")

samples = ("Although the word forest is commonly used, there is no universally recognised precise definition, with more than 800 definitions of forest used around the world.[4] Although a forest is usually defined by the presence of trees, under many definitions an area completely lacking trees may still be considered a forest if it grew trees in the past, will grow trees in the future,[9] or was legally designated as a forest regardless of vegetation type.[10][11]\n\t\nThe word forest derives from the Old French forest (also forès), denoting \"forest, vast expanse covered by trees\"; forest was first introduced into English as the word denoting wild land set aside for hunting[14] without the necessity in definition of having trees on the land.[15] Possibly a borrowing, probably via Frankish or Old High German, of the Medieval Latin foresta, denoting \"open wood\", Carolingian scribes first used foresta in the Capitularies of Charlemagne specifically to denote the royal hunting grounds of the King. The word was not endemic to Romance languages, e. g. native words for forest in the Romance languages derived from the Latin silva, which denoted \"forest\" and \"wood(land)\" (confer the English sylva and sylvan); confer the Italian, Spanish, and Portuguese selva; the Romanian silvă; and the Old French selve, and cognates in Romance languages, e. g. the Italian foresta, Spanish and Portuguese floresta, etc., are all ultimately derivations of the French word. \n")
first_sample = clean(samples)

function letter_frequencies(txt)
	ismissing(txt) && return missing
	f = count.(string.(alphabet), txt)
	f ./ sum(f)
end

count(string.(alphabet), "ba")
alphabet
sample_freqs = letter_frequencies(first_sample)

count(string('l'), "Hello World")
count("l", "Hello World")
string.(alphabet)



function transition_counts(cleaned_sample)
	[count(string(a, b), cleaned_sample)
		for a in alphabet,
			b in alphabet]
end
normalize_array(x) = x ./ sum(x)
transition_frequencies = normalize_array ∘ transition_counts;
transition_frequencies(first_sample)
sample_freq_matrix = transition_frequencies(first_sample);

[(sample_freq_matrix[i,i]>0.0) ? alphabet[i] : nothing for i in 1:size(alphabet)[1]]

view(sample_freq_matrix, :, 1) # col 1 
row_sums = [ sum(view(sample_freq_matrix, i, :)) for i in 1:27 ] # row, col 
col_sums = [ sum(view(sample_freq_matrix, :, i)) for i in 1:27 ] 
row_sums + col_sums

emma = let
	raw_text = read(download("https://ia800303.us.archive.org/24/items/EmmaJaneAusten_753/emma_pdf_djvu.txt"), String)
	
	first_words = "Emma Woodhouse"
	last_words = "THE END"
	start_index = findfirst(first_words, raw_text)[1]
	stop_index = findlast(last_words, raw_text)[end]
	
	raw_text[start_index:stop_index]
end;
function splitwords(text)
	# clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	# split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s|\b)")
end
emma_words = splitwords(emma)
forest_words = splitwords(samples.English)

function bigrams(words)
	starting_positions = 1:length(words)-1
	
	map(starting_positions) do i
		words[i:i+1]
	end
end
bigrams([1, 2, 3, 42])

function ngrams(words, n)
	starting_positions = 1:length(words)+1-n
	
	map(starting_positions) do i
		words[i:i+n-1]
	end
end
ngrams([1, 2, 3, 42], 3)

ngrams([1, 2, 3, 42], 2) == bigrams([1, 2, 3, 42])


# Dictionaries 
healthy = Dict("fruits" => ["🍎", "🍊"], "vegetables" => ["🌽", "🎃", "🍕"])
healthy["fruits"]
healthy["girl"] = ["👧"]
healthy

function word_counts(words::Vector)
	counts = Dict()	
	# your code here
	for key in words
		# if key is in dict, add 1, else create new key-val pair 
		haskey(counts, key) ? counts[key] += 1 : counts[key] = 1 
	end
	
	return counts
end

counts = Dict()
w = ["to", "be", "or", "not", "to", "be"]
for key in w
	# if key is in dict, add 1, else create new key-val pair 
	haskey(counts, key) ? counts[key] += 1 : counts[key] = 1 
end
size(w)
counts["be"] += 1 || counts["be"] = 1
counts
haskey(counts, "to")

word_counts(["to", "be", "or", "not", "to", "be"])["be"]

word_counts(emma_words)
emma_count = word_counts(emma_words)["Emma"] 


ngrams(split("to be or not to be that is the question", " "), 3)
let
    trigrams = ngrams(split("to be or not to be that is the question", " "), 3)
    cache = completions_cache(trigrams)
    cache == Dict(
        ["to", "be"] => ["or", "that"],
        ["be", "or"] => ["not"],
        ["or", "not"] => ["to"],
        ...
    )
end
# takes an array of ngrams (i.e. an array of arrays of words, like the result of your ngram function), 
# returns a dictionary 
function completion_cache(grams)
	cache = Dict()
	
	# your code here	
	n = size(grams[1],1) # size of each vector in n-gram 	
	for i in grams		
		key = i[1:n-1] # key: vector containing first n-1 elements of each gram 
		val = i[n] # val: nth elem of gram 
		# if key is NOT in dict, create new key-val pair. 
		if !(haskey(cache, key)) 
			cache[key] = [val] # val is just a string so need to "vectorize"
		elseif !(val in cache[key]) # if nth elem is NOT already in val vector,
			push!(cache[key], val)
		end 
	end

	return cache
end

let
	trigrams = ngrams(split("to be or not to be that is the question", " "), 3)
	completion_cache(trigrams)
end
	
let # testing 
	trigrams = ngrams(split("to be or not to be that is the question", " "), 3)
	size(trigrams[1],1)
	trigrams[1][3]

	testing = Dict()
	testing[["a","b"]] = ["1", "2"]
	testing[["c","d"]] = ["3", "4"]
	testing
	haskey(testing, "a")
	w
	push!(w,"hello") # https://stackoverflow.com/questions/28524105/julia-append-to-an-empty-vector 
	"hello" in w
	tmpkey = ["a","b"]	
	tmpval = "1"
	tmpval in testing[tmpkey] # https://stackoverflow.com/questions/59555180/how-can-i-determine-if-an-array-contains-some-element 
	push!(testing[["a","b"]],"hello")
end

