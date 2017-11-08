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
    "Plug 'ryanoasis/vim-devicons' " Adds language icons to things like nerdtree and lightline - need patched font: https://github.com/ryanoasis/nerd-fonts
    Plug 'fholgado/minibufexpl.vim' " Gives a statusline with buffers on it if you have any hidden buffers
    Plug 'haya14busa/incsearch.vim' " Incremental highlight on incsearch, including of partial regex matches
    Plug 'Yggdroot/indentLine' " Visual display of indent levels

  " Language support and syntax highlighting
    Plug 'benekastah/neomake' " Async syntax and error checking 
    Plug 'keith/tmux.vim'
    Plug 'othree/yajs.vim' | Plug 'othree/javascript-libraries-syntax.vim'
    Plug 'tpope/vim-markdown' | Plug 'jtratner/vim-flavored-markdown'
    "Plug 'tomtom/tlib_vim' | Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'MarcWeber/vim-addon-actions' | Plug 'MarcWeber/vim-addon-completion' | Plug 'MarcWeber/vim-addon-goto-thing-at-cursor' | Plug 'MarcWeber/vim-addon-errorformats' | Plug 'MarcWeber/vim-addon-nix' " Nix error checking -- currently broken under neovim, not sure why
    Plug 'LnL7/vim-nix' " Nix syntax highlighting
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

  " Code cleanup, linting, and formatting
    Plug 'sbdchd/neoformat'

  " Project management
    Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'} | Plug 'jistr/vim-nerdtree-tabs'
    Plug 'ctrlpvim/ctrlp.vim', {'on': 'CtrlP'} " Full path fuzzy file/buffer/mru/tag/..., hit <C-p> obviously
    Plug 'vim-scripts/TaskList.vim' " Display FIXME/TODO/etc. in handy browseable list pane, bound to <Leader>t, then q to cancel, e to quit browsing but leave tasklist up, <CR> to quit and place cursor on selected task

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
    Plug 'xolox/vim-misc' | Plug 'xolox/vim-session' " Extended session
    " management, very cool
    Plug 'easymotion/vim-easymotion'
    Plug 'AndrewRadev/splitjoin.vim' " Allows for splitting/joining code into/from multi-line formats, gS and gJ bydefault
    Plug 'Raimondi/delimitMate' " Automatic context-sensitive closing of quotes, parenthesis, brackets, etc. and related features
    Plug 'Shougo/deoplete.nvim', {'do': function('PlugUpdateRemote')} " neocomplete for neovim (irony), still pretty beta but good
    Plug 'tomtom/tcomment_vim' " Toggle commenting of lines with gc{motion}, also works in visual mode
    Plug 'terryma/vim-multiple-cursors' " SublimeText-style multiple cursor impl., ctrl-n to start matching on current word to place
    Plug 'sjl/gundo.vim' " Allows you to visualize your undo tree in a pane opened with :GundoToggle
    Plug 'bogado/file-line' " Allows doing `vim filename:lineno`
    Plug 'vim-scripts/camelcasemotion' " ,w ,b and ,e alternate motions that support traversing CamelCase and underscore_notation
    Plug 'tpope/vim-endwise' " Automatic closing of control flow blocks for most languages, eg. `end` inserted after `if` in Ruby
    Plug 'tpope/vim-surround' " Primarily useful for surrounding existing lines in new delimiters, quotation marks, xml tags, etc., or removing or modifying said 'surroundings'. <operation>s<surrounding-type> is most-used
    Plug 'tpope/vim-repeat' " Plugin-hookable `.`-replacement, user-transparent
    Plug 'chrisbra/SudoEdit.vim' " Lets you do `:SudoWrite`/`:SudoRead`, and also launch vim with `nvim sudo:/etc/fstab`, all of which are nicer+shorter than directly using the tee trick
    Plug 'goldfeld/ctrlr.vim' " Reverse search ex command history ala Bash ctrl-r

  " Next-up
    " Plug 'bootleq/ShowMarks' " Better mark handling and display
    Plug 'tpope/vim-fugitive' " git integration for vim, need to watch
    " screencasts. Have activated for now for commit wrapping.
    " Plug 'gregsexton/gitv' " vim-based git viewer, needs fugitive
    " repo viewer/browser
    " Plug `some sort of snippet plugin` - snipmate or ultisnips +
    " vim-snippets
    " Tags? (tagbar seems interesting?)
    " Plug 'godlygeek/tabular' " Align elements on neighbouring lines, e.g.
    " quickly build text 'tables'
    " Plug 'Keithbsmiley/investigate.vim " Lookup docs on word under cursor,
    " configurable lookup command - this would be extremely useful if I
    " write PageUp
    " Plug 'tpope/vim-abolish' " Used for performing operations on all
    " variations of a word/words, there will likely come a day when I want
    " this
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

  " indentLine
    " Set the indent line's colour to a subtle, faded grey-brown
    let g:indentLine_color_gui = '#564d43'

  " neoformat
    " Considered using yapf Python formatter, but it creates some *really*
    " awkward constructs, frankly. 
    " Some related GH issue #s: 465, 443, 414, 390, 379, 377...
    " Conclusion: yapf needs way more knobs to be useful to me. Or I'm too
    " particular about how I like my code formatted.
    let g:neoformat_enabled_python = ['isort'] " :Neoformat in Python file to sort imports

  " vim-json
    " Set foldmethod to syntax so we can fold json dicts and lists
    autocmd FileType json setlocal foldmethod=syntax 
    " Then automatically unfold all so we don't start at 100% folded :)
    autocmd FileType json normal zR

  " gist-vim:
    let g:gist_clip_command = 'xclip -selection clipboard'
    let g:gist_detect_filetype = 1
    let g:open_browser_after_post = 1
    let g:gist_browser_command = 'firefox %URL% &'
    let g:gist_show_privates = 1 " show private posts with :Gist -l
    let g:gist_post_private = 1 " default to private gists

  " Neomake
    au BufRead,BufNewFile,BufWritePost * Neomake " Run checks on file open, creation and save
    " Add filetype-specific makers/changes here, as necessary
    " TODO: selectively enable mix instead of elixir maker with presence of
    " mix.exs file/proper project structure?
    let g:neomake_elixir_enabled_makers = ['mix']
    let g:neomake_elixir_mix_maker = {
        \ 'args': ['compile'],
        \ 'errorformat':
        \ '** %s %f:%l: %m,' .
        \ '%f:%l: warning: %m'
        \ }
    let g:neomake_elixir_test_maker = {
        \ 'exe': 'mix',
        \ 'args': ['test'],
        \ 'errorformat':
        \ '%Z       %f:%l,' .
        \ '%C     ** %m,' .
        \ '%C     %[%^:]%#:%.%#,' .
        \ '%C     %m,' .
        \ '%E  %n)%.%#'
        \ }

  " vim-session
    let g:session_autoload = 'no'
    let g:session_autosave = 'no'
    let g:session_command_aliases = 1 " Session-prefixed command aliases, e.g. OpenSession -> SessionOpen

  " deoplete
    let g:deoplete#enable_at_startup = 1 " Enable deoplete
    let g:deoplete#enable_smart_case = 1 " Use smartcase

  " ctrlp
    " Sets ctrlp working dir to vim working dir, unless current file is not
    " a descendent of vim working dir path
    let g:ctrlp_working_path_mode = 'a'
    " Sane Ignore For ctrlp - ctrlp scans directory tree by default, this
    " ignores vcs files and the like
    let g:ctrlp_custom_ignore = {
      \ 'dir': '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$',
      \ 'file': '\.exe$\|\.so$\|\.dat$'
      \ } 

    " Use The Silver Searcher (ag) for ctrl-p search backend if available (it's
    " real fast and respects .gitignore yo)
    if (executable('ag'))
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    endif

    let g:ctrlp_switch_buffer = 0 " Don't jump to existing window on buffer, open new one

  " NERDTree + Tabs
    let NERDTreeMinimalUI = 1 " Prettify
    let NERDTreeDirArrows = 1 "Prettify moar 
    let g:nerdtree_tabs_open_on_gui_startup = 0 "Don't start with vim

  " General plugin config
    let g:javascript_enable_domhtmlcss = 1 " Enable HTMLL/CSS highlighting in JS files
    " Disable the scrollbars (NERDTree)
    set guioptions-=r
    set guioptions-=L
    let g:session_directory = '~/.local/share/nvim/sessions'
    let g:livepreview_previewer = 'zathura' " Zathura is pretty much ideal for this purpose, in my experience
    let g:nix_maintainer = "arobyn"
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

  " ctrl-p search on <Leader>f, for fuzzy or find or whatever
  let g:ctrlp_map = '<Leader>f'
  " The below is necessary to work with on-demand plugin loading
  nnoremap <Leader>f :CtrlP<CR>

  " Easier window splits, C-w,v to vv, C-w,s to ss
  nnoremap <silent> vv <C-w>v
  nnoremap <silent> ss <C-w>s

  " Quicker split navigation with Ctrl-h/l/j/k
  nnoremap <silent> <C-h> <C-w>h
  nnoremap <silent> <C-l> <C-w>l
  nnoremap <silent> <C-k> <C-w>k
  nnoremap <silent> <C-j> <C-w>j
  " Terrible band-aid until neovim/neovim#2048 is resolved internally.
  " Fixing terminfo locally is not a solution due to remote computers
  nmap <BS> <C-w>h 

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
" }}}

" Basic options ===================================== {{{
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
    set smartindent " ...but be smarter and use different indent as appropriate
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

" Advanced options ================================== {{{
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
" }}}
