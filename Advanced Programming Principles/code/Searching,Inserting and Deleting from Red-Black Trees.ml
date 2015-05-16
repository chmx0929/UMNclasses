                 (* Copyright (c) Gopalan Nadathur *)

(* The code for insert is based on material in Functional Data Structures
by Chris Okasaki *)

type color = R | B

type 'a rbtree =
    Empty
  | Node of color * 'a * 'a rbtree * 'a rbtree

(* Precondition: t is a tree that satisfies all the properties of being
                 a red-black tree except that some one red child may
                 have a red child
   Invariant: (balance t) returns a new tree with the same black height as
              t that may either have one red-red conflict between the root
              and a child or may have a root whose color has changed from
              red to black; these conditions are exclusive *)
let balance t =
  match t with
  | ( Node(B,z,Node(R,x,Node(R,y,a,b),c),d) |
      Node(B,z,Node(R,y,a,Node(R,x,b,c)),d) |
      Node(B,y,a,Node(R,z,Node(R,x,b,c),d)) |
      Node(B,y,a,Node(R,x,b,Node(R,z,c,d))) ) ->
        Node(R,x,Node(B,y,a,b),Node(B,z,c,d))
  |  _ -> t

(* Precondition: t is assumed to be a red-black tree
   Invariant: (insert t d) returns a new red-black tree that
               contains all the data in t plus the additional item d *)
let insert t d =

   (* Precondition: t is a red black tree
      Invariant: (ins t) returns a tree with all the data in t plus d
                 that additionally satisfies the properties of being a
                 red-black tree except that there may be a violation of
                 the no red child for a red parent constraint at the root.
                 Also, the black height of t is preserved. *)
   let rec ins t =
     match t with
     | Empty -> Node (R, d, Empty, Empty)
     | Node (c,d',l,r) ->
         if (d < d') then balance (Node (c,d',ins l, r))
         else balance (Node (c,d', l,ins r))
   in match (ins t) with
      | Node (_,d,l,r) -> Node (B,d,l,r)
      | Empty -> raise (Invalid_argument "insert")


(* code for deleting from a red-black tree *)

(* Understanding the algorithm for delete

When we delete a node, we may end up shortening the black height of a
subtree by one. We work back up the tree, fixing the possible
discrepancy. The invariant that holds when we work back up

   (1) the left and right subtrees both satisfy the equal black
       heights property
   (2) one of them possibly has a black height one less than the other.
   (3) if it has a black height one less, then its root is black (else
       the difference is easily fixed).

When we work back up, we maintain another property: the black height
at the root that we fix will be the same as before or one less. We
consider the two symmetric cases below.

I. Left subtree has black height one less

   There are two main cases here: the root of the right subtree is R
   or B. If it is R, we transform the problem into one where we have
   to only deal with the case where the root is B.

   Case 1 (right root is R):

   The tree we have is Node(B,pd,l,Node(R,rd,rl,rr)). Note that the
   root must be B because the right subtree has an R root.

   First we rotate this to get Node(B,rd,Node(R,pd,l,rl),rr).

   We have to first verify that this structure satisfies the
   invariants. rl and rr have to have B roots since they are children
   of a node with an R color. Also, by assumption, l has a B root.
   It is also easy to check the black height property.

   Now we transform the tree Node(R,pd,l,rl); this fits into the
   category where the right has a B root. Also, since its root is R,
   the transformation will actually produce a tree with the required
   height. (See below for the case when the root is R.) Call this nl.
   The tree Node(B,rd,nl,rr) now represents the fixed tree.

   Case 2 (Right root is B):

   There are three subcases

   (a) The right child of the right subtree is R, i.e. we have the tree
       Node(pc,pd,l,Node(B,rd,rl,Node(R,rrd,rrl,rrr))).

       We rotate this into Node(pc,rd,Node(B,pd,l,rl),Node(B,rrd,rrl,rrr))
       and we get a tree with the right height, i.e. the rectification
       is done.

   (b) The left child of the right subtree is R. Here we have the tree
       Node(pc,pd,l,Node(B,rd,Node(R,rld,rll,rlr),rr)).

       In this case, we rotate the right subtree right to reduce the
       problem to the subcase (a):
       Node(pc,pd,l,Node(B,rld,rll,Node(R,rd,rlr,rr))).
       All the invariants can be checked. We now fix this tree.

   (c) Finally we have the case where the both the left and right
       children of the right subtree are B. Here we have
       Node(pc,pd,l,Node(B,rd,rl,rr)); the right and left trees
       could be empty, so they are not shown in expanded form.

       Now we reduce the height of the right subtree by one to
       equalize the left and right. Finally, if the root color is R
       (i.e. pc = R), we color it B and we are done. Otherwise, we
       have fixed this tree, but we have a tree whose height is 1 less
       than it needs to be.

I. Right subtree has black height one less

    This case is symmetric; details are omitted.
*)

let rec fix_left l r pd pc =
   match r with
   | Node(R,rd,rl,rr) ->
        let (nl,_) = fix_left l rl pd R in (Node (B,rd,nl,rr),true)
   | Node(B,rd,rl,Node(R,rrd,rrl,rrr)) ->
         (Node(pc,rd,Node(B,pd,l,rl),Node(B,rrd,rrl,rrr)), true)
   | Node(B,rd,Node(R,rld,rll,rlr),rr) ->
         fix_left l (Node(B,rld,rll,Node(R,rd,rlr,rr))) pd pc
   | Node(B,rd,rl,rr) -> (Node(B,pd,l,Node(R,rd,rl,rr)), pc = R)
   | Empty -> raise (Invalid_argument "fix_left")

let rec fix_right l r pd pc =
   match l with
   | Node(R,ld,ll,lr) ->
        let (nr,_) = fix_right lr r pd R in (Node(B,ld,ll,nr),true)
   | Node(B,ld,Node(R,lld,lll,llr),lr) ->
        (Node(pc,ld,Node(B,lld,lll,llr),Node(B,pd,lr,r)),true)
   | Node(B,ld,ll,Node(R,lrd,lrl,lrr)) ->
        fix_right (Node(B,lrd,Node(R,ld,ll,lrl),lrr)) r pd pc
   | Node(B,ld,ll,lr) -> (Node(B,pd,Node(R,ld,ll,lr),r), pc = R)
   | Empty -> raise (Invalid_argument "fix_right")


let rec delete t i =
  let rec delete_root t =
    let rec largest_and_rest =
          function
            | Empty -> None
            | Node (c,d,l,r) ->
               match (largest_and_rest r) with
               | None -> Some (d,l,c=R)
               | Some (d',r',true) -> Some(d',Node (c,d,l,r'),true)
               | Some (d',r',false) ->
                  let (t,fixed) = fix_right l r d c in Some (d',t,fixed) in

    match t with
     | Empty -> raise (Invalid_argument "delete_root")
     | Node (c,_,l,r) ->
         match (largest_and_rest l) with
         | None -> (r,c=R)
         | Some(d,nl,true) -> (Node(c,d,nl,r),true)
         | Some(d,nl,false) -> fix_left nl r d c in

    let rec delete_aux t =
      match t with
      | Empty -> (t,false)
      | Node (c,ind,l,r) ->
        if (i = ind)
        then (delete_root t)
        else if (i < ind)
             then let (nl,fixed) = delete_aux l
                  in if fixed then (Node (c,ind,nl,r),true)
                     else fix_left nl r ind c
             else let (nr,fixed) = delete_aux r
                  in if fixed then (Node (c,ind,l,nr),true)
                   else fix_right l nr ind c in

    match (delete_aux t) with
    | (Empty,_) -> Empty
    | (Node(_,d,l,r),_) -> Node(B,d,l,r)