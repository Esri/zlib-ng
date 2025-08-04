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
end

if (_PLATFORM_IOS) then
  defines {
    "HAVE_ATTRIBUTE_ALIGNED"
  }
end

if (_PLATFORM_LINUX) then
  defines {
    "HAVE_ATTRIBUTE_ALIGNED"
  }
end

if (_PLATFORM_MACOS) then
  defines {
    "HAVE_ATTRIBUTE_ALIGNED"
  }
end

local intel_defines = {
  "X86_FEATURES",

  -- Disable X86_HAVE_XSAVE_INTRIN because the XSAVE instructions were added with the Penryn microarchitecture
  -- beginning August 2008 [1] which is newer than our current minimum of the Core microarchitecture from June 2006 [2][3].
  -- [1] https://en.wikipedia.org/wiki/Penryn_(microarchitecture)#:~:text=Stepping%20E0/R0%20adds%20two%20new%20instructions%20(XSAVE/XRSTOR)
  -- [2] https://en.wikipedia.org/wiki/SSSE3#:~:text=SSSE3%20was%20first%20introduced%20with%20Intel%20processors%20based%20on%20the%20Core%20microarchitecture%20on%20June%2026%2C%202006
  -- [3] https://devtopia.esri.com/runtime/devops/issues/987
  --"X86_HAVE_XSAVE_INTRIN",

  "X86_SSE2",
  "X86_SSSE3",
  "X86_SSE42",
  "X86_PCLMULQDQ_CRC",
  "X86_AVX2",
  "X86_AVX512",
  "X86_AVX512VNNI",
  "X86_VPCLMULQDQ_CRC"
}

if (_PLATFORM_WINDOWS) then
  configuration { "x32 or x64" }

  defines { intel_defines }

  -- NB: On Windows, the zlib-ng cmake configuration adds the /arch:AVX2 and /arch:AVX512 flags to the msvc build flags
  -- for the files that use AVX2 and AVX512 intrinsics.
  -- This is a problem with premake because it does not support setting different build flags at the file level.
  -- However, I don't think these flags are actually necessary, because the cpu intrinsics are used via explicit
  -- function calls. (See Raymond Chen's comment on this Stack Overflow question for context:
  -- https://stackoverflow.com/q/57823543)
end

if (_PLATFORM_WINUWP) then
end
