package Dicole::Backup::Util;

use Log::Any qw/$log/;
use Data::Dump qw/dump/;
use IPC::Run ();
use Exporter 'import';
use Path::Class qw/file dir/;

our @EXPORT = qw/run timestamp_from_filename timestamped_file_name/;

sub run {
    my @command = @_;

    $log->debug('Running command: ' . dump(\@command));

    IPC::Run::run(@command) unless main::opt()->dry_run;
}

sub timestamp_from_filename {
    my $filename = shift;

    my ($timestamp) = $filename =~ m,\.([^\.]+)\.[^.]+$,;

    return DateTime::Format::CLDR->new(pattern => "yyyy-mm-dd-HH-mm-ss")->parse_datetime($timestamp);
}

sub timestamped_file_name {
    my ($original, $suffix) = @_;

    my $now = DateTime->now;

    my $timestamp = $now->ymd('-') . $now->hms('-');

    "$original.$timestamp.$suffix"
}

1;
