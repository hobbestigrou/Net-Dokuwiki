=head1 NAME

Net::Dokuwiki - A Perl interface to the Dokuwiki XMLRPC API

=head1 VERSION 

Net::Dokuwiki 0.1 

=head1 DESCRIPTION
 
This module provides a Perl interface to the Dokuwiki API. See l<http://dokuwiki.org/devel::xmlrpc> 
for a full description of the Dokuwiki API.

=cut 

package Net::Dokuwiki;

use strict;
use warnings;
use XMLRPC::Lite;
use Carp;
use Data::Dumper;

our $VERSION = '0.1';

sub new {
    my $class  = shift;
    my %params = @_;
    my $self   = {};
    
    $self->{'url'}             = $params{'url'};
    $self->{'user'}            = $params{'user'};
    $self->{'password'}        = $params{'password'};
    $self->{'http_basic_auth'} = $params{'http_basic_auth'};
    bless $self, $class;
}

sub dokuwiki($$;@) {
    my ( $self, $method, @args ) = @_;

    my $api_response;
    my $proto;
    my $url;

    my $dokuwiki_api = '/lib/exe/xmlrpc.php';
    $self->{'url'}  .= $dokuwiki_api;
    my $proxy        = XMLRPC::Lite->proxy($self->{'url'});

    if ( $self->{'http_basic_auth'} ) {
        ( $proto, $url ) = split(/:\/\//, $self->{'url'});
        $url = $proto . "://" . $self->{'user'} . ":" . $self->{'password'} . '@' . $url;
        $proxy = XMLRPC::Lite->proxy($url);
    } 
    
    if ( scalar(@args) > 0 ) {
        eval {
            $api_response = $proxy->call($method, @args);
        };
    }

    else {
        eval {
            $api_response = $proxy->call($method);
        };
    }

    if ( !$api_response ) {
        croak $@, "\n";
    }

    if ( $api_response->faultstring() ) {
        croak $api_response->faultstring(), "\n";
    }
    
    return $api_response->result();
}

sub dokuwiki_version {
    my $self = shift;

    return $self->dokuwiki('dokuwiki.getVersion');
}

sub dokuwiki_time {
    my $self = shift;

    return $self->dokuwiki('dokuwiki.getTime');
}

sub dokuwiki_XMLRPCAPIVersion {
    my $self = shift; 

    return $self->dokuwiki('dokuwiki.getXMLRPCAPIVersion');
}

sub dokuwiki_getRPCVersionSupported {
    my $self = shift; 

    return $self->dokuwiki('wiki.getRPCVersionSupported');
}

sub get_page {
    my ( $self, $page_name, $timestamp ) = @_;

    if ( $timestamp ) {
        return $self->dokuwiki('wiki.getPageVersion', $page_name, $timestamp);
    }

    else {
        return $self->dokuwiki('wiki.getPage', $page_name);
    }
}

sub get_page_info {
    my ( $self, $page_name, $timestamp ) = @_;

    if ( $timestamp ) {
        return $self->dokuwiki('wiki.getPageInfoVersion', $page_name, $timestamp);
    }
    else {
        return $self->dokuwiki('wiki.getPageInfo', $page_name);
    }
}

sub get_page_HTML {
    my ( $self, $page_name, $timestamp ) = @_;

    if ( $timestamp ) {
        return $self->dokuwiki('wiki.getPageHTMLVersion', $page_name, $timestamp);
    }
    else {
        return $self->dokuwiki('wiki.getPageHTML', $page_name);
    }
}

sub list_links {
    my ( $self, $page_name ) = @_;

    return $self->dokuwiki('wiki.listLinks', $page_name);
}

sub get_back_links_page {
    my ( $self, $page_name ) = @_;
    
    return $self->dokuwiki('wiki.getBackLinks', $page_name);
}

sub get_ALL_pages {
    my $self = shift; 
   
    return $self->dokuwiki('wiki.getAllPages');  
}

sub get_recent_changes {
    my ( $self, $timestamp ) = @_;

    return $self->dokuwiki('wiki.getRecentChanges', $timestamp);
}

1; 
