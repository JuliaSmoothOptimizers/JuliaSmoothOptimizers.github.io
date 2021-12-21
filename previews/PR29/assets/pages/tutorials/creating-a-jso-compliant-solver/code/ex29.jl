# This file was generated, do not modify it. # hide
solvers = Dict(:newton => newton2, :lbfgs => lbfgs)
stats = bmark_solvers(solvers, problems)
cost(df) = (df.status .!= :first_order) * Inf + df.elapsed_time
performance_profile(stats, cost)
png(joinpath(@OUTPUT, "perfprof3")) # hide