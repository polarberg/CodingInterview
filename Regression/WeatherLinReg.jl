#= Weather in Szeged 2006-2016: 
    Is there a relationship between humidity and temperature? 
    What about between humidity and apparent temperature? Can you predict the apparent temperature given the humidity? =#

# Import Packages
using Pkg  # Package to install new packages

# Install packages 
Pkg.add("DataFrames")
Pkg.add("CSV")
Pkg.add("Plots")
#Pkg.add("Lathe")
Pkg.add("GLM")
#Pkg.add("StatsPlots")
#Pkg.add("MLBase")

# Load the installed packages
using DataFrames
using CSV
using Plots
#using Lathe
using GLM
using Statistics
#using StatsPlots
#using MLBase

# Enable printing of 1000 columns
ENV["COLUMNS"] = 1000

# Read the file using CSV.File and convert it to DataFrame
df = DataFrame(CSV.File("weatherHistory.csv"))
first(df,5)

println(size(df))
describe(df)    # returns a data frame summarizing the elementary statistics and information about each column
names(df)   # Check column names

CSV.File("weatherHistory.csv"; select=["Temperature (C)", "Humidity"])
Y = df."Temperature (C)"
X = df."Humidity"
data = DataFrame(X,Y)
ols = lm(@formula(Temperature (C) ~ Humidity), data)

# create scatter plot 
#plot(df."Temperature (C)", df."Humidity")