package MyWeb::App;
use Dancer ':syntax';
use Net::Twitter::Lite::WithAPIv1_1;
use Scalar::Util 'blessed';
use Data::Dumper;
use Template;
use Array::Utils qw(:all);
use List::Compare;
use List::MoreUtils qw(zip);

our $VERSION = '0.1';
my $consumer_key = $ENV{'TWITTER_KEY'};
my $consumer_secret = $ENV{'TWITTER_SECRET'};
my $access_token = $ENV{'TWITTER_TOKEN'};
my $access_token_secret = $ENV{'TWITTER_TOKEN_SECRET'};


my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
      consumer_key        => $consumer_key,
      consumer_secret     => $consumer_secret,
      access_token        => $access_token,
      access_token_secret => $access_token_secret,
      ssl                 => 1,
);

# this works SO BE CAREFUL!
#$nt->update('Hello World!');

print "*********r**********\n";
#my $doh = $nt->lookup_users({ screen_name => 'featherart,hansflorine' });
#my $doh = $nt->list_statuses(screen_name =>'featherart');
#my $doh = $nt->friends_list({ screen_name => 'featherart' });
# my $doh = $nt->lookup_users({ screen_name => $name });
#my $doh = $nt->lookup_users({ screen_name => 'featherart' });
#print Dumper $doh;
# my @r = eval { $nt->friends_list({ screen_name => 'featherart' }) };
# my @s = eval { $nt->friends_list({ screen_name => 'hansflorine' }) };
#my @r = $nt->friends_list({ screen_name => 'featherart' });
#my @s = $nt->friends_list({ screen_name => 'hansflorine' });
# print "\@r:  @r\n";
# print "\@s: @s\n";
#print Dumper(\@r);
# my @arr1 = qw/5 8 12 42 99 10/;
# my @arr2 = qw/10 20 12 18 99 10/;

# my $lc = List::Compare->new( \@r, \@s );

# my @arr1Only = $lc->get_Lonly;
# print "\@arr1 only: @arr1Only\n";
#my @merged = eval { zip(@r, @s) };
# my @unique = unique(@merged);
#my @unique = keys { map { $_ => 1 } @data };

# print "@++++++unique++++++++++@@@\n";
#print Dumper(\@merged);
# print "@++++++++++++++++@@@\n";
# my $lc = List::Compare->new( {
#         lists    => [\@r, \@s],
#         unsorted => 1,
#     } );
# my @intersection = $lc->get_intersection;
# print "\@instersection: @intersection\n";
# intersection, nope
# my @i = intersect(@r, @s);
# print scalar @i;
# print @i;

# for my $el (@i) {
#   print $el . "\n";
# };
print "@++++++++++++++++@@@\n";

get '/' => sub {
    # default welcome page
    template 'hello';
};

post '/find_tweets' => sub {

  my $name = params->{name}; 
  my @r = eval { $nt->user_timeline({ screen_name => $name }) };

  set template => 'template_toolkit';
  
  template 'find_tweets' => {
      name => $name,
      response => @r
  };
};

# still need to get query right
post '/user_results' => sub {
  my $name1 = params->{name1};
  my $name2 = params->{name2};
  
  my @r = eval {$nt->friends_list({ screen_name => $name1 })};
  my @s = $nt->friends_list({ screen_name => $name2 });
  
  #my @all = zip(@r, @s);
  # my @uniq = eval { unique(@all) };

  set template => 'template_toolkit';

  template 'user_results' => {
      name1 => $name1,
      name2 => $name2,
      response => @r
  };
};

# to test out routes & params passing
get '/hello/:name' => sub {
  my $name = params->{name};

  template 'hello' => {
      name => $name,
  };
};

true;
