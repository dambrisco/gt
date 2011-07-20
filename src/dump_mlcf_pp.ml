open Grammar;;
open Trie;;

let os s = print_string s;;

let starts_with sub st = 
	let sub_ln = String.length sub in
	if(sub_ln > String.length st) then (false)
	else (
		if(String.sub st 0 sub_ln = sub) then (true)
		else (false)	
	);;

let symbol_var_name (s,b) = s;;

let symbol_ctor_name (s:string) = s;;

let numbered xs =
		let n = ref 0 in
	List.map (fun x -> n := !n+1; (x,!n)) xs;;

let starts_with_nonterminal ss = 
	match ss with
		[] -> false
		| s::ss' -> (not (is_terminal s));;

let svn_pos ss s = 
	let n = ref 0 in 
	let n' = ref 0 in 
	if(not(starts_with_nonterminal ss)) then (incr n);
	List.iter(fun s' ->
		incr n;
		if((symbol_var_name s') = symbol_var_name (s,false)) then (n' := !n);
	) ss; !n';;

let starts_with sub' st = 
	let sub_ln = String.length sub' in
	if(sub_ln > String.length st) then (false)
	else (
		if(String.sub st 0 sub_ln = sub') then (true)
	else (false)
);;

let dump_nm = "pp_";;

let rec dump_mlcf_pp (g:grammar) = 
	match g with Grammar(name,_,_,ps,_,t,_) ->
		let ofile = (open_out (name ^ "_pp.ml")) in
		let os = output_string ofile in
		let n = ref "" in
		let num_same_nonterm = ref 1 in
		os "(* auto-generated by gt *)\n\n";
		os "open ";
		os (String.capitalize name);
		os "_syntax;;\n\n";
		os "let cur_line = ref 1;;\n";
		os "let rec print_new_line (os:string->unit) (do_print:bool) (p:int) : unit =\n";
		os "\tif(p > !cur_line && do_print) then ( \n";
		os "\t\tos \"\\n\"; \n";
		os "\t\tincr cur_line;\n";
		os "\t\tprint_new_line os do_print p;\n";
		os "\t)\n";
		os ";;\n\n";
		let num = ref false in
		os "let rec dummy () = () 
and pp_terminal (os:string->unit) (to_pretty_print:bool) = function 
	(d,str1) -> print_new_line os to_pretty_print (fst d); os str1";
 

		List.iter (fun (Production(c,s,ss,ssop)) -> 
let has_ors = match ssop with None -> false | _ -> true in
let i = ref 0 in
let prods ss = 
let i' = string_of_int !i in
incr i;
			if (s <> !n) then (
				if (!num_same_nonterm > 1) then os "";
				num_same_nonterm := 1;
				n := s;
				os "\n\nand ";
				os ("pp_" ^ (symbol_var_name (s,false)));
				os " (os:string->unit) (to_pretty_print:bool) = function "
			)
			else incr num_same_nonterm; os "\n   |";



let ss' = 
			  if(starts_with "List_Left" (symbol_ctor_name c)) then 
				 let li = (numbered ss) in
				 if List.length li > 1 then (List.tl li)@(List.hd li)::[]
             else li
			  else (numbered ss) 
			in

			let var_pos = ref (svn_pos ss s) in
			let is_list = if(starts_with "List_Left" (symbol_ctor_name c) || 
				starts_with "List_Right" (symbol_ctor_name c)) then true else false in
			let is_opt = starts_with "Option" (symbol_ctor_name c) in

			let emit_pattern n = 
	let print_pattern k = 
		if(not(is_opt) && not(is_list)) then (
if(has_ors) then os ((symbol_ctor_name c)^i')
else os (symbol_ctor_name c)
);
			if(k mod 2 = 1 || k = 0) then os " (d" else os " (d'";
		

		let c' = ref 0 in 

		let first = ref true in
		List.iter (fun (s',n) ->
			let x_i =
				if (is_terminal s') then (if(is_in_ast t s') then ("str"^string_of_int n) else ("pd"^string_of_int n) )
				else (symbol_var_name s') ^ string_of_int n in
			incr c';
			if (true) then (
				if(!c' = List.length ss' && is_list) then os ")::" else os " , ";
				if(!first && (is_opt || is_list)) then (
					first := false;
					if(is_opt) then os "Some"; os "("
				);
				if(k = 0) then os x_i 
				else os (x_i^"_"^(string_of_int k))
			)
		) (ss');

		os ")"; if(List.length ss <> 0 && is_opt) then os ")"; in 

	if(List.length ss = 0 && is_opt) then ( 
		if(!num) then (os " (_,None)";) else os " (d,None)";
	)
	else if((!var_pos = 0 || List.length ss = 0) && is_list) then (
		if(!num) then (os "(_,[])";) else os " (d,[])";
	)
	else (
		print_pattern n;
	)
	in

let prettyprinter = c in
let _ = prettyprinter in 
emit_pattern 0; os " -> "; 
 if(!var_pos = 0 && is_list) then ()
else (
	List.iter (fun (x1,n) -> 
		let pp = (symbol_var_name x1) in
	let pp_i = dump_nm^(symbol_var_name x1) in
let _ = pp_i in 
let _ = pp in 
		let x_i = 
		if (is_terminal x1) then (if(is_in_ast t x1) then ("str"^string_of_int n) else ("pd"^string_of_int n))
		else (symbol_var_name x1) ^ string_of_int n in
	let is_in_ast = is_in_ast t x1 in 
	let is_terminal = is_terminal x1 in
	let string_of_terminal = if(not(is_in_ast)) then (string_of_terminal g x1) else "" in
	let is_cur_eq_first_nt = if((symbol_var_name x1) = symbol_var_name (s,false)) then true else false in


     if(is_terminal) then (
      os ("print_new_line os to_pretty_print (fst d); ");
        if(is_in_ast) then (
      os " pp_terminal os to_pretty_print "
      )
      else (
      os ("print_new_line os to_pretty_print (fst "^x_i^"); ");
      os "os ";
      os string_of_terminal
      );
     )
     else (
     os pp_i; os " os to_pretty_print "
     );

     if(is_cur_eq_first_nt && (is_list || is_opt)) then (
      os ( " (d,"^x_i^")" );
     )
     else if(not(is_terminal && not(is_in_ast))) then (
     os ( x_i );
     );
     if(is_terminal) then os "; os \" \" ";



   


os ";";
	) ss';);

 
os " () "; 
 
in

let ssop = match ssop with None -> [] | Some(x) -> x in
prods ss;
List.iter(prods) ssop;
)ps;

if (!num_same_nonterm > 1) then os "";os ";;\n";
os ("\nlet pp (os:string->unit) (to_pretty_print:bool) e = pp_" ^ symbol_var_name (get_start_symbol g) ^ " os to_pretty_print e;;");
close_out ofile;;
