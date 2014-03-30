package MyWeb::App;
use Dancer ':syntax';
use Net::Twitter::Lite::WithAPIv1_1;
use Scalar::Util 'blessed';
use Data::Dumper;
use Template;
use Array::Utils qw(:all);
#use List::Compare;
use List::MoreUtils qw(zip);
#use JSON -support_by_pp;
#use JSON;
use warnings;
use utf8;
use allow_nonref;

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
# my @arr1 = $nt->friends_list({ screen_name => 'featherart' });
# my @arr2 = $nt->friends_list({ screen_name => 'hansflorine' });
my $tweet = $nt->friends_list({ screen_name => 'featherart' });


my $json = to_json $tweet;

#print "$json\n";
# my  = shift;
#   my $json_output = to_json(@tweet, {utf8 => 1});
  # print $json;
  # print "\n";

# my $perl_scalar = from_json($json);
# print "$perl_scalar\n";
  
my $json_text = allow_nonref->utf8($json);
print "$json_text\n";


#print "$json->{users}{screen_name}\n";
# print "@data\n";
# print Dumper (\@data);

# this gives key: HASH(0x7fb3aa516968), value: 
#my @json = ();

# foreach my $key ( keys %data )
# {
#   my %key = $key;
#   foreach my $k ( keys %key )
#   {
#     #print "key: $k, value: $key{$k}\n"
#     my $perl_scalar = from_json($k);
#   }
# }


# Global symbol "%key" requires explicit package name
#print "key: $key, value: $data{$key}\n";
  # my $perl_scalar = from_json($key);

# foreach my $elem (@data)
# {
#   #print Dumper(\$elem);
#   print "$elem\n";
#   #my @json = @{decode_json($elem)};
# }

#my $json_text = "screen_name";
# foreach my $elem (@data)
# {
#   my $perl_scalar = from_json($elem);
# }

#my $result = decode_json( $data );

# for my $report ( @{$result} ) {
#     print $report->{screen_name}, "\n";
# }

#my @json = @{decode_json($result)};
#my @json = decode_json($result);
#print "@json\n";
#my @objs = JSON::XS->new->incr_parse ("[5][7][1,2]");

#my $json = new JSON::XS;
 
# This is where I ended up
# malformed JSON string error -- ??
# foreach my $elem (@res1)
# {
#   my @obj = $json->incr_parse ($elem);
# }


# JSON -convert_blessed_universally;
# my $enabled = $res1->get_convert_blessed;
# print $enabled . "\n";
#my $perl_scalar = from_json(@res1);
# NOPE my $perl_scalar = decode_json $res1;
# NOPE my $perl_scalar = JSON->new->utf8(1)->decode($res1);

#print $perl_scalar ."\n";

# my $json = JSON->new->pretty;
# my $json_object = $json->decode($json_text);
 
# for my $item( @{$res1->{items}} ){
#     print $item->{name} . "\n";
# }

# my $json_text = "previous_cursor_str";
# my $perl_scalar = from_json($json_text, $res1);
# print "$perl_scalar\n";

# foreach my $elem (@arr1)
# {
#   $perl_scalar = from_json($json_text, $flag_hashref)
# }

#print Dumper(\$elem);
 #   print $elem;
#my %hash = @arr1;
# foreach my $key ( keys %hash )
# {
#   print "key: $key, value: $hash{$key}\n";
# }

# iterate over all keys:
# while ( my ($k, $v) = each %hash ) {
#     print "$k => $v\n";
# }


# print "@arr1\n";
# print Dumper(\@arr1);
# at this point it's still correctly formatted
# according to data dumper, but causes runtime error  
#my @merged = zip(@arr1, @arr2); 
#my @unique = keys { map { $_ => 1 } @merged };

# this gives the right result set
# but no longer good format & causes runtime error
#my @unique = eval { unique(@merged) };

# this did not work AT ALL
# my $lc = List::Compare->new( \@arr1, \@arr2 );
# my @intersection = $lc->get_intersection;


# print "@++++++unique++++++++++@@@\n";
#print Dumper(\@unique);
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
  
  my @res1 = $nt->friends_list({ screen_name => $name1 });
  my @res2 = $nt->friends_list({ screen_name => $name2 });
  
  # derp! This returns the correct result set
  # but I get a weird runtime error that no one on Stack Overflow has seen
  # Just not sure at all what to do next ...
  # my @all = zip(@res1, @res2);
  # my @uniq = eval { unique(@all) };

  # my @unique = do { my %seen; grep { !$seen{$_}++ } @all };

  set template => 'template_toolkit';

  template 'user_results' => {
      name1 => $name1,
      name2 => $name2,
      response1 => @res1,
      response2 => @res2
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
