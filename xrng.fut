-- FILE: xrng.fut
-- This is a hand-made, not very good random number generator
-- used as a part of a project to learn and explain Futhark.
-- As an application, we compute an approximation to pi
-- using a Montecarlo method. Montecarlo methods are note
-- a good way to compute pi, but there are other problem areas,
-- e.g. physics and finance, where they are the method of choice.

module xrng = {

  -- Compile:       futhark opencl xrng.fut -o pi-opencl
  -- Bernchamrks:   echo 100000 | ./pi-opencl -t \/dev/stderr > /dev/null
  -- Compute pi:    echo 100000 | ./pi-opencl


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
-- BAD CODE: O(N**2)
let iterate (f:state -> (state,f32)) (a:state) (n:i32): (state, []f32) =
   loop output = (a, []) for i < n do
      let (state_, numbers) = output
      let (new_state_, new_number) = f state_
      in (new_state_, [new_number] ++ numbers)

-- LIKEWISE BAD CODE
let gen_sequence (seed:state) (n:i32) : (state, []f32) =
  iterate lcgen seed n

-- For Montec Carlo computatin of Pi
let pi_ (seed:state)(n:i32) : (state, i32)  =
  loop (state_, count:i32) = (seed, 0) for i < n do
    let (state_1, x_) = lcgen state_
    let (state_2, y_) = lcgen state_1
    let x = 2*x_ - 1
    let y = 2*y_ - 1
    let delta_count = if x*x + y*y < 1
      then 1
      else 0
    let new_count = count + delta_count
    in (state_2, new_count)

-- | Monte Carlo computation of pi:
--     > xrng.pi (1,3,5) 10000
--     3.1476f32
let pi (seed:state)(n:i32) : f32 =
  let count = (pi_ (seed:state)(n:i32)).2
  let ratio = (f32.i32 count)/(f32.i32 n)
  in  4*ratio

}


let main (n:i32): f32 =
  xrng.pi (1,2,3) n
