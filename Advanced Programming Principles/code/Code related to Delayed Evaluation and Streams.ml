                 (* Copyright (c) Gopalan Nadathur *)

(* Examples of delayed evaluation and streams used in the lecture *)

(* An abstraction for delaying evaluations; this one re-computes the
   expression each time *)
type 'a delay = Delay of (unit -> 'a)

let mkLazy e = Delay e
let force (Delay e) = e ()

(* An abstraction for delaying evaluations; this one uses sharing of
   computations, i.e. the value is recorded after the first computation *)
type 'a delay = 'a delay_aux ref
and 'a delay_aux =
      | Val of 'a
      | Delayed of (unit -> 'a)

let mkLazy' e = ref (Delayed e)
let force' e =
  match !e with
  | Val v -> v
  | Delayed dv -> let v = dv() in (e := Val v; v)

(* An abstraction for streams in OCaml *)
type 'a stream = Stream of (unit -> 'a * 'a stream)

let mkStream f = Stream f
let nextStream (Stream f) = f ()

(* the natural number stream in OCaml *)
let rec fromNStream n = mkStream (fun () -> (n, fromNStream (n+1)))
let natStream = (fromNStream 1)

(* The factorial stream *)
let rec fact n m () = (m, Stream (fact (n+1) (n*m)))
let factStream = mkStream (fact 1 1)

(* The fibonnaci stream *)
let rec fib f s () = (f, Stream (fib s (f+s)))
let fibStream = mkStream (fib 1 1)

(* A function for merges two streams into one *)
let rec merge s1 s2 () =
     let (x,rst) = nextStream s1 in
        (x, Stream (merge s2 rst))

let mergeStreams s1 s2 = Stream (merge s1 s2)

(* An implementation of the sieve of Eratosthenes *)
let rec sift a s () =
       let (x,rst) = nextStream s in
        if (x mod a = 0) then (sift a rst ())
        else (x, Stream (sift a rst))

let rec siftStream a s = mkStream (sift a s)

let rec sieve s () =
     let (x,rst) = nextStream s in
       (x, Stream (sieve (siftStream x rst)))

let sieveStream s = mkStream (sieve s)

let primesStream = sieveStream (fromNStream 2)

(* A function for "taking" n items from a stream; useful at least in testing
   the above streams *)
let rec take n s =
   match n with
   |  0 -> []
   |  n ->
        let (x,rst) = nextStream s in
          (x :: take (n-1) rst)