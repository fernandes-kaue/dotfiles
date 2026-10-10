# Dotfiles

Configurações pessoais para um ambiente Linux voltado a desenvolvimento web/backend. O repositório usa o padrão de bare repository para versionar arquivos diretamente a partir do diretório pessoal.

## Conteúdo

- Zsh modularizado, aliases e funções
- Neovim/LazyVim com suporte a TypeScript, Node.js, Java, PHP, SQL, Prisma e Docker
- Tmux, Kitty, btop e outras ferramentas de terminal
- Scripts de diagnóstico, backup e manutenção
- Serviços e ajustes de usuário do systemd
- Scanner de padrões sensíveis antes de commits

## Configuração do repositório bare

~~~bash
git clone --bare git@github.com:fernandes-kaue/dotfiles.git "$HOME/.dotfiles"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no
~~~

Alias recomendado:

~~~zsh
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
~~~

Depois de definir o alias:

~~~bash
dot checkout
dot status
~~~

Faça backup de arquivos locais conflitantes antes do `checkout`.

## Neovim

A configuração principal está em `.config/nvim`. Após restaurá-la, sincronize os plugins:

~~~bash
nvim --headless "+Lazy! sync" +qa
~~~

## Segurança

O repositório não deve armazenar credenciais, chaves SSH, tokens, arquivos `.env`, configurações do rclone ou dados de navegadores. O script `.local/bin/dotfiles-secret-scan` verifica padrões sensíveis nos arquivos rastreados.

~~~bash
dotfiles-secret-scan staged
dotfiles-secret-scan all
~~~

A verificação por padrões reduz risco, mas não substitui a revisão manual antes de publicar mudanças.
