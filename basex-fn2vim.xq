(:~
 : Helping script
 :
 : generates list of module namespaces
 : and list of functions for each module
 :
 : data is generated from BaseX documentation
 : using https://github.com/arolle/basex-docu
 :)
import module namespace C = "basex-docu-conversion-config" at "config.xqm";

(:~
 : generate "vim-array let declaration" from sequence
 : 
 : @return string as "let nm = ['a', 'b']"
 :)
declare function local:let-vimarray-from(
  $var-name as xs:string,
  $seq as xs:string*
) {
  string-join(
    $seq ! ('"' || .  || '"'),
    ", "
  ) ! ("let " || $var-name  ||" = [" || . || "]")
};


(:
 : output VimL strings
 :)
let $modules := (
  C:open-by-name($C:WIKI-DUMP-PATH || "Module%20Library")
    //*:table/*:tr/*:td[position() = 3]/data() ! normalize-space(.)
  )[string-length(.) > 0] (: remove empty :)
let $all-signatures := (: all function signatures :)
  distinct-values(C:open-by-name($C:WIKI-DUMP-PATH)//table/tr/td[position() = 2]/code/b/text())
return string-join((
  
  $modules ! ("elseif namespace =~ '" || . || "'" || out:nl()
  || out:tab() || "call map(" || . ||"_functions, '&quot;" || . || ":&quot; . v:val . &quot;(&quot;')" || out:nl() 
  || out:tab() || "let function_completions = copy(" || . ||"_functions)")
  , "",

  (: list of namespaces :)
  local:let-vimarray-from("library_modules_namespaces", $modules),
  
  (: list of functions :)
  for $x in $all-signatures
  let $parts := tokenize($x, ':'),
      $ns := $parts[1]
  group by $ns
  return
    local:let-vimarray-from($ns[1] || "_functions",
      $parts[position() mod 2 = 0] (: removes $ns[1] from $parts :)
    )
), out:nl())