#!/usr/bin/env perl
my $tables = {
sys_user => user => (),
dicole_events_event => meeting => (),
dicole_events_user => meeting_participant => (),
dicole_meetings_draft_participant => meeting_draft_participant => (),
dicole_meetings_matchmaker => matchmaker => (),
dicole_meetings_matchmaker_url => matchmaker_url => (),
dicole_meetings_matchmaking_event => matchmaking_event => (),
dicole_meetings_partner => partner => (),
dicole_meetings_meeting_suggestion => suggested_meeting => (),
dicole_meetings_trial => trial => (),
dicole_meetings_subscription => user_subscription => (),
dicole_meetings_paypal_transaction => user_subscription_transaction => (),
dicole_meetings_company_subscription => company_subscription => (),
dicole_meetings_company_subscription_user => company_subscription_user => (),
dicole_meetings_user_activity => user_activity => (),
dicole_meetings_scheduling => scheduling => (),
dicole_meetings_scheduling_answer => scheduling_answer => (),
dicole_meetings_scheduling_option => scheduling_option => (),
};

my $remove_columns = {
  user => [ qw(
    removal_date
    login_disabled
    last_login
    latest_activity
    starting_page
    dicole_theme
    incomplete
    external_auth
    custom_starting_page
  ) ]
};

my $db = $ARGV[0];

system mysql => -e => "UPDATE $db.sys_user set password = '', inv_secret = ''";

system mysql => -e => "DROP DATABASE IF EXISTS miner_data";
system mysql => -e => "CREATE DATABASE miner_data";

for my $table ( keys %$tables ) {
system mysql => -e => "RENAME TABLE $db.$table to miner_data.$table";
}

system "mysqldump miner_data | mysql $db";

for my $table ( keys %$tables ) {
system mysql => -e => "RENAME TABLE miner_data.$table to miner_data." . $tables->{$table};
}

for my $table ( keys %$remove_columns ) {
  for my $column ( @{ $remove_columns->{ $table } } ) {
    system mysql => -e => "ALTER TABLE miner_data.$table drop $column";
  }
}

system mysql => -e => "GRANT ALL ON miner_data.* TO miner\@'%' IDENTIFIED BY 'miner'";
system mysql => -e => "FLUSH PRIVILEGES";

