# This file was generated, do not modify it. # hide
using Plots
performance_profile(stats, df -> df.elapsed_time)
png(joinpath(@OUTPUT, "perfprof")) # hide