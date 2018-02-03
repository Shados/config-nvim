" First-load settings
  let mapleader = "\<Space>"

" Plugin functions ================================== {{{
  function! PlugUpdateRemote(info)
    if a:info.status != 'unchanged' || a:info.force
      UpdateRemotePlugins
    endif
  endfunction
  function! PlugUpdateRustRemote(info)
    if a:info.status != 'unchanged' || a:info.force
      !cargo build --release
      PlugUpdateRemote(info)
    endif
  endfunction
" }}}

" Plugins =========================================== {{{
  " Load locally-managed plugins
  set rtp+=~/.config/nvim/local/*

  " We're using vim-plug for plugin management, as async updates and flexible
  " hooks are both very useful
  call plug#begin("~/.config/nvim/plugged")
  " Appearance
    Plug 'ap/vim-css-color'
    Plug 'skwp/vim-colors-solarized'
    Plug 'morhetz/gruvbox'
    Plug 'itchyny/lightline.vim'
    "Plug 'ryanoasis/vim-devicons' " Adds language icons to things like nerdtree and lightline - TODO need patched font: https://github.com/ryanoasis/nerd-fonts
    Plug 'fholgado/minibufexpl.vim' " Gives a statusline with buffers on it if you have any hidden buffers
    Plug 'haya14busa/incsearch.vim' " Incremental highlight on incsearch, including of partial regex matches
    Plug 'Yggdroot/indentLine' " Visual display of indent levels

  " Language support and syntax highlighting
    Plug 'w0rp/ale' " Async linting
    Plug 'keith/tmux.vim'
    Plug 'othree/yajs.vim' | Plug 'othree/javascript-libraries-syntax.vim'
    Plug 'gabrielelana/vim-markdown'
    Plug 'LnL7/vim-nix' " Nix syntax highlighting, error checking/linting is handled by ALE
    Plug 'Matt-Deacalion/vim-systemd-syntax'
    Plug 'RobertAudi/fish.vim'
    Plug 'vim-erlang/vim-erlang-runtime' | Plug 'vim-erlang/vim-erlang-compiler' | Plug 'vim-erlang/vim-erlang-omnicomplete' | Plug 'vim-erlang/vim-erlang-tags'
    Plug 'elixir-lang/vim-elixir'
    Plug 'avdgaag/vim-phoenix'
    Plug 'rust-lang/rust.vim'
    Plug 'xuhdev/vim-latex-live-preview'
    Plug 'lambdatoast/elm.vim'
    Plug 'saltstack/salt-vim'
    Plug 'elzr/vim-json' " Notably, let's you fold on json dict/lists

    Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets' " Code snippets, the mighty slayer of boilerplate
  " Code creation & refactoring
    Plug 'Shougo/deoplete.nvim', {'do': function('PlugUpdateRemote')} " neocomplete for neovim (irony), still pretty beta but good
    Plug 'tpope/vim-endwise' " Automatic closing of control flow blocks for most languages, eg. `end` inserted after `if` in Ruby
    Plug 'Raimondi/delimitMate' " Automatic context-sensitive closing of quotes, parenthesis, brackets, etc. and related features
    Plug 'sbdchd/neoformat' " Code cleanup, linting, and formatting

  " Project management
    Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} | Plug 'jistr/vim-nerdtree-tabs'
    Plug 'Shougo/denite.nvim', {'do': function('PlugUpdateRemote')} | Plug 'Shougo/neomru.vim' " Full path fuzzy file/buffer/mru/tag/.../arbitrary list search, bound to <leader>f (for find?)
    Plug 'vim-scripts/TaskList.vim' " Display FIXME/TODO/etc. in handy browseable list pane, bound to <Leader>t, then q to cancel, e to quit browsing but leave tasklist up, <CR> to quit and place cursor on selected task
    Plug 'xolox/vim-misc' | Plug 'xolox/vim-session' " Extended session

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

  " Next-up
    " Plug 'bootleq/ShowMarks' " Better mark handling and display
    Plug 'tpope/vim-fugitive' " git integration for vim, need to watch screencasts. Have activated for now for commit wrapping.
    " Plug 'gregsexton/gitv' " vim-based git viewer, needs fugitive repo viewer/browser
    " Tags? (tagbar seems interesting?)
    " Plug 'godlygeek/tabular' " Align elements on neighbouring lines, e.g. quickly build text 'tables'
    " Plug 'Keithbsmiley/investigate.vim " Lookup docs on word under cursor, configurable lookup command - this would be extremely useful if I write PageUp
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
      return fname == '__Tagbar__' ? 'Tagbar' :
            \ fname == 'ControlP' ? 'CtrlP' :
            \ lightline#mode() == 'NORMAL' ? 'N' :
            \ lightline#mode() == 'INSERT' ? 'I' :
            \ lightline#mode() == 'VISUAL' ? 'V' :
            \ lightline#mode() == 'V-LINE' ? 'V' :
            \ lightline#mode() == 'V-BLOCK' ? 'V' :
            \ lightline#mode() == 'REPLACE' ? 'R' : lightline#mode()
    endfunction

    function! LLModified()
      if &filetype == "help"
        return ""
      elseif &modified
        return "+"
      elseif &modifiable
        return ""
      else
        return ""
      endif
    endfunction

    function! LLReadonly()
      if &filetype == "help"
        return ""
      elseif &readonly
        return "!"
      else
        return ""
      endif
    endfunction

    function! LLFugitive()
      return exists('*fugitive#head') ? fugitive#head() : ''
    endfunction

    function! LLFilename()
      return ('' != LLReadonly() ? LLReadonly() . ' ' : '') .
            \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
            \ ('' != LLModified() ? ' ' . LLModified() : '')
    endfunction
  " }}}

  " Markdown {{{
    " Enable syntax-based folding.
    " This will have negative performance impact on sufficiently large files,
    " however, and simply disabling folding in general does not stop that.
    let g:markdown_enable_folding = 1
    " Automatically unfold all so we don't start at 100% folded :)
    autocmd FileType markdown normal zR
    " Disable spellcheck (it's bad, and I'm not)
    let g:markdown_enable_spell_checking = 0
    " Set indent/tab for markdown files to 4 spaces
    autocmd FileType markdown setlocal shiftwidth=4 softtabstop=4 tabstop=4
  " }}}

  " ALE {{{
    " TODO: use devicons for error/warning signs?
    " TODO: auto-open any lines in folds with linter errors in them, or at
    " least do so on ale_next/previous_wrap'ing to them...
    " Req: install desired linters/style checkers (globally or in the
    " virtualenv you're running from). flake8 is good.
    let g:ale_fixers = {
    \   'python': ['yapf'],
    \ }

    " Clear the warning buffer immediately on any change (to prevent
    " highlights on the edited line from falling out of sync and throwing me
    " off)
    autocmd TextChanged,TextChangedI * ALEResetBuffer
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
    autocmd FileType json setlocal foldmethod=syntax 
    " Then automatically unfold all so we don't start at 100% folded :)
    autocmd FileType json normal zR
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
    let g:session_autosave = 'no'
    let g:session_command_aliases = 1 " Session-prefixed command aliases, e.g. OpenSession -> SessionOpen
    let g:session_directory = '~/.local/share/nvim/sessions'
  " }}}

  " deoplete {{{
    let g:deoplete#enable_at_startup = 1 " Enable deoplete
    let g:deoplete#enable_smart_case = 1 " Use smartcase
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
  " }}}

  " NERDTree + Tabs {{{
    let NERDTreeMinimalUI = 1 " Prettify
    let NERDTreeDirArrows = 1 "Prettify moar 
    let g:nerdtree_tabs_open_on_gui_startup = 0 "Don't start with vim
  " }}}

  " Neosnippets {{{
    let g:neosnippet#snippets_directory = expand('~/.config/nvim/neosnippets/')

    " For conceal markers.
    if has('conceal')
      set conceallevel=2 concealcursor=niv
    endif
  " }}}

  " General plugin config {{{
    let g:javascript_enable_domhtmlcss = 1 " Enable HTMLL/CSS highlighting in JS files
    " Disable the scrollbars (NERDTree)
    set guioptions-=r
    set guioptions-=L
    let g:livepreview_previewer = 'zathura' " Zathura is pretty much ideal for this purpose, in my experience
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
  nnoremap <leader>f :<C-u>Denite file_mru file_rec buffer<cr>

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
  " SuperTab like snippets behavior.
  imap <expr><TAB>
  \ pumvisible() ? "\<C-n>" :
  \ neosnippet#expandable_or_jumpable() ?
  \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  smap <expr><TAB>
  \ neosnippet#expandable_or_jumpable() ?
  \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" }}}

" Basic configuration ===================================== {{{
  " Resize splits when the window is resized
  au VimResized * exe "normal! \<c-w>="

  " Theming
    if !empty($TMUX)
      set termguicolors
    endif
    if $TERM == 'rxvt-unicode-256color'
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

  " Set netrwhist home location to prevent .netrwhist being made in
  " .config/nvim/ -- it is data not config
  " TODO: Fix upstream in neovim / file bug report + need standard way of
  " getting XDG_DATA_HOME reliably
  let g:netrw_home=$HOME . "/.local/share/nvim"
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
    call system('mkdir -p' . &undodir)
    set backupdir=~/.local/share/nvim/backup//
    call system('mkdir -p ~/.local/share/nvim/backup')
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
    if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    " Default to opened folds in gitcommit filetype (having them closed by
    " default doesn't make sense in this context; only really comes up when
    " using e.g. `git commit -v` to get the commit changes displayed)
    autocmd FileType gitcommit normal zR
" }}}
