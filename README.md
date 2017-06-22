# Perl 6 bindings for TCC

See eg/testit.pl6

```
use TCC;

my $tcc = TCC.new;

sub add(int32 $a, int32 $b --> int32)
{
    return $a + $b;
}

$tcc.compile:
'
    #include <stdio.h>

    int x = 7;

    int add(int a, int b);
    int fib(int n)
    {
        if (n <= 2)
            return 1;
        else
            return fib(n-1) + fib(n-2);
    }

    int foo(int n)
    {
        printf("Hello World!\n");
        printf("fib(%d) = %d\n", n, fib(n));
        printf("add(%d, %d) = %d\n", n, 2 * n, add(n, 2 * n));
        return 0;
    }

    void set_x(int n)
    {
        x = n;
    }
';

$tcc.add-symbol(&add);

$tcc.relocate;

my &fib   := $tcc.bind('fib', :(int32 --> int32));
my &foo   := $tcc.bind('foo', :(int32 --> int32));
my &set_x := $tcc.bind('set_x', :(int32));
my $x     := $tcc.bind('x', int32);

say fib(12);

say foo(17);

say $x;

set_x(12345);

say $x;

# $x = 123;  # Can't do this
```

Assuming you've got libtcc.so (not just libtcc.a!) installed,
running eg/testit.pl6 should output this:

```
144
Hello World!
fib(17) = 1597
add(17, 34) = 51
0
7
12345
```

add-symbol is currently broken.  It is hardcoded so the only type of
signature you can use is a function which takes two integers and
returns an integer (so the example works!)

Binding of variables is one way only, you can read C symbols, not
set them.

Check out
[NativeCall](https://github.com/rakudo/rakudo/blob/nom/lib/NativeCall.pm6)
It has everything you need to do this right.
