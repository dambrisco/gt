(* auto-generated by gt *)
open Mlcf_syntax;;
open Grammar;;
open Trie;;

let string_index str1 c =
  try Some(String.index str1 c)
  with Not_found -> None;;

let starts_with sub st = 
	let sub_ln = String.length sub in
	if(sub_ln > String.length st) then (false)
	else (
		if(String.sub st 0 sub_ln = sub) then (true)
		else (false)	
	);;


(* This function will take in a char and a string and
	will split the string every time it sees the given
	character. *) 
let split sep str1 =
	let rec aux acc str1 =
		match string_index str1 sep with
			| Some i ->
					let this = String.sub str1 0 i
			  	and next = String.sub str1 (i+1) (String.length str1 - i - 1) in
			  	aux (this::acc) next
			| None ->
					List.rev(str1::acc) in
  aux [] str1;;

(* Replaces the tabs w/ a space. This will
	be useful when we want to split a string 
	everytime a space is seen. *)
let replace_tabs_nls str1 = 
	let j = ref 0 in
	String.iter(fun c -> 
		if(c = '\t') then (String.set str1 !j ' ');
		incr j;
	) str1; str1;;

let rec get_start_sym p =
	match p with
		None -> ""
		| Some(x) ->
			match x with
  				| Program (_,str1,_,_,_,_) -> str1;;

let rec string_contains sub st b =
	let ln_st = String.length st in
	let ln_sub = String.length sub in

	if(ln_st <= ln_sub) then false
	else if((String.sub st 0 ln_sub) = sub && (String.sub st 1 1) <> "_") then true
	else (string_contains sub (String.sub st 1 (ln_st-1)) false)
;;

let contains sub st = 
	string_contains sub st false
;;

(* This will be called in the mlcf_main file. This function
	takes in the mlcf file that the user inputed - parsed - 
	and turns it into the corresponding ocaml function. *)
let begin_dump parsed = 
	match parsed with
	  None -> ()
	| Some(x) -> Mlcf_pp.pp x;

	print_string "\n";

	let end_of_match = ref "" in
	let x1 = ref "" in
	let counter = ref "" in
	let sep_by = ref "" in
	let constructor = ref "" in 
	let o = open_out("dump_mlcf_"^(get_start_sym parsed)^".ml") in
	let os s = output_string o s in

	let rec pp_body = function 
	  | BodyOcaml (_ , str1) -> 
			List.iter(fun s -> 
				if(s = "{{" || s = "}}") then (os "\n")
				else (os s; os " ")
			) (split ' ' (replace_tabs_nls str1)); ()
	  | BodyMeta (_ , str1 , str2 , str3) -> 
			List.iter(fun s -> 
				if(s = "~|" || s = "\n") then (os "\n")
				else (counter := !counter^s)
			) (split ' ' (replace_tabs_nls str2)); 

			os "if(!var_pos = 0 && is_list) then ()\n";
			os "else (\n";
			os ("\tList.iter (fun ("^(!x1)^",n) -> \n\t");
			os ("\tlet "^(get_start_sym parsed)^" = (symbol_var_name "^(!x1)^") in\n");
			os ("\tlet "^(get_start_sym parsed)^"_"^ (!counter)^" = dump_nm^(symbol_var_name "^(!x1)^") in\n");
			os ("let _ = "^(get_start_sym parsed)^"_"^(!counter)^" in \n");
			os ("let _ = "^(get_start_sym parsed)^" in \n");
			os ("\t\tlet "^Char.escaped (!x1.[0])^"_"^(!counter)^
					 " = \n\t\tif (is_terminal "^(!x1));
			os (") then (if(is_in_ast t "^(!x1)^") then (\"str\"^string_of_int n)"
				 ^" else (\"pd\"^string_of_int n))\n\t\telse (symbol_var_name "
				 ^(!x1)^") ^ string_of_int n in\n");
			if(contains "is_in_ast" str1) then 
				os ("\tlet is_in_ast = is_in_ast t "^(!x1)^" in \n");
			if(contains "is_terminal" str1) then 
				os ("\tlet is_terminal = is_terminal "^(!x1)^" in\n");
			if(contains "string_of_terminal" str1) then 
				os ("\tlet string_of_terminal = if(not(is_in_ast)) "
					 ^"then (string_of_terminal g "^(!x1)^") else \"\" in\n");
			if(contains "is_cur_eq_first_nt" str1) then 
				os ("\tlet is_cur_eq_first_nt = if((symbol_var_name "^(!x1)
					 ^") = symbol_var_name (s,false)) then true else false in\n");
			if(contains "is_cur_eq_first_terminal" str1) then
				os ("let is_cur_eq_first_terminal = if("^(!x1)
					 ^" = (s,true)) then true else false in\n\n");

			List.iter(fun s -> 
				if(s = "(~" || s = "~|") then (os "\n")
				else (os s; os " ")
			) (split ' ' (replace_tabs_nls str1)); 

			List.iter(fun s -> 
				if(s = "~|" || s = "~)" || s = "\n") then (os "\n")
				else (sep_by := !sep_by^s)
			) (split ' ' (replace_tabs_nls str3)); 

			os "os \""; os (!sep_by); 
			os "\";\n\t) ss';);\n\n";

	and pp_constructor = function 
	  | Constructor (_ , str1 , str3 , str5 , str9) -> constructor := str1; x1 := str5; ()

	and pp_program = function 
	  | Program (_ , str1 , program_program_endofeachmatch32 , program_program_ocamlglobal35 , constructor6 , program_program_body47) -> 
			pp_program_program_endofeachmatch3 program_program_endofeachmatch32 ;
			os "open Grammar;;\nopen Trie;;\n\n";
			os "let os s = print_string s;;\n\n";
			os "let starts_with sub st = ";
			os "\n\tlet sub_ln = String.length sub in";
			os "\n\tif(sub_ln > String.length st) then (false)";
			os "\n\telse (";
			os "\n\t\tif(String.sub st 0 sub_ln = sub) then (true)";
			os "\n\t\telse (false)	";
			os "\n\t);;";
			os "\n\nlet symbol_var_name (s,b) = s;;\n\n";
			os "let symbol_ctor_name (s:string) = s;;\n\n";
			os "let numbered xs =\n\t	let n = ref 0 in\n\t";
			os "List.map (fun x -> n := !n+1; (x,!n)) xs;;\n\n";
			os "let starts_with_nonterminal ss = \n\tmatch ss with\n\t\t[]";
			os " -> false\n\t\t| s::ss' -> (not (is_terminal s));;\n\n";
			os "let svn_pos ss s = \n\tlet n = ref 0 in \n\tlet n'";
			os " = ref 0 in \n	if(not(starts_with_nonterminal ss)) ";
			os "then (incr n);\n\tList.iter(fun s' ->\n";
			os "\t\tincr n;\n\t\tif((symbol_var_name s') = ";
			os "symbol_var_name (s,false)) then (n' := !n);\n\t) ss; !n';;\n\n";
			os "let starts_with sub' st = \n\tlet sub_ln = ";
			os "String.length sub' in\n\tif(sub_ln > String.length st) ";
			os "then (false)\n\telse (\n\t\tif(String.sub st 0 ";
			os "sub_ln = sub') then (true)\n\telse (false)\n);;";
			os ("\n\nlet dump_nm = \""^str1^"_\";;\n\n");
			os ("let rec dump_mlcf_"^str1^" (g:grammar) = \n");
			os "\tmatch g with Grammar(name,_,_,ps,_,t,_) ->\n";
			os ("\t\tlet ofile = (open_out (name ^ \"_"^(str1)^".ml\")) in\n");
			os "\t\tlet os = output_string ofile in\n";
			os "\t\tlet n = ref \"\" in\n";
			os "\t\tlet num_same_nonterm = ref 1 in\n";
			os "\t\tos \"(* auto-generated by gt *)\\n\\n\";\n";
			os "\t\tos \"open \";\n";
			os "\t\tos (String.capitalize name);\n";
			os "\t\tos \"_syntax;;\\n\\n\";\n";

			os "\t\tos \"let cur_line = ref 1;;\\n\";\n";
			os "\t\tos \"let rec print_new_line (os:string->unit) ";
			os "(do_print:bool) (p:int) : unit =\\n\";\n";
			os "\t\tos \"\\tif(p > !cur_line && do_print) then ( \\n\";\n";
			os "\t\tos \"\\t\\tos \\\"\\\\n\\\"; \\n\";\n";
			os "\t\tos \"\\t\\tincr cur_line;\\n\";\n";
			os "\t\tos \"\\t\\tprint_new_line os do_print p;\\n\";\n";
			os "\t\tos \"\\t)\\n\";\n";
			os "\t\tos \";;\\n\\n\";\n";
			

			if(str1 = "eq") then (os "\t\tlet num = ref true in\n")
			else (os "\t\tlet num = ref false in\n");

			os "\t\tos \"let rec dummy () = () \nand ";
			os "pp_terminal (os:string->unit) (to_pretty_print:bool) =";
			os " function \n\t(d,str1) -> print_new_line os to_pretty_print ";
			os "(fst d); os str1\";\n";
			pp_program_program_ocamlglobal3 program_program_ocamlglobal35 ; os " ";
			os "\n\n\t\tList.iter (fun (Production(c,s,ss,ssop)) -> \n";
			os "let has_ors = match ssop with None -> false | _ -> true in\n";
			os "let i = ref 0 in\nlet prods ss = \nlet i' = string_of_int !i in\n";
			os "incr i;\n";
			os ("\t\t\tif (s <> !n) then (\n\t\t\t\tif (!num_same_nonterm > 1) then os "^
					 (!end_of_match));
			os ";\n\t\t\t\tnum_same_nonterm := 1;";
			os	("\n\t\t\t\tn := s;\n\t\t\t\tos \"\\n\\nand \";\n\t\t\t\tos (\""^(str1));
			if(starts_with "pp" str1) then (
			  os "_\" ^ (symbol_var_name (s,false)));\n\t\t\t\tos \" ";
			  os"(os:string->unit) (to_pretty_print:bool) = function \"";
			)
			else (
				os "_\" ^ (symbol_var_name (s,false)));\n\t\t\t\tos \" = function\"";
			);
			os "\n\t\t\t)\n\t\t\telse incr num_same_nonterm; os \"\\n   |\";\n\n";


			os "\n\nlet ss' = 
			  if(starts_with \"List_Left\" (symbol_ctor_name c)) then 
				 let li = (numbered ss) in
				 if List.length li > 1 then (List.tl li)@(List.hd li)::[]
             else li
			  else (numbered ss) 
			in\n\n";


			os "\t\t\tlet var_pos = ref (svn_pos ss s) in\n";
			os "\t\t\tlet is_list = if(starts_with \"List_Left\" (symbol_ctor_name c) ";
			os "|| \n\t\t\t\tstarts_with \"";
			os "List_Right\" (symbol_ctor_name c)) then true else false in\n";
			os "\t\t\tlet is_opt = starts_with \"Option\" (symbol_ctor_name c) in\n\n"; 
			os "\t\t\tlet emit_pattern n = ";
			os	"\n\tlet print_pattern k = ";
			os	"\n\t\tif(not(is_opt) && not(is_list)) then (\n";
			os "if(has_ors) then os ((symbol_ctor_name c)^i')\n";
			os "else os (symbol_ctor_name c)\n);";
			os	"\n\t\t\tif(k mod 2 = 1 || k = 0) then os \" (d\" else os \" (d'\";";
			os	"\n\t\t\n\n\t\tlet c' = ref 0 in ";



			os	"\n\n\t\tlet first = ref true in\n\t\tList.iter (fun (s',n) ->";
			os	"\n\t\t\tlet x_i =\n\t\t\t\tif (is_terminal s') then (if(is_in_ast t s') ";
			os "then (\"str\"^string_of_int n) else (\"pd\"^string_of_int n) )";
			os	"\n\t\t\t\telse (symbol_var_name s') ^ string_of_int n in";
			os	"\n\t\t\tincr c';\n\t\t\tif (true) then (";
			os	"\n\t\t\t\tif(!c' = List.length ss' && is_list) then os \")::\" ";
			os "else os \" , \";";
			os	"\n\t\t\t\tif(!first && (is_opt || is_list)) then (";
			os	"\n\t\t\t\t\tfirst := false;\n\t\t\t\t\tif(is_opt) then os \"Some\"; ";
			os "os \"(\"";
			os	"\n\t\t\t\t);\n\t\t\t\tif(k = 0) then os x_i ";
			os	"\n\t\t\t\telse os (x_i^\"_\"^(string_of_int k))\n\t\t\t)\n\t\t) (ss');";
			os	"\n\n\t\tos \")\"; if(List.length ss <> 0 && is_opt) ";
			os "then os \")\"; in ";
			os	"\n\n\tif(List.length ss = 0 && is_opt) then ( ";
			os	"\n\t\tif(!num) then (os \" (_,None)\";) else os \" (d,None)\";\n\t)";
			os	"\n\telse if((!var_pos = 0 || List.length ss = 0) && is_list) then (";
			os	"\n\t\tif(!num) then (os \"(_,[])\";) else os \" (d,[])\";\n\t)";
			os	"\n\telse (\n\t\tprint_pattern n;\n\t)\n\tin\n";
			pp_constructor constructor6 ;
			os ("\nlet "^(String.lowercase !constructor)^" = c in");
			os ("\nlet _ = "^(String.lowercase !constructor)^" in");
		 	os " "; pp_program_program_body4 program_program_body47 ; ()

	and pp_program_program_body4 = function 
	  | (d,[]) -> ()
	  |  (d , (body1)::program_program_body42) -> 
			pp_body body1 ; os " "; 
			pp_program_program_body4 ( d , program_program_body42 ) ; ()
	and pp_program_program_ocamlglobal3 = function 
	  | (d , Some(str1)) ->		
			List.iter(fun s -> 
				if(s = "{{" || s = "}}") then (
					os "\n"
				)
				else (os s; os " ")
			) (split ' ' (replace_tabs_nls str1));  ()
	  | (d,None) -> ()
	and pp_program_program_endofeachmatch3 = function 
	  |  (d , Some(str3)) -> end_of_match := str3; ()
	  | (d,None) -> end_of_match := "\"\""; () in

	match parsed with
	  None -> ()
	| Some(x) -> pp_program x;
	  os "\nin\n\nlet ssop = match ssop with None -> [] | Some(x) -> x in\nprods ss;";
	  os "\nList.iter(prods) ssop;";
	  os "\n)ps;\n\n";
	  os ("if (!num_same_nonterm > 1) then os "^(!end_of_match)^";");
	  os "os \";;\\n\";\n";
	  if(starts_with "pp" (get_start_sym parsed)) then (
		 os ("os (\"\\nlet "^(get_start_sym parsed)^
				 " (os:string->unit) (to_pretty_print:bool) e = "^
				 (get_start_sym parsed)^
				 "_\" ^ symbol_var_name (get_start_symbol g) ^ \""^
				 " os to_pretty_print e;;\");\n");
	  )
	  else (
		os ("os (\"\\nlet "^(get_start_sym parsed)^" e = "
			 ^(get_start_sym parsed)^
				"_\" ^ symbol_var_name (get_start_symbol g) ^ \" e;;\");\n");
	  );
	  os "close_out ofile;;\n";;
