-- FILE: xrng.fut
-- This is a hand-made, not very good random number generator
-- used as a part of a project to learn and explain Futhark.

module xrng = {

  -- Compile:    futhark opencl xrng.fut -o rng-opencl
  -- Test:       echo 1000 | ./rng-opencl -t \/dev/stderr > /dev/null

  -- The state of the generators consists of a
  -- triple of integers plus a floating point number

  -- BENCHMARKS
  -- $ echo 1000 | ./rng-opencl -t \/dev/stderr > /dev/null
  -- 409075
  -- $ echo 10000 | ./rng-opencl -t \/dev/stderr > /dev/null
  -- 3533682
  -- $ echo 100000 | ./rng-opencl -t \/dev/stderr > /dev/null
  -- 44615655

  type state = (i64, i64, i64)

  -- Set up parameters for linear congruential generators

  let m0 = 2144748364:i64
  let m1 = 30269:i64
  let m2 = 30323:i64

  let fm0 = f32.i64 m0
  let fm1 = f32.i64 m1
  let fm2 = f32.i64 m2

  let a0 = 16807:i64
  let a1 = 172:i64
  let a2 = 170:i64

  let f0 (x:i64) : i64 = a0*x % m0
  let f1 (x:i64) : i64 = a1*x % m1
  let f2 (x:i64) : i64 = a2*x % m2

  -- return integer mod 1
  let mod1 (x:f32): f32 =
    x - (f32.trunc x)

  -- A linear congruential generator:
  let lcgen ((s0, s1, s2):state) : (state, f32) =
    let t0 = f0 s0
    let t1 = f1 s1
    let t2 = f2 s2
    let u = (f32.i64 t0)/fm0 + (f32.i64 t0)/fm1 + (f32.i64 t0)/fm2
    in ((t0, t1, t2), mod1 u)


-- Iterate the gnerator n times, returing the state of lcgen and
-- a list of f32's
let iterate (f:state -> (state,f32)) (a:state) (n:i32): (state, []f32) =
   loop output = (a, []) for i < n do
      let (state_, numbers) = output
      let (new_state_, new_number) = f state_
      in (new_state_, [new_number] ++ numbers)


let gen_sequence (seed:state) (n:i32) : (state, []f32) =
  iterate lcgen seed n

 -- Example: (xrng.iterate xrng.generate (1,2,3) 5).2

let main (n:i32): []f32 =
  (gen_sequence (1,2,3) n).2

}
