import os
import sys

# Initialize the environment using the godot-cpp SConstruct rules
env = SConscript("godot-cpp/SConstruct")

# Include our source directory for headers
env.Append(CPPPATH=["src/"])

# Collect all C++ source files
sources = Glob("src/*.cpp")

# Define the output path based on the OS platform and target
if env["platform"] == "macos":
    library = env.SharedLibrary(
        "fsm-demo/bin/libstate_machine.{}.{}.framework/libstate_machine.{}.{}".format(
            env["platform"], env["target"], env["platform"], env["target"]
        ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "fsm-demo/bin/libstate_machine{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
