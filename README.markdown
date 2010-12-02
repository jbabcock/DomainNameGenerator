# DomainNameGenerator

A simple Ruby script that will combine a given baseword with a user-supplied wordlist to form domain names. It will then check these domain names via DNS queries, and optionally an additional check in WHOIS.

## Prerequisites
The following gems are used in DomainNameGenerator:
<ul>
<li><a href="http://rubyforge.org/projects/dnsruby">Dnsruby</a></li>
<li><a href="https://github.com/weppos/whois">Whois</a></li>
</ul>
A Gemfile is included, so if you have Bundler you may also just do: <pre>bundle install</pre>

## Usage
>#### !!! Important Note !!!
>While the script comes with a default pause of a couple seconds between small batches of DNS queries (and optional WHOIS queries), it does not meter them in any way. You take all responsibility for running these queries. Don't complain to me if your provider gets angry at you running 20,000 DNS queries or you get blacklisted for too many WHOIS queries.

First, put DomainNameGenerator.rb and a wordlist.txt (containing a list of words, each on a new line) in the same directory. Then run it like so:
<pre>$ ruby DomainNameGenerator.rb your_desired_base_word</pre>
This will give output resembling (in this example, <em>redyour_desired_base_word.com</em> is taken and so not returned):
<pre>Searching for domain for word: your_desired_base_word
Using whois? : false
-------------------------
orangeyour_desired_base_word.com
your_desired_base_wordorange.com
your_desired_base_wordred.com
</pre>
To further filter results with the optional WHOIS query (only run if there is no DNS record returned, as an additional check to see if the domain is available), add <em>-w</em> or <em>--whois</em> to the command. Example:
<pre>$ ruby DomainNameGenerator.rb -w your_desired_base_word</pre>

## License
The source code is released under the Modified BSD License. See the LICENSE file for details.

## Author
[Jeremy Babcock](http://www.jeremybabcock.com) - jeremy@jeremybabcock.com
