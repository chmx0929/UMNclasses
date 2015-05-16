                 (* Copyright (c) Gopalan Nadathur *)

(* Code for comparing frontiers of trees---see lecture slides on expression 
   evaluation for context *)

type 'a tree =
  | Empty | Leaf of 'a | Node of ('a tree) * ('a tree)

let rec frontier t = 
   match t with 
   | Empty -> []
   | Leaf x -> [x]
   | Node (t1,t2) -> (frontier t1) @ (frontier t2)

(* We could use simple equality in OCaml for this *)
let rec equal l1 l2 =
   match (l1,l2) with 
   | ([],[]) -> true
   | (h1::t1,h2::t2) -> h1 = h2 && equal t1 t2
   | (_,_) -> false

(* This implementation is efficient in a lazy language but not in OCaml *)
let samefrontier x y = equal (frontier x) (frontier y)

(* Comparing frontiers of forests *)
let rec compforests f1 f2 =
   match (f1,f2) with 
   | ([],[]) -> true
   | ((Empty::x),y) -> compforests x y
   | (x,(Empty::y)) -> compforests x y
   | (((Leaf a)::x),((Leaf b)::y)) ->
      (a=b) && (compforests x y)
   | (((Node (l,r))::x),y) ->
       compforests (l::r::x) y
   | (x,((Node (l,r))::y)) -> 
       compforests x (l::r::y)
   | (_,_) -> false

(* Comparing the frontiers of trees; this implementation does the traversal
   incrementally and hence has the same kind of efficiency as the 
   straightforward implementation under lazy evaluation *)
let samefrontier' t1 t2 = compforests [t1] [t2]