# Perl 6 bindings for TCC

See eg/testit.pl6


add-symbol is currently broken.  It is hardcoded so the only type of
signature you can use is a function which takes two integers and
returns an integer (so the example works!)

For now you have to manually write a store function if you want
two-way variable binding.  Could probably do this automatically.

Check out
[NativeCall](https://github.com/rakudo/rakudo/blob/nom/lib/NativeCall.pm6)
It has everything you need to do this right.
