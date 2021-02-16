# Import Packages
using Pkg  # Package to install new packages

# Install packages 
Pkg.add("DataFrames")
Pkg.add("CSV")
Pkg.add("Plots")
Pkg.add("Lathe")
Pkg.add("GLM")
Pkg.add("StatsPlots")
Pkg.add("MLBase")

# Load the installed packages
using DataFrames
using CSV
using Plots
using Lathe
using GLM
using Statistics
using StatsPlots
using MLBase

# Enable printing of 1000 columns
ENV["COLUMNS"] = 1000

# Read the file using CSV.File and convert it to DataFrame
df = DataFrame(CSV.File("nyc-east-river-bicycle-counts.csv"))
first(df,5)

println(size(df))

# returns a data frame summarizing the elementary statistics and information about each column
describe(df)

# Check column names
names(df)

CSV.File("nyc-east-river-bicycle-counts.csv"; select=["Williamsburg Bridge", "Brooklyn Bridge"])
gr()
plot(df.Date, [df."Williamsburg Bridge", df."Brooklyn Bridge"], title = "Williamsburg Bridge vs Brooklyn Bridge")


plot(df."Precipitation", df."Date")