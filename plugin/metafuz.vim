" ============================================================================
" File:        metafuz.vim
"
" Description: Vim global plugin that provides some extra stuff on top of
"              fuzzyfinder
"              (http://www.vim.org/scripts/script.php?script_id=1984)
"
" Maintainer:  Derek Wyatt <derek at myfirstnamemylastname dot org>
"
" Last Change: November 26 2013
"
" License:     Apache 2 (https://www.apache.org/licenses/LICENSE-2.0.html)
" ============================================================================

if exists("g:metafuz_plugin_loaded")
  finish
endif

if globpath(&rtp, 'plugin/fuf.vim') != ''
  function! metafuz#GetParentOfSourceDirectory()
    let fwd = expand('%:p:h')
    let srcparent = substitute(fwd, '/[^/]*/src/.*', '', '')
    return srcparent
  endfunction
  
  function! metafuz#GetProjectRoot(from)
    let dir = split(a:from, "/")
    let found = 0
    while found == 0 && len(dir) != 0
      let tempdir = "/" . join(dir, "/")
      if filereadable(tempdir . "/.fuf.project.root")
        return tempdir
      endif
      let dir = dir[0:-2]
    endwhile
    echoerr "Unable to locate project root (can't find .fuf.project.root file)"
    return ""
  endfunction
  
  nmap <silent> <Leader>fb :FufBuffer<cr>
  nmap <silent> <Leader>ft :FufTag<cr>
  nmap <silent> <Leader>ff :let targetFufDirectory=expand('%:p:h')<cr>:cd <c-r>=metafuz#GetProjectRoot(expand('%:p:h'))<cr><cr>:FufFile <c-r>=targetFufDirectory<cr>/**/<cr>
  nmap <silent> <Leader>fs :exec ":FufFile " . metafuz#GetParentOfSourceDirectory() . "/**/"<cr>
  nmap <silent> <Leader>fr :cd <c-r>=metafuz#GetProjectRoot(expand('%:p:h'))<cr><cr>:FufFile **/<cr>
else
  echoerr 'Something is very wrong. You install metafuz but not fuzzyfinder?'
endif
