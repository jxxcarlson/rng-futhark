# A Simple Random Number Generator in Futhark

The random number generator code below is part of a project to learn and explain Futhark. It is intended for experimentation only, not production use. **Forewarned!**

The generator has an internal state consisting of a triple of integers.  These are used to drive three indpendent linear congruential generators (LCGs) of the form `f(x) = a*x mod n`.  A new state is computed by the rule `new_state = ff(old_state)`, where

```
    ff(s1, s2, s3) = (f1 s1, f2 s2, f3 s3)
```

and `f1`, `f2`, `f3` are LCGs as above. When the state of the generator is updated, the three components of the state are combined to give a random real number (f32) between 0 and 1. One can use the generator (function `lcgen`) to produce a sequence of pseudorandom numbers.  See functions `iterate` and `gen_sequence`

See the comments in the file for more info.

## Benchmarks

The raw results below are in microseconds

```
                  Number       Time  
                  -------------------
                     1000    0.4 sec
                   10,000    3.5 sec
                  100,000   44.6 sec
```

```
$ echo 1000 | ./rng-opencl -t \/dev/stderr > /dev/null
409075
$ echo 10000 | ./rng-opencl -t \/dev/stderr > /dev/null
3533682
$ echo 100000 | ./rng-opencl -t \/dev/stderr > /dev/null
44615655
```
