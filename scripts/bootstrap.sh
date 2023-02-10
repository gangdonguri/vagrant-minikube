# package update
apt-get -y update

# VBoXClient
apt-get install dkms linux-headers-$(uname -r) build-essential
apt-get install libxt6 libxmu6

# locale & time
localedef -v -c -i ko_KR -f UTF-8 ko_KR.UTF-8
localectl set-locale LANG=ko_KR.utf8
timedatectl set-timezone Asia/Seoul

# ntp
sed -i 's/^#NTP=$/NTP=server 1.kr.pool.ntp.org server 0.asia.pool.ntp.org server 3.asia.pool.ntp.org/' /etc/systemd/timesyncd.conf
systemctl enable --now systemd-timesyncd

# dns
sed -i 's/nameserver.*/nameserver 8.8.8.8/' /etc/resolv.conf

# vim
mkdir -p /home/vagrant/.vim/colors
curl -L https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim -o /home/vagrant/.vim/colors/jellybeans.vim
cat << "EOF" > /home/vagrant/.vimrc
set hlsearch
set nu
set autoindent
set scrolloff=2
set wildmode=longest,list
set ts=2
set sts=2
set sw=1
set autowrite
set autoread
set cindent
set bs=eol,start,indent
set history=256
set laststatus=2
set paste
set shiftwidth=2
set showmatch
set smartcase
set smarttab
set smartindent
set softtabstop=4
set tabstop=4
set ruler
set incsearch
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif
if $LANG[0]=='k' && $LANG[1]=='o'
set fileencoding=korea
endif
if has("syntax")
 syntax on
endif
colorscheme jellybeans
EOF
chown -R vagrant:vagrant /home/vagrant/.vim

# git
cp -av /vagrant/id_ed25519 /home/vagrant/.ssh/
chmod 400 /home/vagrant/.ssh/id_ed25519
git config --system user.name "gangdonguri"
git config --system user.email "rhkdgnsvk2@gmail.com"
git config --system core.editor "vim"