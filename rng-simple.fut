module xrng = {

  let m0 = 2144748364:i64
  let m1 = 30269:i64
  let m2 = 30323:i64

  let fm0 = f64.i64 m0
  let fm1 = f64.i64 m1
  let fm2 = f64.i64 m2

  let a0 = 16807:i64
  let a1 = 172:i64
  let a2 = 170:i64

  let f0 (x:i64) : i64 = a0*x % m0
  let f1 (x:i64) : i64 = a1*x % m1
  let f2 (x:i64) : i64 = a2*x % m2

  let mod1 (x:f64): f64 =
    x - (f64.round x)

  let generate ((s0:i64), (s1:i64), (s2:i64), (u:f64)) : (i64, i64, i64, f64)=
    let t0 = f0 s0
    let t1 = f1 s1
    let t2 = f2 s2
    let u = (f64.i64 t0)/fm0 + (f64.i64 t0)/fm1 + (f64.i64 t0)/fm2
    in (t0, t1, t2, mod1 u)




}
