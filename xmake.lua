add_rules("mode.debug", "mode.release")

if is_mode("debug") then
    set_runtimes("MDd")
else
    set_runtimes("MD")
end

add_requires("gtest", { configs = {main = true} })

target("compact_enc_det")
    set_kind("static")
    add_headerfiles("include/(**.h)")
    add_includedirs("include", {public = true})
    add_files(
        "src/compact_enc_det/compact_enc_det.cc",
        "src/compact_enc_det/compact_enc_det_hint_code.cc",
        "src/compact_enc_det/util/encodings/encodings.cc",
        "src/compact_enc_det/util/languages/languages.cc"
    )

target("compact_enc_det_test")
    set_kind("binary")
    set_default(false)
    add_deps("compact_enc_det")
    add_files(
        "src/compact_enc_det/compact_enc_det_unittest.cc",
        "src/compact_enc_det/compact_enc_det_fuzz_test.cc",
        "src/compact_enc_det/util/encodings/encodings_unittest.cc"
    )
    if is_plat("windows") then
        -- fixes "LINK : fatal error LNK1561: entry point must be defined"
        add_ldflags("/subsystem:console")
    end
    add_packages("gtest")

task("test")
    set_menu{
        usage = "xmake test",
        description = "Run tests",
        options = {}
    }
    on_run(function (target)
        os.exec("xmake run compact_enc_det_test")
    end)
