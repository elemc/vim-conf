command! ElemcGoNewProject call s:go_new_project()
command! ElemcGoNewHTTPProject call s:go_new_http_project()
command! -nargs=1 ElemcGoNewSource call s:go_new_source_file(<f-args>)

function! s:go_new_project()
    call g:Elemc_vcreate_file( "" )
    call s:go_mainfile_content ()
    execute ":saveas! main.go" 

    call g:Elemc_vcreate_file( "" )
    call s:go_configfile_content ()
    execute ":saveas! config.go"
endfunction

function! s:go_new_http_project()
    call g:Elemc_vcreate_file( "" )
    call s:go_mainfile_content ()
    execute ":saveas! main.go" 

    call g:Elemc_vcreate_file( "" )
    call s:go_confighttp_content ()
    execute ":saveas! config.go"

    call g:Elemc_vcreate_file( "" )
    call s:go_httpfile_content ()
    execute ":saveas! http.go"
endfunction

function! s:go_new_source_file(packagename)
    " let filename_part = tolower(a:sourcename)
    " let s:filename_go = filename_part . ".go"
    let s:packagename_go = tolower(a:packagename)

    call g:Elemc_vcreate_file( "" )
    call s:go_new_source()
    execute ":set filetype=go"
endfunction

function s:go_header_comment ()
    let f_str = "/* ------------------------------------------------ */"
    let mid_str = g:Elemc_correct_header_string( "/* Golang source", len(f_str), "*/" )

    let header = ["// -*- Go -*-",
        \         f_str,
        \         mid_str,
        \         g:Elemc_correct_header_string("/* Author: ". g:elemc_author, len(f_str), "*/"),
        \         f_str,
        \         ""]
    return header
endfunction

function! s:go_init_function () 
    let mf = ["func init() {",
        \     "    flag.StringVar(&configName, \"config\", \"\", \"configuration file name\")",
        \     "}"]
    return mf
endfunction

function! s:go_main_function ()
    let mf = ["func main() {",
        \     "    flag.Parse()",
        \     "",
        \     "// workaround for debug config messages",
        \     "    log.SetLevel(log.DebugLevel)",
        \     "",
        \     "    if err := LoadConfig(); err != nil {",
        \     "        log.Fatalf(\"Unable to load configuration file %s: %s\", configName, err)",
        \     "    }",
        \     "    if level, err := log.ParseLevel(options.LogLevel); err != nil {",
        \     "        log.Warnf(\"Unable to parse log level %s: %s\", options.LogLevel, err)",
        \     "        log.SetLevel(log.DebugLevel)",
        \     "    } else {",
        \     "        log.SetLevel(level)",
        \     "    }",
        \     "",
        \     "    log.Warnf(\"Application started...\")",
        \     "}"]
    return mf
endfunction

function! s:go_import_section ()
    let gis = ["import (",
        \     "    \"flag\"",
        \     "     log \"github.com/Sirupsen/logrus\"",
        \     "     \"github.com/spf13/viper\"",
        \     "     \"github.com/buaazp/fasthttprouter\"",
	    \     "     \"github.com/valyala/fasthttp\"",
        \     ")"]
    return gis
endfunction

function! s:go_config_content ()
    let data = ["type Options struct {",
        \     "    LogLevel string",
        \     "}",
        \     "",
        \     "var options *Options",
        \     "",
        \     "func LoadConfig() (err error) {",
        \     "    log.Warnf(\"Load configuration file...\")",
        \     "",
        \     "    viper.SetConfigName(configName)",
        \     "    viper.AddConfigPath(\".\")",
        \     "",
        \     "    if err = viper.ReadInConfig(); err != nil {",
        \     "        return",
        \     "    }",
        \     "",
        \     "    options = &Options{",
        \     "        LogLevel: viper.GetString(\"log.level\"),",
        \     "    }",
        \     "    return",
        \     "}"]
    return data
endfunction

function! s:go_config_http_content ()
    let data = ["type Options struct {",
        \     "    LogLevel string",
        \     "    ServerAddr string",
        \     "}",
        \     "",
        \     "var options *Options",
        \     "",
        \     "func LoadConfig() (err error) {",
        \     "    log.Warnf(\"Load configuration file...\")",
        \     "",
        \     "    viper.SetConfigName(configName)",
        \     "    viper.AddConfigPath(\".\")",
        \     "",
        \     "    if err = viper.ReadInConfig(); err != nil {",
        \     "        return",
        \     "    }",
        \     "",
        \     "    options = &Options{",
        \     "        LogLevel: viper.GetString(\"log.level\"),",
        \     "        ServerAddr: viper.GetString(\"http.addr\"),",    
        \     "    }",
        \     "    return",
        \     "}"]
    return data
endfunction

function! s:go_http_content ()
    let data = ["var router = fasthttprouter.New()",
        \     "",
        \     "func httpInit() () {",
        \     "    router.GET(\"/\", httpRootHandler)",
        \     "}",
        \     "",
        \     "func httpServe() (err error) {",
        \     "    httpInit()",
        \     "    return fasthttp.ListenAndServe(options.ServerAddr, router.Handler)",    
        \     "}",
        \     "",
        \     "func httpInitHandler(ctx *fasthttp.RequestCtx) {",
	    \     "fields := make(log.Fields)",
	    \     "fields[\"Body\"] = string(ctx.PostBody())",
    	\     "fields[\"Method\"] = string(ctx.Method())",
        \     "",
	    \     "addParamToFields := func(key, value []byte) {",
		\     "fields[string(key)] = string(value)",
	    \     "}",
        \     "",
	    \     "if string(ctx.Method()) == \"POST\" {",
		\     "ctx.PostArgs().VisitAll(addParamToFields)",
	    \     "} else {",
		\     "ctx.QueryArgs().VisitAll(addParamToFields)",
	    \     "}",
        \     "",
	    \     "log.WithFields(fields).Debugf(\"Request from %s to %s\", ctx.RemoteIP().String(), ctx.URI().String())",
        \     "}",
        \     "",
        \     "func httpRootHandler(ctx *fasthttp.RequestCtx) {",
        \     "    ctx.WriteString(\"OK\")",
        \     "    ctx.SetStatusCode(fasthttp.StatusOK)",
        \     "}"]
    return data
endfunction


function! s:go_mainfile_content ()
    call append (0, s:go_header_comment())
    call append (line('$'), "package main" )
    call append (line('$'), "" )
    call append (line('$'), s:go_import_section() )
    call append (line('$'), "" )
    call append (line('$'), "var (" )
    call append (line('$'), "    configName string" )
    call append (line('$'), ")" )
    call append (line('$'), "" )
    call append (line('$'), s:go_init_function() )
    call append (line('$'), "" )
    call append (line('$'), s:go_main_function() )
endfunction

function! s:go_configfile_content ()
    call append (0, s:go_header_comment())
    call append (line('$'), "package main" )
    call append (line('$'), "" )
    call append (line('$'), s:go_import_section() )
    call append (line('$'), "" )
    call append (line('$'), s:go_config_content() )
endfunction

function! s:go_confighttp_content ()
    call append (0, s:go_header_comment())
    call append (line('$'), "package main" )
    call append (line('$'), "" )
    call append (line('$'), s:go_import_section() )
    call append (line('$'), "" )
    call append (line('$'), s:go_config_http_content() )
endfunction

function! s:go_httpfile_content ()
    call append (0, s:go_header_comment())
    call append (line('$'), "package main" )
    call append (line('$'), "" )
    call append (line('$'), s:go_import_section() )
    call append (line('$'), "" )
    call append (line('$'), s:go_http_content() )
endfunction

function! s:go_new_source ()
    call append (0, s:go_header_comment())
    call append (line('$'), "package ".s:packagename_go )
    call append (line('$'), "" )
    call append (line('$'), s:go_import_section() )
    call append (line('$'), "" )
endfunction
