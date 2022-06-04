# This file was generated, do not modify it. # hide
using FFTW
function mulfft!(res, v, α, β::T) where T
  if β == zero(T)
    res .= α .* fft(v)
  else
    res .= α .* fft(v) .+ β .* res
  end
end
function mulifft!(res, w, α, β::T) where T
  if β == zero(T)
    res .= α .* ifft(w)
  else
    res .= α .* ifft(w) .+ β .* res
  end
end
dft = LinearOperator(ComplexF64, 10, 10, false, false,
                     mulfft!,
                     nothing,       # will be inferred
                     mulifft!)
x = rand(10)
y = dft * x
norm(dft' * y - x)  # DFT is a unitary operator