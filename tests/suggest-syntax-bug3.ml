(* auto-generated by gt *)

open Bug3_util;;

type dummy = Dummy 
and deref = | Deref of pd * deref_deref_id0 * string
and deref_deref_id0 = pd * ( string) list;;

(* pd stands for pos (position) and extradata *)
let rec dummy () = () 
and pd_deref : deref -> pd = function 
  | Deref (d,_,_) -> d

and pd_deref_deref_id0 : deref_deref_id0 -> pd = function 
  | (d,[]) -> d

  | (d , (  )::f1239o2) -> d
;;
let pd e = pd_deref e;;
