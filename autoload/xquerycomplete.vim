" XQuery completion script
" Language:     XQuery
" Maintainer:   David Lam <dlam@dlam.me>
" Created:      2010 May 27
" Last Change:  2012 Oct 8
"
" Notes:
"   Completes W3C XQuery 'fn' functions, types and keywords. 
"
"   Also completes all the MarkLogic functions I could find at...
"   http://community.marklogic.com/pubs/5.0/apidocs/All.html
"
"   Updated with functx and new MarkLogic 5.0 functions by Steve Spigarelli!
"
" Usage:
"   Generally, just start by typing it's namespace and then <CTRL-x><CTRL-o>
"
"        fn<CTRL-x><CTRL-o>
"           ->  list of functions in the 'fn' namespace
"
"        fn:doc<CTRL-x><CTRL-o>
"           ->  fn:doc(
"               fn:doc-available(
"               fn:document-uri(
"
"        xs<CTRL-x><CTRL-o>
"           ->  list of all xquery types
"
"        decl<CTRL-x><CTRL-o>
"           ->  declare
"               declare function
"               declare namespace
"               declare option
"               declare default
"
"
"   :h complete-functions
"   :h omnifunc
"   :h filetype-plugin-on

 
if exists("b:did_xqueryomnicomplete")
    "finish
    delfunction xquerycomplete#CompleteXQuery
endif
let b:did_xqueryomnicomplete = 1
 
function! xquerycomplete#CompleteXQuery(findstart, base) 

  if a:findstart
	" locate the start of the word
	let line = getline('.')
	let start = col('.') - 1
	let curline = line('.')
	let compl_begin = col('.') - 2
    
    " 5/29/2010   \|  joins two regex branches!         :h pattern
	while start >= 0 && line[start - 1] =~ '\k\|:\|\-\|&'
		let start -= 1
	endwhile
	let b:compl_context = getline('.')[0:compl_begin]

	return start
  else

    
""" START INSERT BaseX specific



let library_modules_namespaces = ["admin", "archive", "bin", "client", "convert", "crypto", "csv", "db", "fetch", "file", "ft", "hash", "hof", "html", "http", "index", "inspect", "json", "map", "math", "out", "proc", "prof", "random", "repo", "sql", "stream", "unit", "validate", "xquery", "xslt", "zip", "geo", "request", "rest", "session", "sessions"]
let admin_functions = ["users", "sessions", "logs"]
let archive_functions = ["create", "entries", "options", "extract-text", "extract-binary", "update", "delete", "write"]
let bin_functions = ["hex", "bin", "octal", "to-octets", "from-octets", "length", "part", "join", "insert-before", "pad-left", "pad-right", "find", "decode-string", "encode-string", "pack-double", "pack-float", "pack-integer", "unpack-double", "unpack-float", "unpack-integer", "unpack-unsigned-integer", "or", "xor", "and", "not", "shift"]
let csv_functions = ["parse", "serialize"]
let client_functions = ["connect", "execute", "info", "query", "close"]
let convert_functions = ["binary-to-string", "string-to-base64", "string-to-hex", "bytes-to-base64", "bytes-to-hex", "binary-to-bytes", "integer-to-base", "integer-from-base", "integer-to-dateTime", "dateTime-to-integer", "integer-to-dayTime", "dayTime-to-integer"]
let crypto_functions = ["hmac", "encrypt", "decrypt", "generate-signature", "validate-signature"]
let db_functions = ["system", "info", "list", "list-details", "backups", "event", "open", "open-pre", "open-id", "node-pre", "node-id", "retrieve", "export", "text", "text-range", "attribute", "attribute-range", "create", "drop", "add", "delete", "optimize", "rename", "replace", "store", "output", "flush", "name", "path", "exists", "is-raw", "is-xml", "content-type"]
let fetch_functions = ["text", "binary", "content-type"]
let file_functions = ["list", "read-binary", "read-text", "read-text-lines", "create-dir", "create-temp-dir", "create-temp-file", "delete", "write", "write-binary", "write-text", "write-text-lines", "append", "append-binary", "append-text", "append-text-lines", "copy", "move", "exists", "is-dir", "is-file", "last-modified", "size", "base-name", "dir-name", "path-to-native", "resolve-path", "path-to-uri", "dir-separator", "path-separator", "line-separator", "temp-dir"]
let ft_functions = ["search", "contains", "mark", "extract", "count", "score", "tokens", "tokenize"]
let geo_functions = ["dimension", "geometry-type", "srid", "envelope", "as-text", "as-binary", "is-simple", "boundary", "num-geometries", "geometry-n", "length", "num-points", "area", "centroid", "point-on-surface", "equals", "disjoint", "intersects", "touches", "crosses", "within", "contains", "overlaps", "relate", "distance", "buffer", "convex-hull", "intersection", "union", "difference", "sym-difference", "x", "y", "z", "start-point", "end-point", "is-closed", "is-ring", "point-n", "exterior-ring", "num-interior-ring", "interior-ring-n"]
let html_functions = ["parser", "parse"]
let http_functions = ["send-request"]
let hash_functions = ["md5", "sha1", "sha256", "hash"]
let fn_functions = ["for-each", "filter", "for-each-pair", "fold-left", "fold-right"]
let hof_functions = ["id", "const", "fold-left1", "until", "top-k-by", "top-k-with"]
let index_functions = ["facets", "texts", "attributes", "element-names", "attribute-names"]
let inspect_functions = ["functions", "function", "context", "module", "xqdoc"]
let json_functions = ["parse", "serialize"]
let map_functions = ["collation", "contains", "entry", "get", "keys", "new", "remove", "size", "serialize"]
let math_functions = ["pi", "sqrt", "sin", "cos", "tan", "asin", "acos", "atan", "atan2", "pow", "exp", "log", "log10", "e", "sinh", "cosh", "tanh", "crc32"]
let out_functions = ["nl()", "tab()", "format"]
let proc_functions = ["system", "execute"]
let prof_functions = ["time", "mem", "sleep", "human", "dump", "current-ms", "current-ns", "void"]
let rest_functions = ["base-uri", "uri", "wadl"]
let random_functions = ["double", "integer", "seeded-double", "seeded-integer", "gaussian", "uuid"]
let repo_functions = ["install", "delete", "list"]
let request_functions = ["method", "attribute", "scheme", "hostname", "port", "path", "query", "uri", "context-path", "address", "remote-hostname", "remote-address", "remote-port", "parameter-names", "parameter", "header-names", "header", "cookie-names", "cookie"]
let sql_functions = ["init", "connect", "execute", "execute-prepared", "prepare", "commit", "rollback", "close"]
let session_functions = ["id", "created", "accessed", "names", "get", "set", "delete", "close"]
let sessions_functions = ["ids", "created", "accessed", "names", "get", "set", "delete", "close"]
let stream_functions = ["materialize", "is-streamable"]
let unit_functions = ["assert", "fail", "test", "test-uris"]
let validate_functions = ["xsd", "xsd-info", "dtd", "dtd-info"]
let xquery_functions = ["eval", "invoke", "type"]
let xslt_functions = ["processor", "version", "transform", "transform-text"]
let zip_functions = ["binary-entry", "text-entry", "xml-entry", "html-entry", "entries", "zip-file", "update-entries"]


"" END INSERT BaseX variables


    " let fnfunctions = ["{{{
    " http://community.marklogic.com/pubs/5.0/apidocs/W3C.html
    let fnfunctions = [
        \ 'abs',
        \ 'adjust-date-to-timezone',
        \ 'adjust-dateTime-to-timezone',
        \ 'adjust-time-to-timezone',
        \ 'analyze-string',
        \ 'avg',
        \ 'base-uri',
        \ 'boolean',
        \ 'ceiling',
        \ 'codepoint-equal',
        \ 'codepoints-to-string',
        \ 'collection',
        \ 'compare',
        \ 'concat',
        \ 'contains',
        \ 'count',
        \ 'current',
        \ 'current-date',
        \ 'current-dateTime',
        \ 'current-group',
        \ 'current-grouping-key',
        \ 'current-time',
        \ 'data',
        \ 'day-from-date',
        \ 'day-from-dateTime',
        \ 'days-from-duration',
        \ 'deep-equal',
        \ 'default-collation',
        \ 'distinct-nodes',
        \ 'distinct-values',
        \ 'doc',
        \ 'doc-available',
        \ 'document',
        \ 'document-uri',
        \ 'element-available',
        \ 'empty',
        \ 'encode-for-uri',
        \ 'ends-with',
        \ 'error',
        \ 'escape-html-uri',
        \ 'escape-uri',
        \ 'exactly-one',
        \ 'exists',
        \ 'expanded-QName',
        \ 'false',
        \ 'floor',
        \ 'format-date',
        \ 'format-dateTime',
        \ 'format-number',
        \ 'format-time',
        \ 'function-available',
        \ 'generate-id',
        \ 'hours-from-dateTime',
        \ 'hours-from-duration',
        \ 'hours-from-time',
        \ 'id',
        \ 'idref',
        \ 'implicit-timezone',
        \ 'in-scope-prefixes',
        \ 'index-of',
        \ 'insert-before',
        \ 'iri-to-uri',
        \ 'key',
        \ 'lang',
        \ 'last',
        \ 'local-name',
        \ 'local-name-from-QName',
        \ 'lower-case',
        \ 'matches',
        \ 'max',
        \ 'min',
        \ 'minutes-from-dateTime',
        \ 'minutes-from-duration',
        \ 'minutes-from-time',
        \ 'month-from-date',
        \ 'month-from-dateTime',
        \ 'months-from-duration',
        \ 'name',
        \ 'namespace-uri',
        \ 'namespace-uri-for-prefix',
        \ 'namespace-uri-from-QName',
        \ 'nilled',
        \ 'node-kind',
        \ 'node-name',
        \ 'normalize-space',
        \ 'normalize-unicode',
        \ 'not',
        \ 'number',
        \ 'one-or-more',
        \ 'position',
        \ 'prefix-from-QName',
        \ 'QName',
        \ 'regex-group',
        \ 'remove',
        \ 'replace',
        \ 'resolve-QName',
        \ 'resolve-uri',
        \ 'reverse',
        \ 'root',
        \ 'round',
        \ 'round-half-to-even',
        \ 'seconds-from-dateTime',
        \ 'seconds-from-duration',
        \ 'seconds-from-time',
        \ 'starts-with',
        \ 'static-base-uri',
        \ 'string',
        \ 'string-join',
        \ 'string-length',
        \ 'string-pad',
        \ 'string-to-codepoints',
        \ 'subsequence',
        \ 'substring',
        \ 'substring-after',
        \ 'substring-before',
        \ 'subtract-dateTimes-yielding-dayTimeDuration',
        \ 'subtract-dateTimes-yielding-yearMonthDuration',
        \ 'sum',
        \ 'system-property',
        \ 'timezone-from-date',
        \ 'timezone-from-dateTime',
        \ 'timezone-from-time',
        \ 'tokenize',
        \ 'trace',
        \ 'translate',
        \ 'true',
        \ 'type-available',
        \ 'unordered',
        \ 'unparsed-entity-public-id',
        \ 'unparsed-entity-uri',
        \ 'unparsed-text',
        \ 'unparsed-text-available',
        \ 'upper-case',
        \ 'year-from-date',
        \ 'year-from-dateTime',
        \ 'years-from-duration',
        \ 'zero-or-one']
      "}}}

    " let functxFunctions = ["{{{
    " http://www.xqueryfunctions.com/xq/alpha.html
    let functxFunctions = [
        \ 'add-attributes',
        \ 'add-months',
        \ 'add-or-update-attributes',
        \ 'all-whitespace',
        \ 'are-distinct-values',
        \ 'atomic-type',
        \ 'avg-empty-is-zero',
        \ 'between-exclusive',
        \ 'between-inclusive',
        \ 'camel-case-to-words',
        \ 'capitalize-first',
        \ 'change-element-names-deep',
        \ 'change-element-ns-deep',
        \ 'change-element-ns',
        \ 'chars',
        \ 'contains-any-of',
        \ 'contains-case-insensitive',
        \ 'contains-word',
        \ 'copy-attributes',
        \ 'date',
        \ 'dateTime',
        \ 'day-in-year',
        \ 'day-of-week-abbrev-en',
        \ 'day-of-week-name-en',
        \ 'day-of-week',
        \ 'dayTimeDuration',
        \ 'days-in-month',
        \ 'depth-of-node',
        \ 'distinct-attribute-names',
        \ 'distinct-deep',
        \ 'distinct-element-names',
        \ 'distinct-element-paths',
        \ 'distinct-nodes',
        \ 'duration-from-timezone',
        \ 'dynamic-path',
        \ 'escape-for-regex',
        \ 'exclusive-or',
        \ 'first-day-of-month',
        \ 'first-day-of-year',
        \ 'first-node',
        \ 'follows-not-descendant',
        \ 'format-as-title-en',
        \ 'fragment-from-uri',
        \ 'get-matches-and-non-matches',
        \ 'get-matches',
        \ 'has-element-only-content',
        \ 'has-empty-content',
        \ 'has-mixed-content',
        \ 'has-simple-content',
        \ 'id-from-element',
        \ 'id-untyped',
        \ 'if-absent',
        \ 'if-empty',
        \ 'index-of-deep-equal-node',
        \ 'index-of-match-first',
        \ 'index-of-node',
        \ 'index-of-string-first',
        \ 'index-of-string-last',
        \ 'index-of-string',
        \ 'insert-string',
        \ 'is-a-number',
        \ 'is-absolute-uri',
        \ 'is-ancestor',
        \ 'is-descendant',
        \ 'is-leap-year',
        \ 'is-node-among-descendants-deep-equal',
        \ 'is-node-among-descendants',
        \ 'is-node-in-sequence-deep-equal',
        \ 'is-node-in-sequence',
        \ 'is-value-in-sequence',
        \ 'last-day-of-month',
        \ 'last-day-of-year',
        \ 'last-node',
        \ 'leaf-elements',
        \ 'left-trim',
        \ 'line-count',
        \ 'lines',
        \ 'max-depth',
        \ 'max-determine-type',
        \ 'max-line-length',
        \ 'max-node',
        \ 'max-string',
        \ 'min-determine-type',
        \ 'min-node',
        \ 'min-non-empty-string',
        \ 'min-string',
        \ 'mmddyyyy-to-date',
        \ 'month-abbrev-en',
        \ 'month-name-en',
        \ 'name-test',
        \ 'namespaces-in-use',
        \ 'next-day',
        \ 'node-kind',
        \ 'non-distinct-values',
        \ 'number-of-matches',
        \ 'open-ref-document',
        \ 'ordinal-number-en',
        \ 'pad-integer-to-length',
        \ 'pad-string-to-length',
        \ 'path-to-node-with-pos',
        \ 'path-to-node',
        \ 'precedes-not-ancestor',
        \ 'previous-day',
        \ 'remove-attributes-deep',
        \ 'remove-attributes',
        \ 'remove-elements-deep',
        \ 'remove-elements-not-contents',
        \ 'remove-elements',
        \ 'repeat-string',
        \ 'replace-beginning',
        \ 'replace-element-values',
        \ 'replace-first',
        \ 'replace-multi',
        \ 'reverse-string',
        \ 'right-trim',
        \ 'scheme-from-uri',
        \ 'sequence-deep-equal',
        \ 'sequence-node-equal-any-order',
        \ 'sequence-node-equal',
        \ 'sequence-type',
        \ 'siblings-same-name',
        \ 'siblings',
        \ 'sort-as-numeric',
        \ 'sort-case-insensitive',
        \ 'sort-document-order',
        \ 'sort',
        \ 'substring-after-if-contains',
        \ 'substring-after-last-match',
        \ 'substring-after-last',
        \ 'substring-after-match',
        \ 'substring-before-if-contains',
        \ 'substring-before-last-match',
        \ 'substring-before-last',
        \ 'substring-before-match',
        \ 'time',
        \ 'timezone-from-duration',
        \ 'total-days-from-duration',
        \ 'total-hours-from-duration',
        \ 'total-minutes-from-duration',
        \ 'total-months-from-duration',
        \ 'total-seconds-from-duration',
        \ 'total-years-from-duration',
        \ 'trim',
        \ 'update-attributes',
        \ 'value-except',
        \ 'value-intersect',
        \ 'value-union',
        \ 'word-count',
        \ 'words-to-camel-case',
        \ 'wrap-values-in-elements',
        \ 'yearMonthDuration']
    "}}}

    " 8/6/2010  Putting variable types here 

    "  see Walmsley:490  in index!
    "  atomicType chart?   Walmsley:144
    "  generic sequence types?  Walmsley:152
    "
    "    wat about.... 
    "       comment()
    "       processing-instruction()
    "       document-node()
    "
    " let generic_types = ["{{{
    let generic_types = [
        \ 'item()', 
        \ 'node()',
        \ 'text()',
        \ 'empty-sequence()',
        \ 'element()', 
        \ 'document()'
        \ ]
    "}}}

    " these are prefixed with xs:  
    " let atomic_types = ["{{{
    let atomic_types = [
        \ 'xs:string',
        \ 'xs:dateTime',
        \ 'xs:anyAtomicType',
        \ 'xs:anyType',
        \ 'xs:anyURI',
        \ 'xs:base64Binary',
        \ 'xs:boolean',
        \ 'xs:date',
        \ 'xs:dayTimeDuration',
        \ 'xs:decimal',
        \ 'xs:double',
        \ 'xs:duration',
        \ 'xs:float',
        \ 'xs:gDay',
        \ 'xs:gMonth',
        \ 'xs:gMonthDay',
        \ 'xs:gYearMonth',
        \ 'xs:gYear',
        \ 'xs:hexBinary',
        \ 'xs:integer',
        \ 'xs:negativeInteger',
        \ 'xs:nonPositiveInteger',
        \ 'xs:nonNegativeInteger',
        \ 'xs:normalizedString',
        \ 'xs:positiveInteger',
        \ 'xs:time',
        \ 'xs:QName',
        \ 'xs:unsignedByte',
        \ 'xs:unsignedInt',
        \ 'xs:unsignedLong',
        \ 'xs:unsignedShort',
        \ 'xs:yearMonthDuration'
        \ ]
    "}}}

    let all_types = generic_types + atomic_types


    
    " From spec: 'Certain namespace prefixes are predeclared by XQuery and
    " bound to fixed namespace URIs. These namespace prefixes are as follows:'
    let predeclared_namespaces = ['fn', 'xs', 'local', 'xsi', 'xml']

    let ALL_FUNCTION_NAMESPACES = 
        \ library_modules_namespaces +
        \ ["functx"] +
        \ predeclared_namespaces

    "  When completing a namespace, the user will almost 
    "  always want the colon after it too!
    "
    "   --> see javascriptcomplete.vim:583
    "
	call map(ALL_FUNCTION_NAMESPACES, 'v:val.":"')

    let namespace            = a:base
    let function_completions = []
    let final_menu           = []

    if namespace =~ 'functx'
      call map(functxFunctions, '"functx:" . v:val . "("')
      let function_completions = copy(functxFunctions)
    elseif namespace =~ 'fn'
      call map(fnfunctions, '"fn:" . v:val . "("')
      let function_completions = copy(fnfunctions)
    elseif namespace =~ 'xs'
      let function_completions = atomic_types

""" start insert from *.xq BaseX 
   


elseif namespace =~ 'admin'
	call map(admin_functions, '"admin:" . v:val . "("')
	let function_completions = copy(admin_functions)
elseif namespace =~ 'archive'
	call map(archive_functions, '"archive:" . v:val . "("')
	let function_completions = copy(archive_functions)
elseif namespace =~ 'bin'
	call map(bin_functions, '"bin:" . v:val . "("')
	let function_completions = copy(bin_functions)
elseif namespace =~ 'client'
	call map(client_functions, '"client:" . v:val . "("')
	let function_completions = copy(client_functions)
elseif namespace =~ 'convert'
	call map(convert_functions, '"convert:" . v:val . "("')
	let function_completions = copy(convert_functions)
elseif namespace =~ 'crypto'
	call map(crypto_functions, '"crypto:" . v:val . "("')
	let function_completions = copy(crypto_functions)
elseif namespace =~ 'csv'
	call map(csv_functions, '"csv:" . v:val . "("')
	let function_completions = copy(csv_functions)
elseif namespace =~ 'db'
	call map(db_functions, '"db:" . v:val . "("')
	let function_completions = copy(db_functions)
elseif namespace =~ 'fetch'
	call map(fetch_functions, '"fetch:" . v:val . "("')
	let function_completions = copy(fetch_functions)
elseif namespace =~ 'file'
	call map(file_functions, '"file:" . v:val . "("')
	let function_completions = copy(file_functions)
elseif namespace =~ 'ft'
	call map(ft_functions, '"ft:" . v:val . "("')
	let function_completions = copy(ft_functions)
elseif namespace =~ 'hash'
	call map(hash_functions, '"hash:" . v:val . "("')
	let function_completions = copy(hash_functions)
elseif namespace =~ 'hof'
	call map(hof_functions, '"hof:" . v:val . "("')
	let function_completions = copy(hof_functions)
elseif namespace =~ 'html'
	call map(html_functions, '"html:" . v:val . "("')
	let function_completions = copy(html_functions)
elseif namespace =~ 'http'
	call map(http_functions, '"http:" . v:val . "("')
	let function_completions = copy(http_functions)
elseif namespace =~ 'index'
	call map(index_functions, '"index:" . v:val . "("')
	let function_completions = copy(index_functions)
elseif namespace =~ 'inspect'
	call map(inspect_functions, '"inspect:" . v:val . "("')
	let function_completions = copy(inspect_functions)
elseif namespace =~ 'json'
	call map(json_functions, '"json:" . v:val . "("')
	let function_completions = copy(json_functions)
elseif namespace =~ 'map'
	call map(map_functions, '"map:" . v:val . "("')
	let function_completions = copy(map_functions)
elseif namespace =~ 'math'
	call map(math_functions, '"math:" . v:val . "("')
	let function_completions = copy(math_functions)
elseif namespace =~ 'out'
	call map(out_functions, '"out:" . v:val . "("')
	let function_completions = copy(out_functions)
elseif namespace =~ 'proc'
	call map(proc_functions, '"proc:" . v:val . "("')
	let function_completions = copy(proc_functions)
elseif namespace =~ 'prof'
	call map(prof_functions, '"prof:" . v:val . "("')
	let function_completions = copy(prof_functions)
elseif namespace =~ 'random'
	call map(random_functions, '"random:" . v:val . "("')
	let function_completions = copy(random_functions)
elseif namespace =~ 'repo'
	call map(repo_functions, '"repo:" . v:val . "("')
	let function_completions = copy(repo_functions)
elseif namespace =~ 'sql'
	call map(sql_functions, '"sql:" . v:val . "("')
	let function_completions = copy(sql_functions)
elseif namespace =~ 'stream'
	call map(stream_functions, '"stream:" . v:val . "("')
	let function_completions = copy(stream_functions)
elseif namespace =~ 'unit'
	call map(unit_functions, '"unit:" . v:val . "("')
	let function_completions = copy(unit_functions)
elseif namespace =~ 'validate'
	call map(validate_functions, '"validate:" . v:val . "("')
	let function_completions = copy(validate_functions)
elseif namespace =~ 'xquery'
	call map(xquery_functions, '"xquery:" . v:val . "("')
	let function_completions = copy(xquery_functions)
elseif namespace =~ 'xslt'
	call map(xslt_functions, '"xslt:" . v:val . "("')
	let function_completions = copy(xslt_functions)
elseif namespace =~ 'zip'
	call map(zip_functions, '"zip:" . v:val . "("')
	let function_completions = copy(zip_functions)
elseif namespace =~ 'geo'
	call map(geo_functions, '"geo:" . v:val . "("')
	let function_completions = copy(geo_functions)
elseif namespace =~ 'request'
	call map(request_functions, '"request:" . v:val . "("')
	let function_completions = copy(request_functions)
elseif namespace =~ 'rest'
	call map(rest_functions, '"rest:" . v:val . "("')
	let function_completions = copy(rest_functions)
elseif namespace =~ 'session'
	call map(session_functions, '"session:" . v:val . "("')
	let function_completions = copy(session_functions)
elseif namespace =~ 'sessions'
	call map(sessions_functions, '"sessions:" . v:val . "("')
	let function_completions = copy(sessions_functions)



""" end insert from *.xq BaseX
    endif


    " see Walmsley p. 27 'Categories of Expressions'

    "let keywords = ["{{{
    let keywords = [
        \ "for", 
        \ "let", 
        \ "where", 
        \ "group by",
        \ "order by", 
        \ "return", 
        \ "some", 
        \ "every", 
        \ "in", 
        \ "satisfies", 
        \ "to", 
        \ "union", 
        \ "intersect", 
        \ "except", 
        \ "instance of", 
        \ "typeswitch", 
        \ "cast as", 
        \ "castable as", 
        \ "treat", 
        \ 'variable',
        \ "validate", 
        \ "div", 
        \ "idiv", 
        \ "mod", 
        \ "xquery version \"1.0-ml\";",
        \ "xquery version \"0.9-ml\";",
        \ "xquery version \"1.0\";",
        \ "xquery version \"3.0\";",
        \ "xquery version"
        \ ]
    "}}}
    
    "  hmmm above ^ dont have everything 
    
    " let morekeywords = ["{{{
    let morekeywords = [
        \ 'as',
        \ 'declare',
        \ 'declare function',
        \ 'declare variable',
        \ 'declare namespace',
        \ 'declare option',
        \ 'declare default',
        \ 'default',
        \ 'option',
        \ 'collation',
        \ 'element',
        \ 'attribute',
        \ 'function',
        \ 'import',
        \ 'import module',
        \ 'import module namespace',
        \ 'import schema',
        \ 'module',
        \ 'namespace',
        \ 'module namespace',
        \ 'external;',
        \ 'encoding;',
        \ 'ascending',
        \ 'descending',
        \ ]
    "}}}

    " let evenmorekeywords = ["{{{
    let evenmorekeywords = [
        \ 'else',
        \ 'else if',
        \ 'then',
        \ 'if'
        \ ]
    "}}}

    "  let predefined_entity_references = ["{{{
    "  http://www.w3.org/TR/xquery/#dt-predefined-entity-reference
    let predefined_entity_references = [
        \ '&amp;',
        \ '&lt;',
        \ '&gt;',
        \ '&quot;',
        \ '&apos;'
        \ ]
    "}}}


    if(a:base =~ '&$')
        "...the character right before the cursor is an ampersand"
        return predefined_entity_references
    else 
        let res  = []
        let res2 = []
        let values = evenmorekeywords + keywords + morekeywords + function_completions + ALL_FUNCTION_NAMESPACES + generic_types + predefined_entity_references

        for v in values
            if v =~? '^'.a:base
                call add(res, v)
            elseif v =~? a:base
                call add(res2, v)
            endif
        endfor

        let final_menu = res + res2
        return final_menu
    endif

  endif
endfunction 


" vim:sw=4 fdm=marker tw=80
