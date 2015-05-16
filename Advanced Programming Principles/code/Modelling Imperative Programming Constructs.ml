type state = int * int * int

let getX (x,y,z) = x
let getY (x,y,z) = y
let getZ (x,y,z) = z

let x_plus_y_times_z =
   fun s -> (getX s) + (getY s) * (getZ s)

let putX exp s =
   let (x,y,z) = s in (exp s,y,z)
let putY exp s =
   let (x,y,z) = s in (x,exp s,z)
let putZ exp s =
   let (x,y,z) = s in (x,y,exp s)

let seq stat1 stat2 =
        fun s -> (stat2 (stat1 s))

let ifstat exp stat1 stat2 =
    fun s -> if (exp s) then (stat1 s)
             else (stat2 s)

let rec whilestat exp stat =
   fun s ->
      ifstat exp
             (seq stat (whilestat exp stat))
             (fun x -> x) s

let one = fun s -> 1
let z_times_x =
      (fun s -> (getZ s) * (getX s))
let x_plus_one =
      (fun s -> (getX s) + 1)
let x_lesseq_y =
      (fun s -> (getX s) <= (getY s))

let factexp =
    seq (putZ one)
        (seq (putX one)
              (whilestat x_lesseq_y
                      (seq (putZ z_times_x)
                           (putX x_plus_one))))