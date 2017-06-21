use v6;

use NativeCall;

constant LIB = 'tcc';

constant TCC_OUTPUT_MEMORY = 1;
constant TCC_RELOCATE_AUTO = 1;

class TCC is repr('CPointer')
{
    sub tcc_new() returns TCC is native(LIB) {...}

    sub tcc_delete(TCC) is native(LIB) {...}

    sub tcc_set_output_type(TCC, int32) returns int32 is native(LIB) {...}

    sub tcc_compile_string(TCC, Str) returns int32 is native(LIB) {...}

    sub tcc_relocate(TCC, int64) returns int32 is native(LIB) {...}

    sub tcc_add_symbol(TCC, Str, &callback (int32, int32 --> int32) )
        is native(LIB) {...}

    sub tcc_get_symbol(TCC, Str) returns Pointer is native(LIB) {...}

    method new()
    {
        my $self = tcc_new;
        tcc_set_output_type($self, TCC_OUTPUT_MEMORY);
        $self
    }

    method compile(Str $code)
    {
        if tcc_compile_string(self, $code) == -1
        {
            die "Failed to compile [$code]";
        }
    }

    # This is broken, you can only add functions with the signature
    # (int32, int32 --> int32)
    method add-symbol(&callback)
    {
        tcc_add_symbol(self, &callback.name, &callback);
    }

    method bind(Str $name, Signature $sig)
    {
        state $relocated = 0;

        tcc_relocate(self, TCC_RELOCATE_AUTO) unless $relocated++;

        my $fptr = tcc_get_symbol(self, $name)
            or die "Couldn't find $name";

        nativecast($sig, $fptr);
    }

    method DESTROY() { tcc_delete(self) }
}
