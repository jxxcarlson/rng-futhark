# A Simple Random Number Generator in Futhark

The random number generator code below is part of a project to learn and explain Futhark. It is intended for experimentation only, not production use. **Forewarned!**

The generator has an internal state consisting of a triple of integers.  These are used to drive three indpendent linear congruential generators (LCGs) of the form `f(x) = a*x mod n`.  A new state is computed by the rule `new_state = ff(old_state)`, where

```
    ff(s1, s2, s3) = (f1 s1, f2 s2, f3 s3)
```

and `f1`, `f2`, `f3` are LCGs as above. When the state of the generator is updated, the three components of the state are combined to give a random real number (f32) between 0 and 1.  See the comments in the file for more info.

## A Monte Carlo computation

We use the random number generator to compute a value for $\pi$. The idea is to randomly sprinkle $N$ points in the square $-1 \le x \le 1$, $-1 \le y \le 1$ and count the number $n$ that land inside the unit circle, $x^2 + y^2 \le 1$.  Then $4n/N$ is an approximation to $\pi$. The method converges quiet slowly, so this is not a great way to compute $\pi$.

For much better MonteCarlo method for computing  $\pi$, see [futhark-book.readthedocs.io](https://futhark-book.readthedocs.io/en/latest/random-sampling.html).

For many other problems, Monte Carlo methods are the method of choice.  See these references, for example:

[An Overview of MonteCarlo Methods @ towardsdatascience.com](https://towardsdatascience.com/an-overview-of-monte-carlo-methods-675384eb1694)

[The Monte Carlo method @ Science direct](https://www.sciencedirect.com/topics/neuroscience/monte-carlo-method)

[Monte Carlo methods @ Deep Learning Book](https://www.deeplearningbook.org/contents/monte_carlo.html)




## Benchmarks

The timings are in microseconds

```
              Number       Time       Value for Pi
              -------------------------------------
                   1000      31 µsec   3.0640
                 10,000     275 µsec   3.1476
                100,000   1,586 µsec   3.1416
              1,000,000  18,436 µsec   3.1350 (!!)
```
