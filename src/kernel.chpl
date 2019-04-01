// This is currently just test code to see if I can write up an integrator.
// It's an integration kernel, meaning it's what we'll apply to each data point.
// Not sure of the most efficient model yet, so let's just start by writing
// the very basic types of functions we'll need.

// We will need a proper entropy source for this, as we require a stochastic
// kick.  That's important in Brownian Dynamics.

// The wikipedia article on this isn't terrible, so.
// https://en.wikipedia.org/wiki/Brownian_dynamics

// Remember that everything is basically F=MA (Full Metal Alchemist!)
// So our basic equation of motion (normal Langevin motion) is:
// M*A = -G(U(d^2*X/dt^2)) -(k_f*dX/dt) + sqrt(2k_f*k_b*T)*R(t)
// M = mass
// A = acceleration
// X = position
// -G() = gradient operator
// U() = energy
// so -G(U(d^2*X/dt^2)) is the force coming from particle interactions
// k_f = friction coefficient
// k_b = Boltzmann's constant
// T = temperature
// R(T) = delta-correlated stationary Gaussian process, which is basically the
// random kick.  The specifics of this equation will come later.

// Keep in mind that the point of this isn't to write out an accurate
// potential function yet; we just want to make sure it works.

proc langevinTestEquation() {

}
