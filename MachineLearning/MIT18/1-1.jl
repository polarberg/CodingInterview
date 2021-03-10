begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["Images", "ImageMagick", "Colors", "PlutoUI", "HypertextLiteral"])

	using Images
	using Colors
	using PlutoUI
	using HypertextLiteral
end