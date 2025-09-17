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

local clang_defines = {
  -- clang supports __attribute__((aligned(x)))
  "HAVE_ATTRIBUTE_ALIGNED",
  -- clang supports the builtins __builtin_ctz and __builtin_ctzll
  "HAVE_BUILTIN_CTZ", -- Needed to enable compare256_sse2.c
  "HAVE_BUILTIN_CTZLL", -- Needed to enable compare256_neon.c
}

-- Enable support for Intel CPU intrinsics up to SSSE3.
-- zlib-ng supports more advanced Intel CPU intrinsics, and can enable support dynamically based on the detected CPU
-- features. However, to support this in premake, we would need to be able to specify different build flags for
-- different files, which is not supported directly in premake 4.
local intel_defines_basic = {
  "X86_FEATURES",
  "X86_SSE2",
  "X86_SSSE3",
}

-- Enable support for NEON intrinsics on ARM
local arm_defines_neon = {
  "ARM_FEATURES",
  "ARM_NEON",
  "ARM_NEON_HASLD4",
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
    "crc32_braid_comb.c",
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
    -- ARM specific files, conditionally enabled via #ifdef directives in source
    "arch/arm/arm_features.c",
    "arch/arm/adler32_neon.c",
    "arch/arm/chunkset_neon.c",
    "arch/arm/compare256_neon.c",
    "arch/arm/slide_hash_neon.c",
}

if (_PLATFORM_ANDROID) then
  defines { clang_defines }

  configuration {"*x86* or *x64*"}
  defines { intel_defines_basic }

  configuration { "*armv7* or *arm64*" }
  defines { arm_defines_neon }
end

if (_PLATFORM_IOS) then
  defines { clang_defines }

  configuration { "*catx64* or *simx64*" }
  defines { intel_defines_basic }

  configuration { "*_arm64_* or *catarm64* or *simarm64*" }
  defines { arm_defines_neon }
end

if (_PLATFORM_LINUX) then
  defines { clang_defines }

  configuration { "x64"}
  defines { intel_defines_basic }

  configuration { "ARM64"}
  defines { arm_defines_neon }
end

if (_PLATFORM_MACOS) then
  defines { clang_defines }

  configuration { "x64"}
  defines { intel_defines_basic }

  configuration { "ARM64" }
  defines { arm_defines_neon }
end

if (_PLATFORM_WINDOWS) then
  configuration { "x32 or x64" }
  defines { intel_defines_basic }

  configuration { "ARM64"}
  defines { arm_defines_neon }
end

if (_PLATFORM_WINUWP) then
end
