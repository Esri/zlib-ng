project "zlib-ng"

dofile(_BUILD_DIR .. "/static_library.lua")

configuration { "*" }

uuid "76FC1997-C8C8-4D03-9853-A02FEBFC0043"

includedirs {
  ".",
}

defines {
    "ZLIB_COMPAT",
    -- Support for gzfileops was included by default in the prev zlib library, but this functionality is not used in rtc, so safe to turn off.
    --"WITH_GZFILEOP"
}

local intel_defines = {
  "X86_FEATURES",
  "X86_SSE2",
  "X86_SSSE3",
  "X86_SSE42",
  "X86_PCLMULQDQ_CRC",
  "X86_AVX2",
  "X86_AVX512",
  "X86_AVX512VNNI",
  "X86_VPCLMULQDQ_CRC"
}

files  {
    "adler32.c",
    "arch/generic/adler32_c.c",
    "arch/generic/adler32_fold_c.c",
    "arch/generic/chunkset_c.c",
    "arch/generic/compare256_c.c",
    "arch/generic/slide_hash_c.c",
    "arch/generic/crc32_fold_c.c",
    "arch/generic/crc32_braid_c.c",
    "cpu_features.c",
    "crc32.c",
    "compress.c",
    "deflate.c",
    "deflate_fast.c",
    "deflate_huff.c",
    "deflate_medium.c",
    "deflate_quick.c",
    "deflate_rle.c",
    "deflate_slow.c",
    "deflate_stored.c",
    "functable.c",
--  "gzlib.c",
--  "gzread.c",
--  "gzwrite.c",
--  "infback.c",
--  "inffast.c",
    "inflate.c",
    "inftrees.c",
    "insert_string.c",
    "insert_string_roll.c",
    "trees.c",
    "uncompr.c",
    "zutil.c",
    -- x86 specific files, conditionally enabled via #ifdef directives in source
    "arch/x86/x86_features.c",
    "arch/x86/chunkset_sse2.c",
    "arch/x86/compare256_sse2.c",
    "arch/x86/slide_hash_sse2.c",
    "arch/x86/adler32_ssse3.c",
    "arch/x86/chunkset_ssse3.c",
    "arch/x86/adler32_sse42.c",
    "arch/x86/crc32_pclmulqdq.c",
    "arch/x86/slide_hash_avx2.c",
    "arch/x86/chunkset_avx2.c",
    "arch/x86/compare256_avx2.c",
    "arch/x86/adler32_avx2.c",
    "arch/x86/adler32_avx512.c",
    "arch/x86/chunkset_avx512.c",
    "arch/x86/adler32_avx512_vnni.c",
    "arch/x86/crc32_vpclmulqdq.c",
}

if (_PLATFORM_ANDROID) then
  defines {
    "HAVE_ATTRIBUTE_ALIGNED"
  }

  -- Define a limited subset
  configuration {"*x86* or *x64*"}
  defines {
    "X86_FEATURES",
    "X86_SSE2",
    "X86_SSSE3"
  }
end

if (_PLATFORM_IOS) then
  defines {
    "HAVE_ATTRIBUTE_ALIGNED"
  }

  configuration { "*catx64* or *simx64*" }
  defines {
    "X86_FEATURES",
    "X86_SSE2",
    "X86_SSSE3"
  }
end

if (_PLATFORM_LINUX) then
  defines {
    "HAVE_ATTRIBUTE_ALIGNED"
  }

  configuration { "x64"}
  defines {
    "X86_FEATURES",
    "X86_SSE2",
    "X86_SSSE3"
  }
end

if (_PLATFORM_MACOS) then
  defines {
    "HAVE_ATTRIBUTE_ALIGNED"
  }

  configuration { "x64"}
  defines { intel_defines }
end

if (_PLATFORM_WINDOWS) then
  configuration { "x32 or x64" }
  defines { intel_defines }
end

if (_PLATFORM_WINUWP) then
end
