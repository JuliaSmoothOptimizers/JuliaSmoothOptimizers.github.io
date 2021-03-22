# This file was generated, do not modify it. # hide
using FFTW, LinearAlgebra

A = LinearOperator(16, 16, false, false, fft, nothing, ifft)

v = rand(16) + im * rand(16)
norm(A * v - fft(v)), norm(A' * v - ifft(v)), norm(Matrix(A' * A) - I)