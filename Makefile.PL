use inc::Module::Install;

name     'Twitter-CLI';
all_from 'lib/Twitter/CLI.pm';

install_script 'twitter_cli';

author   'Seth Viebrock <sviebrock@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

