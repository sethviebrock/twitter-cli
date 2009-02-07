package Twitter::CLI::Plugin;
use Moose;
=pod

=head1 NAME

Twitter::CLI::Plugin -- how Twitter::CLI plugins work

=head1 DESCRIPTION

    -----In the plugin .pm file (note the namespace)------
    package Twitter::CLI::Plugin::Prompting;
    use Moose::Role;

    has some_attribute => (is => 'ro', isa => 'String', default => sub {"some attribute"});
    
    sub run {
        print "This totally runs everything!";
    }
    
    -----In the twitter_cli file------
    #Use the default interface and plugin provided with Net::Twitter::CLI:
    use Twitter::CLI::Interface::Default;
    my $twitter_cli = Twitter::CLI::Interface::Default->new;

    #Load plugins:
    $twitter_cli->load_plugin('Prompting');
    $twitter_cli_app->run;# run() is defined in the plugin
    
    OR
    
    #Use your own interface and plugin(s):
    use Twitter::CLI::Interface::SomeInterfaceYouDesigned;
    my $twitter_cli_app = Twitter::CLI::Interface::SomeInterfaceYouDesigned->new;

    #Load plugins:
    $twitter_cli_app->load_plugin('SomePluginYouDesigned');
    $twitter_cli_app->run;# run() is defined in the plugin

=head2 C<< ::Plugin usage >>

The code above should be sufficiently illustrative. For more information,
see MooseX::Object::Pluggable on CPAN and look at the source code.

=head1 AUTHOR

Seth Viebrock C<< <sviebrock at cpan.org> >>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
1;