package DBIx::Class::Schema::Critic::Types;

use strict;
use utf8;
use Modern::Perl;

our $VERSION = '0.005';    # VERSION
use MooseX::Types -declare => [qw(DBICType Policy LoadingSchema)];
use MooseX::Types::Moose 'ArrayRef';
use MooseX::Types::DBIx::Class qw(ResultSet ResultSource Row Schema);
use namespace::autoclean -also => qr{\A _}xms;
## no critic (ProhibitCallsToUnexportedSubs,ProhibitCallsToUndeclaredSubs)
## no critic (ProhibitBitwiseOperators)

role_type Policy, { role => 'DBIx::Class::Schema::Critic::Policy' };

subtype LoadingSchema, as Schema;
coerce LoadingSchema, from ArrayRef, via {
    my $loader = Moose::Meta::Class->create_anon_class(
        superclasses => ['DBIx::Class::Schema::Loader'] )->new_object();
    $loader->loader_options( naming => 'v4', generate_pod => 0 );
    local $SIG{__WARN__} = sub {
        if ( $_[0] !~ / has no primary key at /ms ) { print {*STDERR} $_[0] }
    };
    $loader->connect( @{$_} );
};

subtype DBICType, as ResultSet | ResultSource | Row | Schema;

__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: Type library for DBIx::Class::Schema::Critic

__END__

=pod

=for :stopwords Mark Gardner cpan testmatrix url annocpan anno bugtracker rt cpants
kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

DBIx::Class::Schema::Critic::Types - Type library for DBIx::Class::Schema::Critic

=head1 VERSION

version 0.005

=head1 SYNOPSIS

    use Moose;
    use DBIx::Class::Schema::Critic::Types qw(Policy LoadingSchema);

    has policy => (isa => Policy);
    has schema => (isa => LoadingSchema);

=head1 DESCRIPTION

This is a L<"Moose type library"|MooseX::Types> for
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=head1 TYPES

=head2 Policy

An instance of a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.

=head2 LoadingSchema

A subtype of
L<MooseX::Types::DBIx::Class::Schema|MooseX::Types::DBIx::Class>
that can create new schemas from an array reference containing a DSN, user name,
password, and hash references to attributes recognized by L<DBI|DBI> and
L<DBIx::Class|DBIx::Class>.

=head2 DBICType

An instance of any of the following:

=over

=item L<DBIx::Class::ResultSet|DBIx::Class::ResultSet>

=item L<DBIx::Class::ResultSource|DBIx::Class::ResultSource>

=item L<DBIx::Class::Row|DBIx::Class::Row>

=item L<DBIx::Class::Schema|DBIx::Class::Schema>

=back

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc DBIx::Class::Schema::Critic

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/DBIx-Class-Schema-Critic>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annonations of Perl module documentation.

L<http://annocpan.org/dist/DBIx-Class-Schema-Critic>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/DBIx-Class-Schema-Critic>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.perl.org/dist/overview/DBIx-Class-Schema-Critic>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/D/DBIx-Class-Schema-Critic>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual way to determine what Perls/platforms PASSed for a distribution.

L<http://matrix.cpantesters.org/?dist=DBIx-Class-Schema-Critic>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=DBIx::Class::Schema::Critic>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at L<https://github.com/mjgardner/DBIx-Class-Schema-Critic/issues>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/mjgardner/DBIx-Class-Schema-Critic>

  git clone git://github.com/mjgardner/DBIx-Class-Schema-Critic.git

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Mark Gardner.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
