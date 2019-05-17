module xrng = {

  -- The state of the generators consists of a
  -- triple of integers plus a floating point number

  type state = (i64, i64, i64, f32)

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

  let generate ((s0, s1, s2, u):state) : state =
    let t0 = f0 s0
    let t1 = f1 s1
    let t2 = f2 s2
    let u = (f32.i64 t0)/fm0 + (f32.i64 t0)/fm1 + (f32.i64 t0)/fm2
    in (t0, t1, t2, mod1 u)

  -- let orbit  (f:state -> state) (a:state) (n:i32): []state =
  --   let
  --     reducer state_list k = state_list ++ [f(state_list[(length state_list) - 1])]
  --   in
  --    reduce reducer [a] (range 0 n)

 let orbit (f:state -> state) (a:state) (n:i32): []state =
   loop list = [a] for i < n do
      let k = (length list) - 1
      let last_element = list[k]
      in list ++ [f last_element]

 let generate_sequence (a:state) (n:i32) : [](f32) =
   orbit generate a n
     |> map (\(a, b, c, x) -> x)
}
-- compiile with `futhark c rng-simple.fut`
-- test with $ echo 1000 | ./xrng-c

let main (n: i32): []f32 =
  xrng.generate_sequence (1,2,3,0) n
