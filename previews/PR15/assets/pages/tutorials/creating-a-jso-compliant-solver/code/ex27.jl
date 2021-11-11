# This file was generated, do not modify it. # hide
cost(df) = (df.status .!= :first_order) * Inf + df.elapsed_time
performance_profile(stats, cost)
png(joinpath(@OUTPUT, "perfprof2")) # hide