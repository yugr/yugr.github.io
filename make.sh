#!/bin/sh

# Simple script to automate initial blog creation
#
# This assumes hugo executable is in PATH.

set -eu
set -x

NAME=recovering-teamlead
DESC='Recovering Teamlead Blog'

BASE='/'
#BASE='https://yugr.github.io/recovering-teamlead/'

# Good
THEME_REPO=https://github.com/athul/archie  # 1k
#THEME_REPO=https://github.com/nanxiaobei/hugo-paper  # 2k

# Ugly
#THEME_REPO=https://github.com/adityatelange/hugo-PaperMod  # 11k
#THEME_REPO=https://github.com/panr/hugo-theme-terminal.git  # 2k
#THEME_REPO=https://github.com/yihui/hugo-xmin  # 800

# Not working
#THEME_REPO=https://github.com/kaiiiz/hugo-theme-monochrome.git  # 200
#THEME_REPO=https://github.com/luizdepra/hugo-coder  # 3k
#THEME_REPO=https://github.com/janraasch/hugo-bearblog.git  # 1k
#THEME_REPO=https://github.com/canhtran/maverick.git  # 60
#THEME_REPO=https://github.com/olOwOlo/hugo-theme-even  # 2k

THEME=$(basename $THEME_REPO | sed 's/^hugo-//; s/\.git$//')

rm -rf $NAME

hugo new site $NAME

cd $NAME

git submodule add --force --depth=1 $THEME_REPO themes/$THEME

sed -i -e "s!^\(baseURL *= *\).*!\1'$BASE'!" hugo.toml
sed -i -e "s/^\(title *= *\).*/\1'$DESC'/" hugo.toml
cat >> hugo.toml <<EOF
author = 'Yuri "yugr" Gribov'
copyright = '(c) yugr'

theme = '$THEME'

enableRobotsTXT = true

[[params.social]]
name = "GitHub"
icon = "github"
url = "https://github.com/yugr"

[[menu.main]]
name = "Home"
url = "/"
weight = 1

[[menu.main]]
name = "All posts"
url = "/posts"
weight = 2

[[menu.main]]
name = "About"
url = "/about"
weight = 3

[[menu.main]]
name = "Tags"
url = "/tags"
weight = 4
EOF

hugo new posts/test.md
cat >> content/posts/test.md <<EOF
This is a test page.
EOF
sed -i -e '/title = /atag = ["example"]' content/posts/test.md

hugo new posts/another.md
cat >> content/posts/another.md <<EOF
Another page.
EOF
sed -i -e '/title = /atag = ["programming"]' content/posts/another.md

hugo new about.md
cat >> content/about.md << EOF
Something about me
EOF

# TODO: permalinks
# TODO: rss
