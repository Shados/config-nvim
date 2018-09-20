scriptencoding "utf-8"
" Early-load settings {{{
  let mapleader = "\<Space>"
  " Define my autocmd group for later use
  augroup sn
    " Clear any existing autocmds (e.g. if re-sourcing init.vim)
    autocmd!
  augroup END


  " Customize vim-workspace colours based on gruvbox colours
  function g:WorkspaceSetCustomColors()
    highlight WorkspaceBufferCurrentDefault guibg=#a89984 guifg=#282828
    highlight WorkspaceBufferActiveDefault guibg=#504945 guifg=#a89984
    highlight WorkspaceBufferHiddenDefault guibg=#3c3836 guifg=#a89984
    highlight WorkspaceBufferTruncDefault guibg=#3c3836 guifg=#b16286
    highlight WorkspaceTabCurrentDefault guibg=#689d6a guifg=#282828
    highlight WorkspaceTabHiddenDefault guibg=#458588 guifg=#282828
    highlight WorkspaceFillDefault guibg=#3c3836 guifg=#3c3836
    highlight WorkspaceIconDefault guibg=#3c3836 guifg=#3c3836
  endfunction
" }}}

" Plugin functions ================================== {{{
  function! PlugUpdateRemote(info)
    if a:info.status !=# 'unchanged' || a:info.force
      UpdateRemotePlugins
    endif
  endfunction
  function! PlugUpdateRustRemote(info)
    if a:info.status !=# 'unchanged' || a:info.force
      !cargo build --release
      PlugUpdateRemote(info)
    endif
  endfunction
" }}}

" Plugins =========================================== {{{
  " Load locally-managed plugins
  set runtimepath+=~/.config/nvim/local/*

  " We're using vim-plug for plugin management, as async updates and flexible
  " hooks are both very useful
  call plug#begin('~/.config/nvim/plugged')
  " Appearance & UI
    Plug 'ap/vim-css-color'
    Plug 'skwp/vim-colors-solarized'
    Plug 'morhetz/gruvbox'
    Plug 'itchyny/lightline.vim'
    Plug 'haya14busa/incsearch.vim' " Incremental highlight on incsearch, including of partial regex matches
    Plug 'Yggdroot/indentLine' " Visual display of indent levels
    " Plug 'Shougo/echodoc.vim' " Displays function signatures from completions in the command line

  " Language support and syntax highlighting
    Plug 'w0rp/ale' " Async linting
    Plug 'keith/tmux.vim'
    Plug 'othree/yajs.vim' | Plug 'othree/javascript-libraries-syntax.vim'
    Plug 'gabrielelana/vim-markdown'
    Plug 'LnL7/vim-nix' " Nix syntax highlighting, error checking/linting is handled by ALE
    Plug 'Matt-Deacalion/vim-systemd-syntax'
    Plug 'vim-erlang/vim-erlang-runtime' | Plug 'vim-erlang/vim-erlang-compiler' | Plug 'vim-erlang/vim-erlang-omnicomplete' | Plug 'vim-erlang/vim-erlang-tags'
    Plug 'elixir-lang/vim-elixir'
    Plug 'avdgaag/vim-phoenix'
    Plug 'rust-lang/rust.vim'
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'ElmCast/elm-vim'
    Plug 'saltstack/salt-vim'
    Plug 'elzr/vim-json' " Notably, let's you fold on json dict/lists
    Plug 'dag/vim-fish', { 'for': 'fish' }
    Plug 'prabirshrestha/async.vim' | Plug 'prabirshrestha/vim-lsp' " Language Server Protocol client, for (the good subset of) IDE features, in pure vimL

  " Text/code creation & refactoring
    Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets' " Code snippets, the mighty slayer of boilerplate
    Plug 'tpope/vim-endwise' " Automatic closing of control flow blocks for most languages, eg. `end` inserted after `if` in Ruby
    Plug 'Raimondi/delimitMate' " Automatic context-sensitive closing of quotes, parenthesis, brackets, etc. and related features
    Plug 'sbdchd/neoformat' " Code cleanup, linting, and formatting
    Plug 'prabirshrestha/asyncomplete.vim' " Asynchronous vimL-native autocompletion

    " Completion sources
      Plug 'prabirshrestha/asyncomplete-buffer.vim'
      if !executable('clangd') && executable('ctags')
        Plug 'ludovicchabant/vim-gutentags' | Plug 'prabirshrestha/asyncomplete-tags.vim'
      endif
      Plug 'prabirshrestha/asyncomplete-file.vim'
      if !executable('rls') && executable('racer')
        Plug 'keremc/asyncomplete-racer.vim' " Provides Rust completions, but only if no RLS language server
      endif
      Plug 'prabirshrestha/asyncomplete-lsp.vim'
      Plug 'prabirshrestha/asyncomplete-neosnippet.vim'

  " Project management
    Plug 'bagrat/vim-workspace' " Statusline with buffers and tabs listed very cleanly
    Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
    Plug 'Shougo/denite.nvim', {'do': function('PlugUpdateRemote')} | Plug 'Shougo/neomru.vim' " Full path fuzzy file/buffer/mru/tag/.../arbitrary list search, bound to <leader>f (for find?)
    Plug 'vim-scripts/TaskList.vim' " Display FIXME/TODO/etc. in handy browseable list pane, bound to <Leader>t, then q to cancel, e to quit browsing but leave tasklist up, <CR> to quit and place cursor on selected task
    Plug 'xolox/vim-misc' | Plug 'Shados/vim-session', {'branch': 'shados-local'} " Extended session management, auto-save/load
    Plug 'majutsushi/tagbar' " Builds and displays a list of tags (functions, variables, etc.) for the current file, in a sidebar

  " Textobjects
    Plug 'wellle/targets.vim' " Upgrades many of vim's inbuilt textobjects and adds some very useful new ones, like a, and i, for working with comma-separated lists
    Plug 'michaeljsmith/vim-indent-object' " al for indent + start/close lines, ai for indent + start line, ii for inside-indent
    Plug 'coderifous/textobj-word-column.vim' " code-column textobject, adds ic, ac, iC and aC for working with columns, a/inner column based on word/WORD
    Plug 'kana/vim-textobj-user' | Plug 'lucapette/vim-textobj-underscore' " a_ and i_ for editing the middle of lines like foo_bar_baz, a_ includes the _'s
    Plug 'vim-scripts/argtextobj.vim' " aa = an argument, ia = inner argument, aa covers matching commas and whitespace
    " TODO: function-based textobject

  " General Extra Functionality
    Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim' " Post and edit gists directly from vim
    Plug 'skwp/vim-html-escape' " Escape text in html doc with \he, \hu to unescape
    Plug 'vim-scripts/SyntaxRange' " Set start/end tags to alter syntax highlighting between them to another type - see ~/.config/nvim/after/syntax/* files for existing tags
    " management, very cool
    Plug 'easymotion/vim-easymotion'
    Plug 'AndrewRadev/splitjoin.vim' " Allows for splitting/joining code into/from multi-line formats, gS and gJ bydefault
    Plug 'terryma/vim-multiple-cursors' " SublimeText-style multiple cursor impl., ctrl-n to start matching on current word to place
    Plug 'tomtom/tcomment_vim' " Toggle commenting of lines with gc{motion}, also works in visual mode
    Plug 'sjl/gundo.vim' " Allows you to visualize your undo tree in a pane opened with :GundoToggle
    Plug 'bogado/file-line' " Allows doing `vim filename:lineno`
    Plug 'vim-scripts/camelcasemotion' " ,w ,b and ,e alternate motions that support traversing CamelCase and underscore_notation
    Plug 'tpope/vim-surround' " Primarily useful for surrounding existing lines in new delimiters, quotation marks, xml tags, etc., or removing or modifying said 'surroundings'. <operation>s<surrounding-type> is most-used
    Plug 'tpope/vim-repeat' " Plugin-hookable `.`-replacement, user-transparent
    Plug 'chrisbra/SudoEdit.vim' " Lets you do `:SudoWrite`/`:SudoRead`, and also launch vim with `nvim sudo:/etc/fstab`, all of which are nicer+shorter than directly using the tee trick
    Plug 'goldfeld/ctrlr.vim' " Reverse search ex command history ala Bash ctrl-r
    Plug 'mhinz/vim-startify' " A fancy start screen for vim (mainly for bookmarks and session listing)
    Plug 'tyru/current-func-info.vim' " Adds a set of functions to retrieve the name of the 'current' function in a source file, for the scope the cursor is in
    Plug 'https://gitlab.com/code-stats/code-stats-vim.git' " Slightly gamifies programming, for shits 'n' giggles
    Plug '907th/vim-auto-save', { 'for': 'tex' } " Buffer auto-writing, which I only want for specific project/file types
    Plug 'tpope/vim-scriptease' " A vim plugin to help with writing vim plugins; most notably :PP acts as a decent REPL

  " Next-up
    " Plug 'bootleq/ShowMarks' " Better mark handling and display
    Plug 'tpope/vim-fugitive' " git integration for vim, need to watch screencasts. Have activated for now for commit wrapping.
    " Plug 'gregsexton/gitv' " vim-based git viewer, needs fugitive repo viewer/browser
    " Plug 'godlygeek/tabular' " Align elements on neighbouring lines, e.g. quickly build text 'tables'
    " Plug 'Keithbsmiley/investigate.vim " Lookup docs on word under cursor, configurable lookup command - this would be extremely useful if I write PageUp

  " Late-loaded plugins
    Plug 'ryanoasis/vim-devicons' " Adds language icons to things like nerdtree and lightline
  call plug#end() " Adds plugins to runtimepath
" }}}

" Plugin configuration ============================== {{{
  " Lightline {{{
    let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive'],[ 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LLFugitive',
      \   'readonly': 'LLReadonly',
      \   'modified': 'LLModified',
      \   'filename': 'LLFilename',
      \   'mode': 'LLMode'
      \ }
    \ }

    function! LLMode()
      let fname = expand('%:t')
      return fname ==# '__Tagbar__' ? 'Tagbar' :
            \ fname ==# 'ControlP' ? 'CtrlP' :
            \ lightline#mode() ==# 'NORMAL' ? 'N' :
            \ lightline#mode() ==# 'INSERT' ? 'I' :
            \ lightline#mode() ==# 'VISUAL' ? 'V' :
            \ lightline#mode() ==# 'V-LINE' ? 'V' :
            \ lightline#mode() ==# 'V-BLOCK' ? 'V' :
            \ lightline#mode() ==# 'REPLACE' ? 'R' : lightline#mode()
    endfunction

    function! LLModified()
      if &filetype ==# 'help'
        return ''
      elseif &modified
        return '+'
      elseif &modifiable
        return ''
      else
        return ''
      endif
    endfunction

    function! LLReadonly()
      if &filetype ==# 'help'
        return ''
      elseif &readonly
        return '!'
      else
        return ''
      endif
    endfunction

    function! LLFugitive()
      return exists('*fugitive#head') ? fugitive#head() : ''
    endfunction

    function! LLFilename()
      return ('' !=# LLReadonly() ? LLReadonly() . ' ' : '') .
            \ ('' !=# expand('%:t') ? expand('%:t') : '[No Name]') .
            \ ('' !=# LLModified() ? ' ' . LLModified() : '')
    endfunction
  " }}}

  " Markdown {{{
    " Enable syntax-based folding.
    " This will have negative performance impact on sufficiently large files,
    " however, and simply disabling folding in general does not stop that.
    let g:markdown_enable_folding = 1
    " Automatically unfold all so we don't start at 100% folded :)
    autocmd sn FileType markdown normal zR
    " Disable spellcheck (it's bad, and I'm not)
    let g:markdown_enable_spell_checking = 0
    " Set indent/tab for markdown files to 4 spaces
    autocmd sn FileType markdown setlocal shiftwidth=4 softtabstop=4 tabstop=4
  " }}}

  " Elm {{{
    " Set indent/tab for Elm files to 4 spaces
    autocmd sn FileType elm setlocal shiftwidth=4 softtabstop=4 tabstop=4
  " }}}

  " ALE {{{
    " TODO: use devicons for error/warning signs?
    " TODO: auto-open any lines in folds with linter errors in them, or at
    " least do so on changing to their location-list position to them...
    " Req: install desired linters/style checkers (globally or in the
    " virtualenv you're running from). flake8 is good.

    " Clear the warning buffer immediately on any change (to prevent
    " highlights on the edited line from falling out of sync and throwing me
    " off)
    autocmd sn TextChanged,TextChangedI * ALEResetBuffer

    " To still make it easy to know if there is *something* in the gutter *somewhere*
    let g:ale_change_sign_column_color = 1

    " Enable completion where LSP servers are available
    let g:ale_completion_enabled = 1

    " Per-language, non-LSP config
    let g:ale_fixers = {}
    let g:ale_linters = {}
    " TODO LaTeX prose linting?
    " Elm
      let g:ale_linters['elm'] = ['elm-make']
      let g:ale_fixers['elm'] = ['elm-format']
      autocmd sn FileType elm let b:ale_fix_on_save = 1
    " Lua
      let g:ale_linters['lua'] = ['lua', 'luacheck']
    " Python
      let g:ale_fixers['python'] = ['black', 'isort']
      autocmd sn FileType python let b:ale_fix_on_save = 1
      " Requires e.g. ~/.config/flake8 for Black's line-width
      " Black-compatible isort config
      let g:ale_python_black_options = '-l 80'
      let g:ale_python_isort_options = '--multi-line=3 --trailing-comma --force-grid-wrap=0 --combine-as --line-width=80'
      let g:ale_python_auto_pipenv = 0
      " Cython linting
      let g:ale_linters['cython'] = ['cython']
    " Nix
      let g:ale_linters['nix'] = ['nix-instantiate']
    " VimL/vimscript
      let g:ale_linters['vim'] = ['vint']
  " }}}

  " indentLine {{{
    " Set the indent line's colour to a subtle, faded grey-brown
    let g:indentLine_color_gui = '#474038'
    let g:indentLine_char = '▏'
  " }}}

  " neoformat {{{
    " Considered using yapf Python formatter, but it creates some *really*
    " awkward constructs, frankly. 
    " Some related GH issue #s: 465, 443, 414, 390, 379, 377...
    " Conclusion: yapf needs way more knobs to be useful to me. Or I'm too
    " particular about how I like my code formatted.
    let g:neoformat_enabled_python = ['isort'] " :Neoformat in Python file to sort imports, needs 'isort' executable available
  " }}}

  " vim-json {{{
    " Set foldmethod to syntax so we can fold json dicts and lists
    autocmd sn FileType json setlocal foldmethod=syntax 
    " Then automatically unfold all so we don't start at 100% folded :)
    autocmd sn FileType json normal zR
    " Don't conceal quote marks, that's fucking horrific. Who the hell would
    " choose to default to that behaviour? Do they only ever read json, never
    " write it?! Hell, even then it's still problematic!
    let g:vim_json_syntax_conceal = 0
  " }}}

  " gist-vim: {{{
    let g:gist_clip_command = 'xclip -selection clipboard'
    let g:gist_detect_filetype = 1
    let g:open_browser_after_post = 1
    let g:gist_browser_command = 'firefox %URL% &'
    let g:gist_show_privates = 1 " show private posts with :Gist -l
    let g:gist_post_private = 1 " default to private gists
  " }}}

  " vim-session {{{
    let g:session_autoload = 'no'
    let g:session_autosave = 'prompt'
    let g:session_autosave_only_with_explicit_session = 1
    let g:session_command_aliases = 1 " Session-prefixed command aliases, e.g. OpenSession -> SessionOpen
    let g:session_directory = $HOME . '/.local/share/nvim/sessions'
    let g:session_lock_directory = $HOME . '/.local/share/nvim/session-locks'
  " }}}

  " Denite {{{
    " Sane ignore for file tree matching, this ignores vcs files, binaries,
    " temporary files, etc.
    call denite#custom#filter ('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', '.hg/', '.svn/', '.yardoc/', 'public/mages/',
      \   'public/system/', 'log/', 'tmp/', '__pycache__/', 'venv/', '*.min.*',
      \   '*.pyc', '*.exe', '*.so', '*.dat', '*.bin', '*.o'])

    " Use The Silver Searcher (ag) for denite search backend if available (it's
    " real fast and respects .gitignore yo)
    if (executable('ag'))
      call denite#custom#var('file_rec', 'command',
        \ ['ag', '-l', '--nocolor', '-g', ''])
    endif

    " Change the default sorter for the sources I care about
    call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
    call denite#custom#source('file_mru', 'sorters', ['sorter_sublime'])
    call denite#custom#source('buffer', 'sorters', ['sorter_sublime'])
  " }}}

  " NERDTree {{{
    let NERDTreeMinimalUI = 1 " Prettify
    let NERDTreeDirArrows = 1 "Prettify moar 
  " }}}

  " Neosnippets {{{
    let g:neosnippet#snippets_directory = expand('~/.config/nvim/neosnippets/')
    " Use actual tabstops in snippet files
    au sn FileType neosnippet setlocal noexpandtab
  " }}}

  " vim-workspace {{{
    " Disable lightline's tabline functionality, as it conflicts with this
    let g:lightline.enable = { 'tabline': 0 }
    " Prettify
    let g:workspace_powerline_separators = 1
    let g:workspace_tab_icon = "\uf00a"
    let g:workspace_left_trunc_icon = "\uf0a8"
    let g:workspace_right_trunc_icon = "\uf0a9"
  " }}}

  " Tagbar {{{
    " Default tag sorting by order of appearance within file (still grouped by
    " scope)
    let g:tagbar_sort = 0
    " Keep all tagbar folds closed initially; better for a top-level overview
    let g:tagbar_foldlevel = 0
    " Move cursor to the tagbar window when it is opened
    let g:tagbar_autofocus = 1
  " }}}

  " Startify {{{
    let g:startify_session_dir = '~/.local/share/nvim/sessions'
    let g:startify_list_order = [
      \ ['  Bookmarks'], 'bookmarks',
      \ ['  Sessions'], 'sessions',
      \ ['  Commands'], 'commands',
      \ ['  MRU'], 'files',
      \ ['  MRU Current Tree Files by Modification Time'], 'dir',
    \ ]

    let g:startify_bookmarks = [
      \ {'c': '~/.config/nvim/init.vim'},
      \ {'d': '~/todo.md'},
      \ {'x': '~/.tmuxp/'},
    \ ]

    let g:startify_fortune_use_unicode = 1

    " Prepend devicon language logos to file paths
    " TODO: improve vim-startify to use this for bookmark entries as well
    function! StartifyEntryFormat()
      return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction
  " }}}

  " code-stats-vim {{{
    " Pull the oh-so-important sekret API key from an environment variable
    let g:codestats_api_key = $CODESTATS_API_KEY
  " }}}

  " vimtex {{{
    let g:vimtex_compiler_progname = '/run/current-system/sw/bin/nvr'
    let g:vimtex_compiler_method = 'latexmk'
    let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : 'build',
      \}
    let g:vimtex_view_method = 'zathura'
    let g:vimtex_view_use_temp_files = 1
    let g:vimtex_disable_recursive_main_file_detection = 1
    " Just to prevent vim occasionally deciding we're using 'plaintex' for no
    " apparent reason
    let g:tex_flavor = 'latex'
    " Turn auto-writing on so we get more of a 'live' PDF preview
    autocmd sn FileType tex silent! AutoSaveToggle
  " }}}

  " echodoc.vim {{{
    " So the current mode indicator in the command line does not overwrite the
    " function signature display
    set noshowmode
  " }}}

  " asyncomplete.vim {{{
    let g:asyncomplete_auto_popup = 1
    " Fuzzy completion is fucking distracting, disable it
    let g:asyncomplete_smart_completion = 0
    " Mainly useful to remove duplicate entries from the `buffer` source in
    " favour of e.g. LSP-provided entries
    let g:asyncomplete_remove_duplicates = 1
    " Less spammy completion
    set shortmess+=c

    " Register sources
    " Use explicit priorities to control ordering and deduplication of entries
    " Use a variable for this one to share it between here and the LSP
    " configuration
    let s:asyncomplete_language_priority = 3
    augroup sn
      au User asyncomplete_setup call
        \ asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'whitelist': ['*'],
          \ 'priority': 0,
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ }))
      au User asyncomplete_setup call
        \ asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
          \ 'name': 'file',
          \ 'whitelist': ['*'],
          \ 'priority': 1,
          \ 'completor': function('asyncomplete#sources#file#completor'),
          \ }))
      au User asyncomplete_setup call
        \ asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
          \ 'name': 'neosnippet',
          \ 'whitelist': ['*'],
          \ 'priority': 2,
          \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
          \ }))
      if !executable('clangd') && executable('ctags')
        au User asyncomplete_setup call
          \ asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
            \ 'name': 'tags',
            \ 'whitelist': ['c'],
            \ 'priority': s:asyncomplete_language_priority,
            \ 'completor': function('asyncomplete#sources#tags#completor'),
            \ }))
      endif
      if !executable('rls') && executable('racer')
        au User asyncomplete_setup call
          \ asyncomplete#register_source(asyncomplete#sources#racer#get_source_options({
            \ 'priority': s:asyncomplete_language_priority,
            \ }))
      endif
    augroup END
  " }}}

  " vim-lsp {{{
    let g:lsp_signs_enabled = 1
    let g:lsp_diagnostics_echo_cursor = 1
    " Ensure ale_linters and ale_fixers exist before setting keys on them
    let g:ale_linters = get(g:, 'ale_linters', {})
    let g:ale_fixers = get(g:, 'ale_fixers', {})
    function! s:register_lsp(exec, cmd, filetypes, ...) abort
      let l:extra_opts = a:0 >= 1 ? a:1 : {}
      let l:base_opts = {
          \ 'name': a:exec,
          \ 'cmd': a:cmd,
          \ 'whitelist': a:filetypes,
          \ 'priority': s:asyncomplete_language_priority,
          \ }
      let l:opts = extend(l:base_opts, l:extra_opts)
      if executable(a:exec)
        call lsp#register_server(l:opts)
        " Disable ALE linting and fixing for the LSP-supported filetypes
        for l:ft in a:filetypes
          let g:ale_linters[l:ft] = []
          let g:ale_fixers[l:ft] = []
        endfor
      endif
    endfunction

    " Register/configure Language Servers
    " TODO implement socket-based LSP support in vim-lsp...
    " TODO configure as many as possible to use systemd socket-activated user
    " service versions, to share resources
    augroup sn
      au User lsp_setup call s:register_lsp(
        \ 'clangd',
        \ {server_info -> ['clangd']},
        \ ['c', 'cpp', 'objc', 'objcpp'])
      au User lsp_setup call s:register_lsp(
        \ 'css-languageserver',
        \ {server_info -> [&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ ['css', 'less', 'sass'])
      au User lsp_setup call s:register_lsp(
        \ 'go-langserver',
        \ {server_info -> ['go-langserver', '-mode', 'stdio']},
        \ ['go'])
      au User lsp_setup call s:register_lsp(
        \ 'hie-wrapper',
        \ {server_info -> [&shell, &shellcmdflag, 'hie-wrapper --lsp']},
        \ ['haskell'])
      " TODO: configure to auto-fix with black and isort
      au User lsp_setup call s:register_lsp(
        \ 'pyls',
        \ {server_info -> ['pyls']},
        \ ['python'])
      au User lsp_setup call s:register_lsp(
        \ 'solargraph',
        \ {server_info -> [&shell, &shellcmdflag, 'solargraph stdio']},
        \ ['ruby'],
        \ {'initialization_options': {"diagnostics": "true"}})
      au User lsp_setup call s:register_lsp(
        \ 'rls',
        \ {server_info -> ['rustup', 'run', 'nightly', 'rls']},
        \ ['rust'])
    augroup END
  " }}}

  " General plugin config {{{
    let g:javascript_enable_domhtmlcss = 1 " Enable HTMLL/CSS highlighting in JS files
    " Disable the scrollbars (NERDTree)
    set guioptions-=r
    set guioptions-=L
  " }}}
" }}}

" Key binds/mappings ====================================== {{{
  " Fuck hitting shift
  map ; :
  " Just in case we actually need ;, double-tap it
  noremap ;; ;
  " We leave the : mapping in place to avoid mishaps with typing
  " :Uppercasecommands

  " s{char}{char} to easymotion-highlight all matching two-character sequences in sight
  nmap s <Plug>(easymotion-overwin-f2)

  " Visualize undo tree in pane
  nnoremap <Leader>u :GundoToggle<CR>
  let g:gundo_right = 1 " Opposite nerdtree's pane

  " Project file explorer in pane
  nmap <Leader>p :NERDTreeToggle<CR>
  " Open the project tree and expose current file in the nerdtree with Ctrl-\
  nnoremap <silent> <C-\> :NERDTreeFind<CR>

  " Easier window splits, C-w,v to vv, C-w,s to ss
  nnoremap <silent> vv <C-w>v
  nnoremap <silent> ss <C-w>s

  " Quicker split navigation with <leader>-h/l/j/k
  nnoremap <silent> <leader>h <C-w>h
  nnoremap <silent> <leader>l <C-w>l
  nnoremap <silent> <leader>k <C-w>k
  nnoremap <silent> <leader>j <C-w>j

  " Quicker split resizing with Ctrl-<Arrow Key>
  nnoremap <C-Up> <C-w>+
  nnoremap <C-Down> <C-w>-
  nnoremap <C-Left> <C-w><
  nnoremap <C-Right> <C-w>>

  " swap so that: 0 to go to first character, ^ to start of line, we want
  " the former more often
  nnoremap 0 ^
  nnoremap ^ 0

  " close quickfix window more easily
  nmap <silent> <Leader>qc :cclose<CR>

  " Quickly turn off search highlights
  nmap <Leader>hs :nohls<CR>

  " Replace normal search with incsearch.vim
  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)

  " Searches through most-recently-used files, recursive file/dir tree, and
  " current buffers
  nnoremap <leader>f :<C-u>Denite buffer file_rec file_mru <cr>

  " Move forward/backward between flagged warnings & errors
  nmap <silent> <leader>] <Plug>(ale_next_wrap)
  nmap <silent> <leader>[ <Plug>(ale_previous_wrap)

  " Backspace to swap to previous buffer
  noremap <BS> <C-^>
  " Shift-Backspace to delete line contents but leave the line itself
  noremap <S-BS> cc<ESC>

  " Neosnippet mappings
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)

  " Tagbar
  nmap <leader>m :TagbarToggle<CR>
" }}}

" Basic configuration ===================================== {{{
  " Resize splits when the window is resized
  au sn VimResized * exe "normal! \<c-w>="

  " Theming
    if !empty($TMUX)
      set termguicolors
    endif
    if $TERM ==# 'rxvt-unicode-256color'
      set termguicolors
    endif
    " For Mosh
    if $TERM ==# 'xterm-256color'
      set termguicolors
    endif
    syntax enable
    colorscheme gruvbox
    let g:gruvbox_contrast_dark='hard'
    let g:gruvbox_number_column='bg1'
    set background=dark
    " gruvbox cursor highlight in search fixes
    nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
    nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
    nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

    nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
    nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
    nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

  " Search
    set incsearch " Incremental searching
    set hlsearch " Highlight matches by default
    set ignorecase " Ignore case when searching
    set smartcase " ^ unless a capital letter is typed

  " Hybrid relative line numbers
    set number
    set relativenumber

  " Indentation
    set autoindent " Copy indent to new line
    set shiftwidth=2 " Use 2-space autoindentation
    set softtabstop=2
    set tabstop=2 " Together with ^, number of spaces a <Tab> counts for
    set expandtab " Change <Tab> into spaces automatically in insert mode and with autoindent
    " Insert a real <Tab> with CTRL-V<Tab> while in insert mode

  filetype plugin on " Load filetype.vim in runtimepath
  filetype indent on " Load indent.vim in runtimepath
  set backspace=indent,eol,start " Allow backspace in insert mode
  set history=1000
  set hidden " Buffers are not unloaded when 'abandoned' by editing a new file, only when actively quit
  set wrap " Wrap lines...
  set linebreak " ...visually, at convenient places
  set list listchars=trail:·,tab:»· " Display <Tab>s and trailing spaces visually
  " Tweak the colour of the visible tab/space characters
  highlight Whitespace guifg=#857767
  set foldmethod=marker " Because file-based folds are awesome
  set scrolloff=6 " Keep 6 lines minimum above/below cursor when possible; gives context
  set sidescrolloff=10 " Similar, but for vertical space & columns
  set sidescroll=1 " Minimum number of columns to scroll horiznotall when moving cursor off screen
  " Previous two only apply when `wrap` is off, something I occasionally need to do
  set mouse="c" " Disable mouse cursor movement
  set modeline " Support modelines in files
  " Always keep the gutter open, constant expanding/contracting gets annoying fast
  set signcolumn=yes

  " Set netrwhist home location to prevent .netrwhist being made in
  " .config/nvim/ -- it is data not config
  " TODO: Fix upstream in neovim / file bug report + need standard way of
  " getting XDG_DATA_HOME reliably
  let g:netrw_home=$HOME . '/.local/share/nvim'
" }}}

" Advanced configuration ================================== {{{
    " Use The Silver Searcher (ag) for search backend if available (it's
    " real fast and respects .gitignore yo)
    if (executable('ag'))
      let g:ackprg = 'ag --nogroup --column'
      set grepprg:ag\ --nogroup\ --nocolor
    endif

    " TODO: Delete old undofile automatically when vim starts
    " TODO: Delete old backup files automatically when vim starts
    " Both are under ~/.local/share/nvim/{undo,backup} in neovim by default
    " Keep undo history across sessions by storing it in a file
    set undodir=~/.local/share/nvim/undo//
    if !empty(glob(&undodir))
      silent call mkdir(&undodir, 'p')
    endif
    set backupdir=~/.local/share/nvim/backup//
    if !empty(glob(&backupdir))
      silent call mkdir(&backupdir, 'p')
    endif
    set undofile
    set backup

    " TODO: Make incremental search open all folds with matches while
    " searching, close the newly-opened ones when done (except the one the
    " selected match is in)

    " TODO: SyntaxRange pattern-matched filetype
    "
    " TODO: Configure makers for automake

    " File-patterns to ignore for wildcard matching on tab completion
      set wildignore=*.o,*.obj,*~ 
      set wildignore+=*.png,*.jpg,*.gif

    " Have nvim jump to the last position when reopening a file
    if has('autocmd')
      au sn BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
      " Exclude gitcommit type to avoid doing this in commit message editor
      " sessions
      au sn FileType gitcommit normal! gg0
    endif

    " Default to opened folds in gitcommit filetype (having them closed by
    " default doesn't make sense in this context; only really comes up when
    " using e.g. `git commit -v` to get the commit changes displayed)
    autocmd sn FileType gitcommit normal zR

    " Track window- and buffer-local options in sessions
    set sessionoptions+=localoptions

    " TODO when working on code inside a per-project virtualenv or nix.shell,
    " automatically detect and use the python from the project env
" }}}
