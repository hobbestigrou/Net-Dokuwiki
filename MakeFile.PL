use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Net::Dokuwiki', 
    VERSION_FROM => 'lib/Net/Dokuwiki.pm',
    PREREQ_PM    => {
        XMLRPC::Lite => 0,
    },
);
